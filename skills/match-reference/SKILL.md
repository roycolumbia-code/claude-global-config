# Match Reference Image

When a user provides a reference image and asks to match it, follow this 5-step workflow:

## Step 1: Ask for Reference Details
Ask the user to describe the key visual elements from their reference image:
- **Fonts**: font names, sizes, weights (e.g., "Fragment Mono, 32pt, bold")
- **Colors**: hex codes or color names for background, text, accents
- **Spacing**: margins, padding, gaps between elements
- **Marker styles**: how hour/minute markers are rendered (circles, lines, numerals)
- **Layout**: overall composition and alignment

Do NOT write code yet. Gather specifics first.

## Step 2: List Current Implementation Differences
After understanding the reference:
1. Look at the current code implementation
2. Document how it differs from the reference image
3. Create a bulleted list of specific gaps (e.g., "using wrong font", "margins are too large", "color is #000000 instead of #1a1a1a")

## Step 3: Create a Numbered Plan
Write a numbered action plan with specific, measurable changes:
```
1. Change font from [current] to [reference font name]
2. Update color from [current hex] to [reference hex]
3. Adjust margin from [current value] to [reference value]
...
```

## Step 4: Implement All Changes
Execute the plan in one focused pass. Make all changes together in their respective files. Verify each change aligns with the plan.

## Step 5: Run Build to Verify
Run `swift build` to ensure:
- No compilation errors
- No warnings
- Changes compile successfully

Commit changes with a message describing what was matched to the reference.

---

**Rationale**: This workflow prevents guessing at visual styling and ensures systematic, documented changes that can be verified against a specific reference.
