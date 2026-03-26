# Rob's Custom Skills

Custom Claude Code skills with a deployment script.

## Structure

```
deployable_skills/    # Skill source folders (each has SKILL.md)
deploy.sh             # Interactive deployment script
.deploy-manifest.json # Tracks deployed versions (content hashes)
```

## Usage

```bash
# Interactive menu — select which skills to deploy
./deploy.sh

# Deploy all skills without menu
./deploy.sh --all

# Back up existing skills before overwriting
./deploy.sh --backup

# Both
./deploy.sh --all --backup
```

Skills are deployed to `~/.claude/skills/`. The script detects changes via content hashing and shows status labels: `(NEW)`, `(UPDATED)`, or `(up to date)`.

## Adding a New Skill

1. Create a folder under `deployable_skills/<skill-name>/`
2. Add a `SKILL.md` file with frontmatter
3. Add any `hooks/` or `references/` as needed
4. Run `./deploy.sh` to deploy
