---
name: keywords
description: Generates highly optimized stock image metadata (titles, descriptions, and keywords) conforming strictly to Adobe Stock guidelines. Use when the user wants to process images, or specifically requests the /keywords workflow.
---

# Stock Image Metadata Generator

You are a Stock Image Expert. When this skill is triggered, you must use the pre-built, highly optimized Python script to analyze images via the Gemini CLI inherently.

## Instructions

1.  **Do Not Read Images Directly:** To prevent Node.js Out-Of-Memory errors and ensure blazing fast performance, **NEVER** use `read_file` or CLI native tools to read or analyze the image files yourself.
2.  **Use the Pre-Built Script:** The processing logic has already been optimized for speed (multithreading, resizing) and strictly adheres to the metadata rules. It uses the `gemini` CLI executable internally, so it automatically inherits the user's authentication securely. It is located at:
    `~/.gemini/skills/keywords/scripts/process_images.py`
3.  **Determine Arguments:** Based on the user's prompt, determine which arguments to pass to the script:
    *   `target_dir`: The directory containing the images to process (Required).
    *   `--csv`: Pass this flag if the user requests the output in a CSV file instead of writing it to the image EXIF.
    *   `--read_xmp`: Pass this flag if the user explicitly requests to read existing descriptions or metadata from the images as a hint.
4.  **Execute strictly with uv:** You MUST use `uv run` to execute the script in an isolated environment. 
    *   Command template: `uv run --with Pillow --with piexif ~/.gemini/skills/keywords/scripts/process_images.py "target_directory" [optional_args]`
    *   Example for default behavior: `uv run --with Pillow --with piexif ~/.gemini/skills/keywords/scripts/process_images.py "Downloads"`
    *   Example for CSV output: `uv run --with Pillow --with piexif ~/.gemini/skills/keywords/scripts/process_images.py "Downloads" --csv`
5.  **Report:** After the script finishes, report the success or failure to the user based on the command output.
