---
name: adk-agent-creator
description: Specialized skill for building, modifying, and managing Google Agent Development Kit (ADK) agents, tools, and ADK skills. Use this skill when working on ADK projects to apply best practices, architecture patterns, and accurate syntax.
---
# Google ADK Agent Creator Skill

This skill provides the Gemini CLI with specialized knowledge and workflows for creating Google ADK (Agent Development Kit) applications, agents, tools, and ADK skills.

## References

- **[ADK Skills](references/adk_skills.md)**: Guidelines and patterns for creating ADK Agent Skills. Read this to understand how ADK Skills differ from instructions and how to build file-based or in-code skills.
- **[ADK Cheatsheet](references/adk_cheatsheet.md)**: A comprehensive guide on setting up ADK agents, orchestration, multi-agent systems, tools, memory, and events.

## Workflows

### 1. Creating ADK Agents
- Use `LlmAgent` for LLM-driven reasoning. Use `SequentialAgent`, `ParallelAgent`, or `LoopAgent` for deterministic orchestration.
- Define explicit and concise `instruction` parameters. Ensure the agent has a `description` for multi-agent delegation.
- Apply tools via the `tools` array.

### 2. Creating Custom Tools
- Provide type hints for all parameters, and strictly avoid default values in the signature.
- Provide a `tool_context: ToolContext` parameter in the signature.
- Return a `dict` (typically with a `status` key).
- Provide a clear, comprehensive docstring explaining parameters and return values. Do NOT mention `tool_context` in the docstring.

### 3. Creating ADK Skills
- Use Skills to package context efficiently and keep the main agent instructions lean.
- Reference `references/adk_skills.md` for exact syntax and folder structure.