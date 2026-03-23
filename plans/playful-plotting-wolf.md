# Context

The user wants to create a custom skill for "matching a reference image" in the Claude Code skills directory. This complements the CLAUDE.md convention just added: "When the user says to match a reference image, ask for specific details... BEFORE writing code."

# Plan

## Files to create

- `.claude/skills/match-reference/SKILL.md`

## Steps

1. Create the directory `.claude/skills/match-reference/`
2. Write `SKILL.md` with the 5-step workflow content:

```markdown
# Match Reference Image
1. Ask user to describe the reference image elements: fonts, colors, spacing, marker styles
2. List current implementation differences
3. Create a numbered plan of specific changes
4. Implement all changes in one pass
5. Run build to verify
```

## Verification

- Confirm file exists at `.claude/skills/match-reference/SKILL.md`
- Confirm content matches what was specified
