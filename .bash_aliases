alias less='less -R'
alias diff='colordiff'
alias dc='cd'

alias rr='if [ -f /var/run/reboot-required ]; then echo "*** System restart required ***"; else echo "No reboot needed"; fi'
alias update='sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove && sudo apt-get clean && rr'
alias srr='HOUR=$(shuf -i 2-3 -n 1); MINUTE=$(shuf -i 0-59 -n 1); sudo shutdown -r $HOUR:$(printf "%02d" $MINUTE)'

