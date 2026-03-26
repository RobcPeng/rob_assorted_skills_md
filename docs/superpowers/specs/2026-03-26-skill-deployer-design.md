# Custom Skills Deployer — Design Spec

## Overview

A single bash script (`deploy.sh`) that deploys custom Claude Code skills from a local `deployable_skills/` directory to `~/.claude/skills/`. It presents an interactive numbered menu, tracks versions via content hashing, and overwrites by default with an optional backup flag.

## Repo Structure

```
rob_custom_skills/
├── .git/
├── deployable_skills/
│   ├── appian-dev/
│   │   ├── SKILL.md
│   │   ├── hooks/
│   │   └── references/
│   └── <other-skills>/
│       └── SKILL.md
├── .deploy-manifest.json
├── deploy.sh
└── README.md
```

## Components

### `deploy.sh`

Single entry point. No external dependencies beyond standard Unix tools (`bash`, `find`, `shasum`, `cp`, `cat`).

**Usage:**
```bash
./deploy.sh              # Interactive menu
./deploy.sh --all        # Deploy all skills, skip menu
./deploy.sh --backup     # Back up existing skills before overwriting
./deploy.sh --all --backup  # Both
```

### Skill Discovery

Scans `deployable_skills/` for immediate subdirectories containing a `SKILL.md` file. Directories without `SKILL.md` are ignored. The list is dynamically generated each run — no hardcoded skill names.

### Version Detection

Content hash per skill: `find <skill-dir> -type f | sort | xargs shasum | shasum` (hash of hashes). This captures any file change within the skill folder — edits, additions, deletions.

### `.deploy-manifest.json`

Tracks deployment state. Stored in repo root (committed to git so it's shared).

```json
{
  "appian-dev": {
    "hash": "a1b2c3d4...",
    "deployed_at": "2026-03-26T17:30:00Z"
  }
}
```

Written after each successful deployment. Read at startup to determine status labels.

### Interactive Menu

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Custom Skills Deployer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Available skills in deployable_skills/:

  [1] appian-dev          (NEW)
  [2] react-dev           (UPDATED)
  [3] meddpicc-deal-qual  (up to date)

Select skills to deploy (comma-separated, 'a' for all, 'q' to quit):
```

**Input handling:**
- Comma-separated numbers: `1,2` deploys skills 1 and 2
- `a` or `all`: deploys everything
- `q` or empty: exits without deploying

### Status Labels

Each skill gets one label based on comparing current content hash to `.deploy-manifest.json`:

| Label | Condition |
|-------|-----------|
| `(NEW)` | Skill not in manifest (never deployed from this repo) |
| `(UPDATED)` | Hash in manifest differs from current hash |
| `(up to date)` | Hash matches manifest |

### Deployment Behavior

For each selected skill:

1. If `--backup` flag is set and `~/.claude/skills/<name>/` exists, copy it to `~/.claude/skills/<name>.bak/`
2. Remove `~/.claude/skills/<name>/` if it exists
3. Copy `deployable_skills/<name>/` to `~/.claude/skills/<name>/`
4. Update `.deploy-manifest.json` with new hash and timestamp
5. Print status line: `Deploying <name>... ✓ (new|updated|reinstalled)`

Skills marked "up to date" that are explicitly selected get reinstalled (forced copy) with label `(reinstalled)`.

### Deploy Target

Hardcoded to `~/.claude/skills/`. This is the standard Claude Code skills directory.

### Summary Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  2 deployed, 1 up to date
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Error Handling

- If `deployable_skills/` doesn't exist or is empty: print error, exit 1
- If `~/.claude/skills/` doesn't exist: create it
- If a copy fails: print error for that skill, continue with remaining skills, exit 1 at end

## What This Does NOT Do

- No remote fetching — works only with local files
- No skill removal — doesn't uninstall skills from `~/.claude/skills/`
- No dependency management between skills
- No interactive editing of skills
