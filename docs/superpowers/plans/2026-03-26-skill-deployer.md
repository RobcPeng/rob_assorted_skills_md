# Custom Skills Deployer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a bash deploy script that interactively deploys custom Claude Code skills from `deployable_skills/` to `~/.claude/skills/` with content-hash version tracking.

**Architecture:** Single bash script (`deploy.sh`) scans `deployable_skills/` for skill folders, computes SHA hashes, compares against a JSON manifest, presents an interactive menu, and copies selected skills to the target directory.

**Tech Stack:** Bash, shasum, standard Unix tools (find, cp, rm, cat, date)

---

### Task 1: Initialize Git Repo and Directory Structure

**Files:**
- Create: `deployable_skills/` (directory)
- Create: `.deploy-manifest.json`
- Move: `appian-dev/` → `deployable_skills/appian-dev/`

- [ ] **Step 1: Initialize git repo**

```bash
cd /Users/peng/Documents/Sandbox/rob_custom_skills
git init
```

- [ ] **Step 2: Move existing skill into deployable_skills/**

```bash
mkdir -p deployable_skills
mv appian-dev deployable_skills/
```

- [ ] **Step 3: Create empty manifest**

Create `.deploy-manifest.json`:
```json
{}
```

- [ ] **Step 4: Create .gitignore**

Create `.gitignore`:
```
.DS_Store
*.bak
```

- [ ] **Step 5: Commit**

```bash
git add deployable_skills/ .deploy-manifest.json .gitignore docs/
git commit -m "chore: initialize repo structure with deployable_skills directory"
```

---

### Task 2: Build deploy.sh — Skill Discovery and Hashing

**Files:**
- Create: `deploy.sh`

- [ ] **Step 1: Create deploy.sh with header, argument parsing, and constants**

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="${SCRIPT_DIR}/deployable_skills"
SKILLS_TARGET="${HOME}/.claude/skills"
MANIFEST="${SCRIPT_DIR}/.deploy-manifest.json"

FLAG_ALL=false
FLAG_BACKUP=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)    FLAG_ALL=true; shift ;;
        --backup) FLAG_BACKUP=true; shift ;;
        -h|--help)
            echo "Usage: deploy.sh [--all] [--backup]"
            echo "  --all      Deploy all skills without interactive menu"
            echo "  --backup   Back up existing skills before overwriting"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done
```

- [ ] **Step 2: Add skill discovery function**

Append to `deploy.sh`:

```bash
# Discover skills: directories under deployable_skills/ containing SKILL.md
discover_skills() {
    local skills=()
    for dir in "${SKILLS_SOURCE}"/*/; do
        [ -d "$dir" ] || continue
        [ -f "${dir}SKILL.md" ] || continue
        skills+=("$(basename "$dir")")
    done
    echo "${skills[@]}"
}
```

- [ ] **Step 3: Add content hash function**

Append to `deploy.sh`:

```bash
# Compute content hash for a skill directory
compute_hash() {
    local skill_dir="$1"
    find "$skill_dir" -type f | sort | xargs shasum 2>/dev/null | shasum | awk '{print $1}'
}
```

- [ ] **Step 4: Add manifest read/write functions**

Append to `deploy.sh`:

```bash
# Read hash from manifest for a given skill
read_manifest_hash() {
    local skill_name="$1"
    if [ -f "$MANIFEST" ]; then
        python3 -c "
import json, sys
with open('${MANIFEST}') as f:
    data = json.load(f)
print(data.get('${skill_name}', {}).get('hash', ''))
" 2>/dev/null || echo ""
    else
        echo ""
    fi
}

