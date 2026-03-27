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

# Discover skills: directories under deployable_skills/ containing SKILL.md
discover_skills() {
    local skills=()
    for dir in "${SKILLS_SOURCE}"/*/; do
        [ -d "$dir" ] || continue
        [ -f "${dir}SKILL.md" ] || continue
        skills+=("$(basename "$dir")")
    done
    echo "${skills[@]+"${skills[@]}"}"
}

# Compute content hash for a skill directory
compute_hash() {
    local skill_dir="$1"
    find "$skill_dir" -type f | sort | xargs shasum 2>/dev/null | shasum | awk '{print $1}'
}

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

# Display interactive toggle menu, return selected indices (0-based) in SELECTED array
# Uses global arrays: _menu_names, _menu_labels
# Controls: number to toggle, 'a' select all, 'n' select none, 'd' deploy, 'q' quit
show_menu() {
    local count=${#_menu_names[@]}
    local selected=()

    # Initialize: pre-select NEW and UPDATED skills
    for ((i = 0; i < count; i++)); do
        if [[ "${_menu_labels[$i]}" == "NEW" || "${_menu_labels[$i]}" == "UPDATED" ]]; then
            selected[$i]=1
        else
            selected[$i]=0
        fi
    done

    while true; do
        # Clear screen and draw menu
        printf "\033[2J\033[H"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  Custom Skills Deployer"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Toggle skills with their number, then press 'd' to deploy:"
        echo ""

        for ((i = 0; i < count; i++)); do
            local marker=" "
            if [[ "${selected[$i]}" == "1" ]]; then
                marker="x"
            fi
            printf "  [%s] %d. %-28s (%s)\n" "$marker" $((i + 1)) "${_menu_names[$i]}" "${_menu_labels[$i]}"
        done

        echo ""
        echo "  a = select all  n = select none  d = deploy  q = quit"
        echo ""
        read -rp "> " input

        if [[ "$input" == "q" ]]; then
            SELECTED=()
            return
        fi

        if [[ "$input" == "d" ]]; then
            SELECTED=()
            for ((i = 0; i < count; i++)); do
                if [[ "${selected[$i]}" == "1" ]]; then
                    SELECTED+=("$i")
                fi
            done
            return
        fi

        if [[ "$input" == "a" ]]; then
            for ((i = 0; i < count; i++)); do
                selected[$i]=1
            done
            continue
        fi

        if [[ "$input" == "n" ]]; then
            for ((i = 0; i < count; i++)); do
                selected[$i]=0
            done
            continue
        fi

        # Toggle by number
        if [[ "$input" =~ ^[0-9]+$ ]] && ((input >= 1 && input <= count)); then
            local idx=$((input - 1))
            if [[ "${selected[$idx]}" == "1" ]]; then
                selected[$idx]=0
            else
                selected[$idx]=1
            fi
        fi
    done
}

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
    _menu_names=("${skill_names[@]}")
    _menu_labels=("${skill_labels[@]}")
    show_menu
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
        ((deployed++)) || true
    else
        echo "  Error deploying ${name}"
        ((errors++)) || true
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
        ((skipped++)) || true
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
