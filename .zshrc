plugins=(
	git
	zsh-autosuggestions
)

bindkey '^I^I' autosuggest-accept

# Git
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/(\1)/p'
}

COLOR_DEF=$'%f'
COLOR_USR=$'%F{#0099ff}'
COLOR_DIR=$'%F{#00ff00}'
COLOR_GIT=$'%F{#0099ff}'
setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n${COLOR_DIR}:%~ ${COLOR_GIT}$(parse_git_branch) $ ${COLOR_DEF}'
