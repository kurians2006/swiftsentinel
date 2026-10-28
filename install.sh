#!/usr/bin/env bash
set -e

# ==============================================================================
# SwiftSentinel Universal Installer
# One-line installer for Cursor, Claude Code, VS Code, Windsurf, Codex, and Antigravity
# ==============================================================================

REPO="kurians2006/swiftsentinel"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}${BOLD}"
echo "  ____           _  __ _   ____             _   _            _ "
echo " / ___|_      __(_)/ _| |_/ ___|  ___ _ __ | |_(_)_ __   ___| |"
echo " \___ \ \ /\ / /| | |_| __\___ \ / _ \ '_ \| __| | '_ \ / _ \ |"
echo "  ___) \ V  V / | |  _| |_ ___) |  __/ | | | |_| | | | |  __/ |"
echo " |____/ \_/\_/  |_|_|  \__|____/ \___|_| |_|\__|_|_| |_|\___|_|"
echo -e "${NC}"
echo -e "${BOLD}🛡️  SwiftSentinel Universal Agent Installer for iOS & Swift${NC}\n"

TARGET_DIR="${PWD}"
echo -e "Installing into current workspace: ${YELLOW}${TARGET_DIR}${NC}\n"

# Helper function to download file safely
fetch_file() {
    local remote_path="$1"
    local local_path="$2"
    local dir
    dir=$(dirname "$local_path")
    mkdir -p "$dir"
    
    if curl -sSL -f "${BASE_URL}/${remote_path}" -o "$local_path" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Installed: ${local_path}"
    else
        echo -e "  ${YELLOW}⚠${NC} Skipped: ${remote_path} (could not fetch)"
    fi
}

echo -e "${BOLD}1. Installing Universal Agent Manifests (Claude Code, Codex, Windsurf):${NC}"
fetch_file "CLAUDE.md" "${TARGET_DIR}/CLAUDE.md"
fetch_file "AGENTS.md" "${TARGET_DIR}/AGENTS.md"
fetch_file ".windsurfrules" "${TARGET_DIR}/.windsurfrules"

echo -e "\n${BOLD}2. Installing Cursor Rules (.cursorrules & modern .mdc):${NC}"
fetch_file "examples/.cursorrules" "${TARGET_DIR}/.cursorrules"
fetch_file ".cursor/rules/swift6-concurrency.mdc" "${TARGET_DIR}/.cursor/rules/swift6-concurrency.mdc"
fetch_file ".cursor/rules/swiftui-performance.mdc" "${TARGET_DIR}/.cursor/rules/swiftui-performance.mdc"
fetch_file ".cursor/rules/ios-security.mdc" "${TARGET_DIR}/.cursor/rules/ios-security.mdc"
fetch_file ".cursor/rules/ios-architectures-solid.mdc" "${TARGET_DIR}/.cursor/rules/ios-architectures-solid.mdc"

echo -e "\n${BOLD}3. Installing GitHub Copilot & VS Code Instructions:${NC}"
fetch_file ".github/copilot-instructions.md" "${TARGET_DIR}/.github/copilot-instructions.md"

echo -e "\n${BOLD}4. Installing Antigravity & Agent Skills:${NC}"
fetch_file "packages/skills/ios-code-review/SKILL.md" "${TARGET_DIR}/.gemini/skills/ios-code-review/SKILL.md"
fetch_file "packages/skills/ios-security-audit/SKILL.md" "${TARGET_DIR}/.gemini/skills/ios-security-audit/SKILL.md"
fetch_file "packages/skills/swiftui-architect/SKILL.md" "${TARGET_DIR}/.gemini/skills/swiftui-architect/SKILL.md"
fetch_file "packages/skills/external-pr-reviewer/SKILL.md" "${TARGET_DIR}/.gemini/skills/external-pr-reviewer/SKILL.md"

echo -e "\n${BOLD}5. Installing Standalone SwiftSentinel CLI:${NC}"
fetch_file "bin/swiftsentinel" "${TARGET_DIR}/bin/swiftsentinel"
chmod +x "${TARGET_DIR}/bin/swiftsentinel" 2>/dev/null || true

echo -e "\n${GREEN}${BOLD}🎉 SwiftSentinel successfully installed!${NC}"
echo -e "Your workspace is now armed with Swift 6, SwiftUI, OWASP MASVS, MVVM, VIPER, Clean Architecture, and SOLID rules."
echo -e "Ready to use in ${BOLD}Cursor, Claude Code, VS Code, Codex, Windsurf, and Antigravity${NC}.\n"
