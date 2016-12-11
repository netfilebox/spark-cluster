## 
# custom .bashc
# source it in .profile like this:
# . "$HOME/.bashrc
##
# color for man pages
man() {
    env LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}
TERM=xterm-256color
# alias
test -s ~/.alias && . ~/.alias || true
alias s="sudo"
alias tailmail="sudo tail -f /var/log/mail.log"
alias ls="ls --color=auto"

# prompt colors and style
export PS1='\[\e[33m\][\u@\h:\[\e[1;34m\]\W\[\e[m\]] '
#root
export JAVA_HOME=/opt/jdk
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin:$JAVA_HOME/bin

#set -o vi
