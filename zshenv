export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH=/Users/kaushik/.oh-my-zsh
export COURSIER_CACHE=/Users/kaushik/Developer/repo/sbt/coursier/

ZSH_THEME="agnoster"
alias e='emacsclient -t'
alias ec='emacsclient -c'
alias Emacs='emacs --daemon'
alias vi='nvim'
alias vim='nvim'
alias setup-proxies='setup-proxies.sh && source ~/.zshrc'
alias remove-proxies='remove-proxies.sh && source ~/.zshrc'
alias add-key='/usr/bin/ssh-add "/Users/kaushik/Developer/Keys/Users/kaushik_chakraborty" > /dev/null'
alias ll='ls -lG'
alias ls='ls -G'
alias sd='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
alias sbt='sbt -v -sbt-dir /Users/kaushik/Developer/repo/sbt/.sbt -sbt-boot /Users/kaushik/Developer/repo/sbt/.sbt/boot -ivy /Users/kaushik/Developer/repo/sbt/ivy -sbt-launch-dir /Users/kaushik/Developer/repo/sbt/launchers'
