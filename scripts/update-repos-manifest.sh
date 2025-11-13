#!/usr/bin/env bash
set -euo pipefail

# This script scans the Repos directory, finds all git repos, and writes a
# YAML manifest with their paths and remotes.

HOME="/home/miya"

ROOT="${HOME}/Repos"
OUT="${HOME}/.config/repos.yaml"

mkdir -p "$(dirname "$OUT")"

yaml_quote() {
    # YAML single-quoted string, escape single quotes by doubling them
    local s=${1//\'/\'\'}
    printf "'%s'" "$s"
}

{
    echo "repos:"
    # Find all .git directories under ROOT, sorted for stable output
    find "$ROOT" -type d -name ".git" | sort | while read -r gitdir; do
        repo_dir="$(dirname "$gitdir")"
        rel_path="${repo_dir#$ROOT/}"

        # Collect remotes
        mapfile -t remotes < <(git -C "$repo_dir" remote 2>/dev/null || true)
        if [ "${#remotes[@]}" -eq 0 ]; then
            echo "ERROR: Repo '$rel_path' does not have a remote!" >&2
            continue
        fi

        echo "  $(yaml_quote "$rel_path"):"
        echo "    path: $(yaml_quote "$repo_dir")"
        echo "    remotes:"
        for r in "${remotes[@]}"; do
            url="$(git -C "$repo_dir" remote get-url "$r" 2>/dev/null || true)"
            [ -z "$url" ] && continue
            echo "      $(yaml_quote "$r"): $(yaml_quote "$url")"
        done
    done
} >"$OUT"

echo "Finished updating repo config file ${OUT}"
