<div align="center">
  <h1>☭ Communist Claude</h1>
  <p><b>What I want to use as an AI CLI.</b></p>
  <p><i>Wrapper for Anthropic's leaked Claude Code CLI.</i></p>

  [![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
  [![Platform: macOS | Linux](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey.svg)]()
  [![Tokens Saved](https://img.shields.io/badge/Tokens_Saved-95%25-success.svg)]()
</div>

---

## 📖 The Backstory

After reading the explosive tweets from [Chaofan Shou](https://twitter.com/Fried_rice/status/2038894956459290963) and [fakeguru](https://twitter.com/iamfakeguru/status/2038965567269249484) regarding the leaked Claude Code source map, and reviewing the myriad of forks that flooded GitHub (like `instructkr/claw-code`, `paoloanzn/free-code`, and `oboard/claude-code-rev`), I realized there wasn't a single, cohesive solution that fixed *all* of the CLI's native flaws.

The original Claude Code suffers from three massive, artificially-induced problems:
1. **The Context Death Spiral:** Once you hit ~167,000 tokens, the code blindly triggers an `autoCompact` routine that destroys your reasoning chains and file context, causing massive billing drain and immediate logic failure.
2. **The "Laziness" Guardrails:** Hardcoded system prompts force Claude to "try the simplest approach first" and specifically forbid it from refactoring or fixing bad architecture unless you explicitly fight it.
3. **The Verification Blindspot (Hallucinations):** The codebase limits file reads to 2,000 lines and tool outputs to 2,000 bytes, hiding truncation from the agent. Furthermore, the logic that forces Claude to verify if code actually compiles before reporting "Success" is locked behind an employee-only check (`process.env.USER_TYPE === 'ant'`).

**Communist Claude is the unified solution.** 

Instead of juggling multiple forks, plugins, and custom prompt wrappers, this repository pulls the best open-source fixes together into a single, highly-optimized installation.

## ✨ What This Does & How It Fixes The CLI

Communist Claude automates a multi-step installation pipeline to build the perfect agent:

1. **Strips Telemetry, Guardrails & Unlocks 54 Experimental Features** 
   * **How:** It clones and builds `paoloanzn/free-code` under the hood. *Note: We intentionally compile as `USER_TYPE='external'` instead of `'ant'`. Compiling as `'ant'` crashes the application as it tries to ping internal Anthropic corporate VPNs and telemetry endpoints. We bypass the guardrails safely using the CLAUDE.md override instead.*
   * **Fixes:** Removes Sentry crash reports, GrowthBook event logging, and completely strips Anthropic's security-prompt guardrails (e.g., injected "cyber risk" blocks and forced refusal patterns) at the source-code level. Unlocks Voice Mode, IDE Bridge, and the internal Agent Swarm orchestrator.

2. **Cures The Context Death Spiral (95% Token Savings)**
   * **How:** The installer automatically builds and injects the `claude-mem` vector database plugin directly from source.
   * **Fixes:** Claude no longer tries to hold your entire project history in a single, bloated context window. It starts fresh every session and uses progressive disclosure (via the `search` and `get_observations` tools) to pull only the specific 500-1,000 tokens of memory it needs, saving your billing limit from immediate exhaustion.

3. **Destroys Code Hallucinations & Laziness**
   * **How:** It deploys the "Employee-Grade" `CLAUDE.md` mechanical override.
   * **Fixes:** Re-writes the definition of "Done". Claude is explicitly forbidden from claiming success until it runs `tsc` and `eslint`. It is forced to chunk large file reads, and it is ordered to launch parallel Sub-Agent Swarms (each with their own 167k token budget) for any task touching more than 5 files.

4. **Provides 95% Cheaper Inference**
   * **How:** A custom bash wrapper (`--minimax`) automatically intercepts API routing.
   * **Fixes:** Instead of paying Anthropic's premium Opus/Sonnet prices, passing `--minimax` seamlessly routes the CLI to MiniMax M2.7 (a highly capable, Opus-level model) for a fraction of the cost, making massive autonomous agent swarms financially viable.

---

## 🚀 Installation

### Prerequisites
* macOS or Linux (Windows via WSL)
* `git`, `curl`, and `bun` (v1.3.11+ required - the installer will auto-upgrade Bun if needed)

### 1. Clone & Install
Run the automated installation script. This will clone the upstream repositories, compile the unlocked binary, and configure the vector-memory plugins.

```bash
git clone https://github.com/yourusername/communist-claude.git
cd communist-claude
./install.sh
```

### 2. Add to your PATH (Optional)
To make the custom wrapper accessible anywhere:
```bash
sudo ln -s $(pwd)/bin/communist-claude /usr/local/bin/communist-claude
```

---

## ⚙️ What the Installer Does Under the Hood (Detailed Workflow)

If you're curious about exactly what the `install.sh` script executes, here is the step-by-step technical breakdown:

1. **Runtime Preparation:** Checks for the `bun` runtime. If missing, it installs it via the official bash script. If present, it forcefully runs `bun upgrade` to ensure you are on the latest version (the `free-code` codebase requires bleeding-edge Bun features to compile).
2. **Source Acquisition (Pinned for Stability):** Clones the `paoloanzn/free-code` repository (the core telemetry-stripped, guardrail-free fork). It forcefully checks out a specific, tested commit SHA to guarantee that upstream changes won't break your installation in the future.
3. **Compiler Integration:** The `free-code` fork natively sets `USER_TYPE='external'` by default to disable internal Anthropic telemetry and corporate SSO checks. We rely on that native configuration and use the `CLAUDE.md` to emulate the employee-grade prompt rules instead, ensuring maximum stability without modifying upstream compiler logic.
4. **Unlocked Compilation:** Runs `bun install` and compiles the CLI using `bun run build:dev:full`. This specific build target forces all 54 experimental `bun:bundle` feature flags (like `ULTRAPLAN`, `VOICE_MODE`, and `AGENT_TRIGGERS`) to evaluate to `true` at compile time, completely unlocking the binary without requiring any source code modifications to the tools themselves.
5. **Headless Plugin Injection (`claude-mem`):** Bypasses the standard interactive `/plugin install` command (which fails in automated or headless shell environments due to `/dev/tty` requirements). It manually scaffolds the `~/.claude/plugins/marketplaces/thedotmack` directory, clones the `claude-mem` repository directly, and executes `npm install && npm run build` to compile the background SQLite/Chroma DB worker service. This gives Claude persistent memory instantly.

---

## 💻 Usage Guide

### Step 1: Secure Your Project
Before asking Claude to do anything, you **must** drop the employee-grade instructions into the root of whatever codebase you are working on. This enforces the anti-hallucination behavior.

```bash
# From the communist-claude folder:
cp CLAUDE.md.template /path/to/your/project/CLAUDE.md
```

### Step 2: Run the Agent

**Mode A: The Purist (Uses Anthropic's API)**
Runs the unlocked binary against standard Claude models.
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
communist-claude
```

**Mode B: God Mode (95% Cheaper)**
Intercepts the API routing and forces the CLI to use MiniMax M2.7 instead. You get massive context windows and near-Opus performance for pennies.
```bash
export MINIMAX_API_KEY="sk-your-minimax-key-here"
communist-claude --minimax
```

### Step 3: Utilize Persistent Memory
Because the installer automatically hooked the `claude-mem` database into the binary, you don't need to do anything else. As you code, you'll see Claude actively indexing its observations. 

If you close the terminal and come back tomorrow, you don't need to re-explain the project. Claude will use the `mem-search` tool to fetch yesterday's context automatically.

---

## 🛠️ Troubleshooting

Based on real-world testing of this setup, here are the most common installation pitfalls and how they were resolved in this build:

* **Bun compilation errors (`npm error` / build fails):** 
  The `free-code` fork heavily relies on Bun's bleeding-edge features. If your build fails, it is almost certainly because your Bun version is `< 1.3.11`. Our `install.sh` script automatically runs `bun upgrade` to prevent this.
* **`claude-mem` installer throwing `/dev/tty: No such device or address`:** 
  The official `claude-mem` installer script uses interactive prompts that crash in CI/CD or headless terminals. We bypassed this by having `install.sh` manually `git clone`, `npm install`, and `npm run build` the plugin directly into your `~/.claude/plugins/marketplaces/` directory.

---

## 📜 Acknowledgements
* [Chaofan Shou](https://twitter.com/Fried_rice) and [fakeguru](https://twitter.com/iamfakeguru) for exposing the internal guardrails.
* [paoloanzn/free-code](https://github.com/paoloanzn/free-code) for the telemetry-stripped, flag-unlocked source build.
* [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) for the revolutionary progressive disclosure memory plugin.
* [karankendre](https://twitter.com/karankendre) for the MiniMax API routing concept.

## ⚖️ License
This repository is an automation wrapper and configuration guide. The underlying code compiled by this tool (`paoloanzn/free-code`) is a fork of source material whose copyright is owned by Anthropic. Use at your own discretion for educational and security research purposes.

---

<div align="center">
  <p><i>Built with <3 using my internal gateway AI's - mostly Gemini 3.1 pro</i></p>
</div>