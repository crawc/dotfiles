alias less='less -R'
alias diff='colordiff'
alias dc='cd'

alias rr='if [ -f /var/run/reboot-required ]; then echo "*** System restart required ***"; else echo "No reboot needed"; fi'
alias update='sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove && sudo apt-get clean && rr'
alias srr='$(echo "sudo shutdown -r 2:`printf "%02d" $(( ( RANDOM % 57 )  + 1 ))`")'
