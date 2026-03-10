# Stock Image Metadata Rules

You must strictly adhere to the following rules when generating metadata. **EVERY detail matters.**

## Output Format

Always return your response in JSON format. The keys in the JSON must be exactly: `file_name`, `xp_title`, `xp_subject`, `xp_keywords`.
The `file_name` should be the name of the file being processed.

**Schema with Examples:**
```json
{
  "file_name": "example.jpg",
  "xp_title": "Natural linen fabric texture. Flaxen circular spiral textile background",
  "xp_subject": "Natural linen fabric texture. Flaxen circular spiral textile background, top view. Rough twisted burlap.",
  "xp_keywords": "linen, fabric, texture, spiral, background, textile, burlap, natural, swirl, flaxen, flax, rough, material, canvas, backdrop, surface, textured, twist, closeup, fiber, crumpled, vintage, wallpaper, weave, grunge, soft, gray, beige, sack, woven, wave, rustic, sackcloth, crease, rumpled, weaving, wrinkled, top view, cotton, tablecloth, old, abstract, design, structure, twisted, fold, fashion, twirl, circular"
}
```

## Titles (`xp_title`)
- Short, factual descriptions of content.
- Limit to 70 characters or fewer.
- **DO NOT** use formal sentence structures. Phrases only.
- **DO NOT** end the title with a period/dot.
- **REMOVE ALL ARTICLES** ("a", "an", "the"). (Wrong: "a card", Right: "card").
- **DO NOT** remove plural forms when required (e.g., use "boxes" if there are multiple boxes).
- **DO NOT** write unnecessary words. (Wrong: "arranged on black background", Right: "on black background").
- **DO NOT** start with unnecessary phrases like "close-up view", "overhead view", "illustration of", "image", "top view", "vector", or "close up".
- **DO NOT** use phrases like "create a luxurious mood". Use "luxurious mood".

## Descriptions (`xp_subject`)
- Limit to 200 characters or fewer.
- **CRITICAL**: The description MUST end with a period/dot (`.`).
- **Apply all rules from Titles**, including removing articles, avoiding unnecessary words and phrases, and keeping required plurals.
- Write only essential information. The first 5–6 words are critical.

## Keywords (`xp_keywords`)
- **CRITICAL**: Provide between **45 and 49** keywords.
- **CRITICAL**: ALL keywords must be in **SINGULAR FORM**. Do not EVER use plurals.
- **CRITICAL**: ALL keywords must be **COMMA SEPARATED**.
- **CRITICAL**: ALL keywords must be **ONE WORD ONLY**. Multi-word phrases are forbidden.
- Order is critical. Arrange in order of importance. The first 10 affect search results most. Include words from the title in the top 10 keywords.
- Separate descriptive elements (e.g., "white, fluffy, young, pup").
- Include conceptual elements (mood, feelings, trends like "solitude").
- Describe the setting ("indoors", "day", "sunny").
- Include viewpoint ("aerial", "drone" - remember, single words only).
- Include demographics if known (ethnicity, age, gender).
- **Gender Rules**: 
  - If you see a man/men, add `man` and `male`. 
  - If you see a woman/women, add `woman` and `female`. 
  - If you see an identifiable human body part (male/female), add the respective gender keywords.
- Nouns must be singular ("cat", not "cats").
- Avoid keyword repetitions.
- **BANNED WORDS**: Do not include any of the following words or their derivatives in keywords: `stock`, `photo`, `video`, `vector`, `3d`, `render`, `illustration`, `cartoon`, `rendering`, `photography`, `image`, `serene`, `peaceful`, `tranquil`, `calm`, `tranquility`, `whimsical`, `visual`, `unique`.
