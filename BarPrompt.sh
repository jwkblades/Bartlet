#!/usr/bin/bash

drawPrompt()
{
    local size=${COLUMNS}
    #local prefix="\[\033[1;48;5;45m\]\u@\h \[\033[22m\]\W "

    # PS1="${prefix}\[\033[38;5;45;48;5;235m\]▶${branch}\[\033[38;5;235;49m\]▶\[\033[0m\] "
    startBar
    addBar "38;5;16" "48;5;45" "\u@\h \[\033[22m\]\W " "1"
    for bar in "${!ALL_BARS[@]}"; do
        if [[ "${bar}" =~ _enabled$ ]]; then
            continue
        fi

        if [[ ${ALL_BARS["${bar}_enabled"]} == 1 ]]; then
            ${ALL_BARS["${bar}"]}
        fi
    done
    endBar

    return 0
}

PROMPT_COMMAND=drawPrompt
#PSL="[\[\033[1;34m\]\u@\h\[\033[0m\] \W]\\$ "
#
#drawPrompt()
#{
#    local size=${COLUMNS}
#    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || hg branch 2>/dev/null)
#    if [[ -z ${branch} ]]; then
#        PS1="${PSL}"
#    else
#        local dirty="5"
#        branch="\[\033[2;3${dirty}m\]⎇ \[\033[0m\]\[\033[2;35m\]${branch}\[\033[0m\]"
#        PS1="${PSL:0:-4} ${branch}]\\$ "
#    fi
#    return 0
#}
