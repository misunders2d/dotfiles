# ADK Skills

An ADK Skill is a **self-contained, modular unit of functionality** designed to perform specific tasks. It encapsulates instructions, resources, and tools into a single package.

## How Skills Differ from Instructions

While standard agent instructions are typically static and always present in the prompt, Skills offer several advantages:
*   **Context Optimization:** Unlike global instructions that consume tokens constantly, Skills optimize the context window by loading their specific instructions only when needed (Incremental Loading).
*   **Modularity:** Skills allow you to organize capabilities into discrete packages rather than one long, complex instruction string.
*   **Resource Integration:** Skills can bundle external references and assets that the agent can consult dynamically.

## Skill Structure

Skills follow a three-level structure:
*   **L1 (Metadata):** Used for skill discovery (name, description).
*   **L2 (Instructions):** The primary logic/guidance for the task.
*   **L3 (Resources):** Supporting materials like reference Markdown files, assets (schemas, templates), and scripts.

## Creating ADK Skills

There are two main methods to create ADK skills.

### 1. File-Based Definition (Recommended)

Create a directory structure following the Agent Skill specification. Only the `SKILL.md` file is mandatory.

**Directory Structure:**
```text
skills/
    my_skill/
        SKILL.md          # Metadata (frontmatter) + Instructions (body)
        references/       # Optional: Extended workflows/guidance
        assets/           # Optional: Templates, data, or images
        scripts/          # Optional: Utility scripts (currently experimental)
```

**Loading in Code:**
```python
from google.adk.skills import load_skill_from_dir
from google.adk.tools import skill_toolset
import pathlib

# Load the skill
weather_skill = load_skill_from_dir(pathlib.Path("./skills/weather_skill"))

# Wrap it in a Toolset
my_toolset = skill_toolset.SkillToolset(skills=[weather_skill])

# Add my_toolset to the Agent's tools list
agent = LlmAgent(
    name="my_agent",
    model="gemini-2.5-flash",
    instruction="You are a helpful agent.",
    tools=[my_toolset]
)
```

### 2. In-Code Definition

You can define skills dynamically using the `Skill` model class:

```python
from google.adk.skills import models
from google.adk.tools import skill_toolset

greeting_skill = models.Skill(
    frontmatter=models.Frontmatter(
        name="greeting-skill",
        description="A skill to greet users."
    ),
    instructions="Step 1: Read references. Step 2: Greet user.",
    resources=models.Resources(
        references={"hello.txt": "Hello! Welcome!"}
    )
)

my_toolset = skill_toolset.SkillToolset(skills=[greeting_skill])
```