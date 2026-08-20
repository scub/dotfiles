export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# PNPM shortcuts
alias p="pnpm"
alias pe="pnpm exec"
alias px="pnpx"
alias pa="pnpm add"
alias pf="pnpm add --filter"
alias pd="pnpm add -D"
alias pdf="pnpm add -D --filter"
alias pi="pnpm install --loglevel=error"
alias pw="pnpm install --workspace-root"
alias pui="pnpm upgrade --interactive --latest"

secret >/dev/null || source environment/secret.sh && : "${INTERNAL_REG:=$(secret get INTERNAL_REG)}"
alias npm-auth="npm login --registry=https://${INTERNAL_REG}/api/npm/npm/ --auth-type=web"