# Write hash to manifest for a given skill
write_manifest() {
    local skill_name="$1"
    local hash="$2"
    local timestamp
    timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

    if [ ! -f "$MANIFEST" ]; then
        echo '{}' > "$MANIFEST"
    fi

    python3 -c "
import json
with open('${MANIFEST}', 'r') as f:
    data = json.load(f)
data['${skill_name}'] = {'hash': '${hash}', 'deployed_at': '${timestamp}'}
with open('${MANIFEST}', 'w') as f:
    json.dump(data, f, indent=2)
"
}
```

- [ ] **Step 5: Verify discovery and hashing work**

```bash
chmod +x deploy.sh
```

Add a temporary `main` block at the end of `deploy.sh` to test:

```bash
# --- Temporary test block (remove after verification) ---
skills=($(discover_skills))
echo "Found skills: ${skills[*]}"
for s in "${skills[@]}"; do
    hash=$(compute_hash "${SKILLS_SOURCE}/${s}")
    manifest_hash=$(read_manifest_hash "$s")
    echo "${s}: current=${hash} manifest=${manifest_hash}"
done
```

Run: `./deploy.sh`
Expected: Shows `appian-dev` with a hash and empty manifest hash.

- [ ] **Step 6: Remove test block, commit**

Remove the temporary test block from the bottom of `deploy.sh`.

```bash
git add deploy.sh
git commit -m "feat: add deploy.sh with skill discovery and content hashing"
```

---

### Task 3: Build deploy.sh — Interactive Menu

**Files:**
- Modify: `deploy.sh`

- [ ] **Step 1: Add status label function**

Append before the end of `deploy.sh`:

```bash
# Determine status label for a skill
get_status_label() {
    local skill_name="$1"
    local current_hash="$2"
    local manifest_hash
    manifest_hash=$(read_manifest_hash "$skill_name")

    if [ -z "$manifest_hash" ]; then
        echo "NEW"
    elif [ "$manifest_hash" != "$current_hash" ]; then
        echo "UPDATED"
    else
        echo "up to date"
    fi
}
```

- [ ] **Step 2: Add menu display and input function**

Append to `deploy.sh`:

```bash
# Display interactive menu, return selected indices (0-based) in SELECTED array
show_menu() {
    local -n skill_names=$1
    local -n skill_labels=$2
    local count=${#skill_names[@]}

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Custom Skills Deployer"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Available skills in deployable_skills/:"
    echo ""

    for ((i = 0; i < count; i++)); do
        printf "  [%d] %-30s (%s)\n" $((i + 1)) "${skill_names[$i]}" "${skill_labels[$i]}"
    done

    echo ""
    read -rp "Select skills to deploy (comma-separated, 'a' for all, 'q' to quit): " input

    SELECTED=()
    if [[ "$input" == "q" || -z "$input" ]]; then
        return
    fi

    if [[ "$input" == "a" || "$input" == "all" ]]; then
        for ((i = 0; i < count; i++)); do
            SELECTED+=("$i")
        done
        return
    fi

    IFS=',' read -ra selections <<< "$input"
    for sel in "${selections[@]}"; do
        sel=$(echo "$sel" | tr -d ' ')
        if [[ "$sel" =~ ^[0-9]+$ ]] && ((sel >= 1 && sel <= count)); then
            SELECTED+=($((sel - 1)))
        else
            echo "Warning: invalid selection '$sel', skipping"
        fi
    done
}
```

- [ ] **Step 3: Commit**

```bash
git add deploy.sh
git commit -m "feat: add interactive menu with status labels"
```

---

### Task 4: Build deploy.sh — Deployment Logic and Main Flow

**Files:**
- Modify: `deploy.sh`

- [ ] **Step 1: Add deploy function**

Append to `deploy.sh`:

```bash
# Deploy a single skill
deploy_skill() {
    local skill_name="$1"
    local current_hash="$2"
    local label="$3"
    local target_dir="${SKILLS_TARGET}/${skill_name}"
    local source_dir="${SKILLS_SOURCE}/${skill_name}"

    # Backup if requested
    if [ "$FLAG_BACKUP" = true ] && [ -d "$target_dir" ]; then
        local backup_dir="${SKILLS_TARGET}/${skill_name}.bak"
        rm -rf "$backup_dir"
        cp -r "$target_dir" "$backup_dir"
        echo "  Backed up to ${skill_name}.bak"
    fi

    # Deploy
    rm -rf "$target_dir"
    cp -r "$source_dir" "$target_dir"
    write_manifest "$skill_name" "$current_hash"

    case "$label" in
        NEW)       echo "  Deploying ${skill_name}... ✓ (new)" ;;
        UPDATED)   echo "  Deploying ${skill_name}... ✓ (updated)" ;;
        *)         echo "  Deploying ${skill_name}... ✓ (reinstalled)" ;;
    esac
}
```

- [ ] **Step 2: Add main flow**

Append to `deploy.sh`:

```bash
# --- Main ---

