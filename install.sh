#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Pinned commit for paoloanzn/free-code to ensure stability
FREE_CODE_COMMIT="7dc15d6c8fb0c40c7fcc02ce9b58204324252632"

echo -e "${RED}☭ Welcome to Communist Claude Installer ☭${RESET}"
echo -e "Seizing the means of code generation...\n"

# 1. Ensure Bun is installed and upgraded to the latest version
export PATH="$HOME/.bun/bin:$PATH"
if ! command -v bun &> /dev/null; then
  echo -e "${YELLOW}[*] Installing Bun runtime...${RESET}"
  curl -fsSL https://bun.sh/install | bash
  export PATH="$HOME/.bun/bin:$PATH"
else
  echo -e "${YELLOW}[*] Ensuring Bun is up to date...${RESET}"
  bun upgrade
fi

# 2. Clone free-code and pin to a stable commit
if [ ! -d "free-code-source" ]; then
  echo -e "${YELLOW}[*] Cloning the paoloanzn/free-code repository...${RESET}"
  git clone https://github.com/paoloanzn/free-code.git free-code-source
  cd free-code-source
  echo -e "${YELLOW}[*] Pinning free-code to stable commit: ${FREE_CODE_COMMIT:0:7}...${RESET}"
  git checkout "$FREE_CODE_COMMIT" -q
  cd ..
else
  echo -e "${YELLOW}[*] free-code-source already exists. Resetting to pinned stable commit...${RESET}"
  cd free-code-source 
  git fetch origin
  git checkout "$FREE_CODE_COMMIT" -q
  cd ..
fi

# 3. Build the unlocked binary
echo -e "${YELLOW}[*] Building the unlocked binary with all 54 experimental flags...${RESET}"
cd free-code-source
bun install
bun run build:dev:full
cd ..

# 4. Automatically install the claude-mem plugin (Headless Manual Install)
echo -e "${YELLOW}[*] Installing the claude-mem plugin to solve the 167k token context drain...${RESET}"
mkdir -p ~/.claude/plugins/marketplaces/thedotmack
if [ ! -d "$HOME/.claude/plugins/marketplaces/thedotmack/.git" ]; then
    git clone https://github.com/thedotmack/claude-mem.git ~/.claude/plugins/marketplaces/thedotmack
else
    cd ~/.claude/plugins/marketplaces/thedotmack && git pull && cd - > /dev/null
fi
cd ~/.claude/plugins/marketplaces/thedotmack
npm install > /dev/null 2>&1
npm run build > /dev/null 2>&1
cd - > /dev/null

echo -e "\n${GREEN}[+] Installation Complete!${RESET}"
echo -e "You can now run your fully unlocked agent using:"
echo -e "  ${GREEN}./bin/communist-claude${RESET} (Normal Anthropic API)"
echo -e "  ${GREEN}./bin/communist-claude --minimax${RESET} (95% Cheaper MiniMax API)\n"
echo -e "Don't forget to run ${YELLOW}cp CLAUDE.md.template CLAUDE.md${RESET} in your target project directory!"