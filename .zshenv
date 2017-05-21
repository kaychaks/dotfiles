export PATH=/opt/local/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH=/Users/kaushik/.oh-my-zsh
export COURSIER_CACHE=/Users/kaushik/Developer/repo/sbt/coursier/

ZSH_THEME="agnoster"
alias setup-proxies='setup-proxies.sh && source ~/.zshrc'
alias remove-proxies='remove-proxies.sh && source ~/.zshrc'

alias ll='ls -lG'
alias ls='ls -G'

alias sbt='sbt -v -sbt-dir /Users/kaushik/Developer/repo/sbt/.sbt -sbt-boot /Users/kaushik/Developer/repo/sbt/.sbt/boot -ivy /Users/kaushik/Developer/repo/sbt/ivy -sbt-launch-dir /Users/kaushik/Developer/repo/sbt/launchers'