# Validate source directory
if [ ! -d "$SKILLS_SOURCE" ]; then
    echo "Error: ${SKILLS_SOURCE} does not exist"
    exit 1
fi

# Ensure target exists
mkdir -p "$SKILLS_TARGET"

# Discover and compute hashes
skill_names=()
skill_hashes=()
skill_labels=()

for name in $(discover_skills); do
    hash=$(compute_hash "${SKILLS_SOURCE}/${name}")
    label=$(get_status_label "$name" "$hash")
    skill_names+=("$name")
    skill_hashes+=("$hash")
    skill_labels+=("$label")
done

if [ ${#skill_names[@]} -eq 0 ]; then
    echo "No skills found in ${SKILLS_SOURCE}/"
    echo "Each skill must be a subdirectory containing a SKILL.md file."
    exit 1
fi

# Determine which skills to deploy
SELECTED=()
if [ "$FLAG_ALL" = true ]; then
    for ((i = 0; i < ${#skill_names[@]}; i++)); do
        SELECTED+=("$i")
    done
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Custom Skills Deployer (--all)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    show_menu skill_names skill_labels
fi

if [ ${#SELECTED[@]} -eq 0 ]; then
    echo ""
    echo "No skills selected. Exiting."
    exit 0
fi

# Deploy selected skills
echo ""
deployed=0
skipped=0
errors=0

for idx in "${SELECTED[@]}"; do
    name="${skill_names[$idx]}"
    hash="${skill_hashes[$idx]}"
    label="${skill_labels[$idx]}"

    if deploy_skill "$name" "$hash" "$label"; then
        ((deployed++))
    else
        echo "  Error deploying ${name}"
        ((errors++))
    fi
done

# Show unselected skills status
for ((i = 0; i < ${#skill_names[@]}; i++)); do
    selected=false
    for idx in "${SELECTED[@]}"; do
        if [ "$i" -eq "$idx" ]; then
            selected=true
            break
        fi
    done
    if [ "$selected" = false ]; then
        echo "  ${skill_names[$i]}: ${skill_labels[$i]}"
        ((skipped++))
    fi
done

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${deployed} deployed, ${skipped} skipped"
if [ "$errors" -gt 0 ]; then
    echo "  ${errors} errors"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

[ "$errors" -eq 0 ] || exit 1
```

- [ ] **Step 3: Test the full flow**

Run: `./deploy.sh`
Expected: Menu shows `[1] appian-dev (NEW)`, selecting `1` copies to `~/.claude/skills/appian-dev/`, manifest updates.

Run: `./deploy.sh`
Expected: Menu shows `[1] appian-dev (up to date)`.

Run: `./deploy.sh --all --backup`
Expected: Deploys all with backup, shows `(reinstalled)`.

- [ ] **Step 4: Commit**

```bash
git add deploy.sh .deploy-manifest.json
git commit -m "feat: complete deploy.sh with deployment logic and main flow"
```

---

### Task 5: Final Verification and README

**Files:**
- Create: `README.md`

- [ ] **Step 1: Create README.md**

```markdown
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
```

- [ ] **Step 2: Full end-to-end test**

Run: `./deploy.sh --all`
Verify: All skills copied to `~/.claude/skills/`, manifest updated, labels correct.

Edit a file in `deployable_skills/appian-dev/` (add a blank line to SKILL.md).

Run: `./deploy.sh`
Verify: `appian-dev` shows `(UPDATED)`.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add README with usage instructions"
```
