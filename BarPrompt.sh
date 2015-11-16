drawPrompt()
{
    local size=${COLUMNS}
    PS1=""

    startBar
    addBar "38;5;16" "48;5;45" "\u@\h \[\033[22m\]\W " "1"
    PS1="${PS1}${BAR_STRING}"
    for bar in "${!ALL_BARS[@]}"; do
        if [[ "${bar}" =~ _enabled$ ]]; then
            continue
        fi

        BAR_STRING=""
        if [[ ${ALL_BARS["${bar}_enabled"]} == 1 ]]; then
            ${ALL_BARS["${bar}"]}
            PS1="${PS1}${BAR_STRING}"
        fi
    done
    endBar
    PS1="${PS1}${BAR_STRING}"

    return 0
}

PROMPT_COMMAND=drawPrompt
