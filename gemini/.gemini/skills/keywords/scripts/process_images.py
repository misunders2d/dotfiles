import os
import argparse
import json
import concurrent.futures
from pathlib import Path
import subprocess
import tempfile
import shutil

try:
    from PIL import Image, ImageOps
except ImportError:
    print("Error: Pillow is required. Run via 'uv run --with Pillow ...'")
    exit(1)

PROMPT = """You are a Stock Image Expert. Analyze this image and generate metadata following these strict rules:

1. Return JSON with EXACTLY these keys: file_name, xp_title, xp_subject, xp_keywords.
2. xp_title: Phrase only, max 70 chars, no period at end, remove articles (a, an, the).
3. xp_subject: Phrase only, max 200 chars, MUST END WITH A PERIOD. Remove articles.
4. xp_keywords: 
   - EXACTLY 45-49 keywords.
   - ALL keywords MUST be SINGULAR FORM.
   - ALL keywords MUST be COMMA SEPARATED.
   - ONE WORD ONLY per keyword.
   - BANNED WORDS (DO NOT USE): stock, photo, video, vector, 3d, render, illustration, cartoon, rendering, photography, image, serene, peaceful, tranquil, calm, tranquility, whimsical, visual, unique.

Here is the file name: {filename}
"""

def extract_xmp(image_path):
    try:
        import piexif
        exif_dict = piexif.load(str(image_path))
        if 270 in exif_dict["0th"]:
            return exif_dict["0th"][270].decode("utf-8")
    except Exception:
        pass
    return ""

def process_single_image(args):
    file_path, tmp_dir, read_xmp = args
    filename = os.path.basename(file_path)
    
    try:
        # Resize image
        img = Image.open(file_path)
        img_resized = ImageOps.contain(img, (512, 512))
        
        # Save temp image
        ext = os.path.splitext(filename)[1].lower()
        if ext not in ['.jpg', '.jpeg', '.png']:
            ext = '.jpg'
        
        tmp_file = os.path.join(tmp_dir, f"tmp_{os.urandom(4).hex()}{ext}")
        if img.format == 'PNG':
            img_resized.save(tmp_file, format="PNG")
        else:
            img_resized.convert('RGB').save(tmp_file, format="JPEG")

        extra_hint = ""
        if read_xmp:
            xmp = extract_xmp(file_path)
            if xmp:
                extra_hint = f"\n\nHint from existing metadata: {xmp}"

        # Call Gemini CLI
        full_prompt = PROMPT.format(filename=filename) + extra_hint + f" @{tmp_file}"
        
        result = subprocess.run(
            ['gemini', full_prompt, '-o', 'json', '-m', 'gemini-2.5-flash'],
            capture_output=True, text=True
        )
        
        # Parse JSON
        try:
            data = json.loads(result.stdout)
            response_text = data.get('response', '')
            
            if '```json' in response_text:
                json_str = response_text.split('```json')[1].split('```')[0].strip()
                parsed = json.loads(json_str)
            else:
                parsed = json.loads(response_text)
                
            # Ensure the filename remains correct
            parsed['file_name'] = filename
            return parsed
        except Exception as parse_e:
            print(f"Error parsing JSON for {filename}: {parse_e}")
            print(f"CLI Output: {result.stdout}")
            return None

    except Exception as e:
        print(f"Error processing {filename}: {e}")
        return None
    finally:
        if 'tmp_file' in locals() and os.path.exists(tmp_file):
            os.remove(tmp_file)

def main():
    parser = argparse.ArgumentParser(description="Generate Stock Image Metadata")
    parser.add_argument("target_dir", help="Directory containing images")
    parser.add_argument("--csv", action="store_true", help="Output to CSV instead of EXIF")
    parser.add_argument("--read_xmp", action="store_true", help="Read existing EXIF description")
    
    args = parser.parse_args()
    
    target_dir = Path(args.target_dir)
    if not target_dir.is_dir():
        print(f"Error: Directory {target_dir} not found.")
        exit(1)
        
    valid_exts = {".jpg", ".jpeg", ".png", ".webp"}
    files = [str(p) for p in target_dir.iterdir() if p.suffix.lower() in valid_exts]
    
    if not files:
        print(f"No valid images found in {target_dir}")
        exit(0)
        
    print(f"Processing {len(files)} images...")
    
    tmp_dir = tempfile.mkdtemp()
    
    try:
        process_args = [(f, tmp_dir, args.read_xmp) for f in files]
        results = []
        
        with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
            for result in executor.map(process_single_image, process_args):
                if result:
                    results.append(result)
                    
        if not results:
            print("No valid results generated.")
            exit(1)

        if args.csv:
            import csv
            csv_path = target_dir / "data.csv"
            with open(csv_path, 'w', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                writer.writerow(["Filename", "Title", "Description", "Keywords"])
                for r in results:
                    writer.writerow([r.get("file_name"), r.get("xp_title"), r.get("xp_subject"), r.get("xp_keywords")])
            print(f"Successfully wrote metadata to {csv_path}")
        else:
            modified_dir = target_dir / "modified"
            modified_dir.mkdir(exist_ok=True)
            
            exiftool_json = []
            for r in results:
                filename = r.get("file_name")
                if not filename:
                    continue
                orig_path = target_dir / filename
                new_path = modified_dir / filename
                
                # Copy file
                try:
                    shutil.copy2(orig_path, new_path)
                except Exception as e:
                    print(f"Error copying {filename}: {e}")
                    continue
                
                # Create exiftool entry
                exiftool_json.append({
                    "SourceFile": str(new_path),
                    "XMP-dc:Title": r.get("xp_title", ""),
                    "XMP-dc:Description": r.get("xp_subject", ""),
                    "XMP-dc:Subject": r.get("xp_keywords", "")
                })
                
            json_path = modified_dir / "metadata.json"
            with open(json_path, 'w', encoding='utf-8') as f:
                json.dump(exiftool_json, f)
                
            print("Applying EXIF data...")
            subprocess.run(["exiftool", "-j=" + str(json_path), "-overwrite_original", str(modified_dir)], check=True)
            print(f"Successfully processed {len(results)} images in {modified_dir}")
            json_path.unlink(missing_ok=True)
    finally:
        shutil.rmtree(tmp_dir)

if __name__ == "__main__":
    main()