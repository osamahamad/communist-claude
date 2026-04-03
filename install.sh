#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

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

# 2. Verify bundled source code exists
if [ ! -d "free-code-source" ]; then
  echo -e "${RED}[!] Error: free-code-source directory not found! Make sure you cloned the entire communist-claude repository properly.${RESET}"
  exit 1
fi

# 3. Build the unlocked binary
echo -e "${YELLOW}[*] Building the unlocked binary with all 54 experimental flags...${RESET}"
cd free-code-source
bun install
bun run build:dev:full

# Move the built binary to the global path
echo -e "${YELLOW}[*] Installing communist-claude globally (may require sudo password)...${RESET}"
INSTALL_DIR="$(pwd)"

sudo bash -c "cat << 'EOF' > /usr/local/bin/communist-claude
#!/bin/bash
if [ \"\$1\" == \"--minimax\" ]; then
    echo -e \"\033[1;33m☭ Routing to MiniMax API (95% cheaper, Opus-level performance)...\033[0m\"
    export ANTHROPIC_BASE_URL=\"https://api.minimax.io/anthropic\"
    
    if [ -z \"\$MINIMAX_API_KEY\" ]; then
        echo -e \"\033[0;31mWarning: MINIMAX_API_KEY is not set.\033[0m\"
        export ANTHROPIC_API_KEY=\"sk-your-minimax-api-key\"
    else
        export ANTHROPIC_API_KEY=\"\$MINIMAX_API_KEY\"
    fi

    export ANTHROPIC_MODEL=\"MiniMax-M2.7\"
    export ANTHROPIC_DEFAULT_OPUS_MODEL=\"MiniMax-M2.7\"
    export ANTHROPIC_DEFAULT_SONNET_MODEL=\"MiniMax-M2.7\"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL=\"MiniMax-M2.7\"
    shift
    exec \"${INSTALL_DIR}/cli-dev\" \"\$@\"
else
    exec \"${INSTALL_DIR}/cli-dev\" \"\$@\"
fi
EOF"
sudo chmod +x /usr/local/bin/communist-claude

cd ..

# 4. Automatically install the claude-mem plugin (Headless Native Install)
echo -e "${YELLOW}[*] Installing the claude-mem plugin natively to solve the 167k token context drain...${RESET}"
/usr/local/bin/communist-claude plugin marketplace add thedotmack/claude-mem || true
/usr/local/bin/communist-claude plugin install claude-mem || true

echo -e "\n${GREEN}[+] Installation Complete!${RESET}"
echo -e "You can now run your fully unlocked agent from ANY directory using:"
echo -e "  ${GREEN}communist-claude${RESET} (Normal Anthropic API)"
echo -e "  ${GREEN}communist-claude --minimax${RESET} (95% Cheaper MiniMax API)\n"
echo -e "Don't forget to run ${YELLOW}cp CLAUDE.md.template CLAUDE.md${RESET} in your target project directory!"