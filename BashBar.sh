#!/usr/bin/bash

declare -A ALL_BARS

defineBar()
{
    local name="${1}"
    local callback="${2}"

    ALL_BARS["${name}"]=${callback}
    ALL_BARS["${name}_enabled"]=0
}

enableBar()
{
    local name="${1}"
    ALL_BARS["${name}_enabled"]=1
}
disableBar()
{
    local name="${1}"
    ALL_BARS["${name}_enabled"]=0
}

availableBars()
{
    for bar in "${!ALL_BARS[@]}"; do
        if [[ "${bar}" =~ _enabled$ ]]; then
            continue
        fi

        local enabled="\033[38;5;124mDisabled\033[0m"
        if [[ ${ALL_BARS["${bar}_enabled"]} == 1 ]]; then
            enabled="\033[38;5;28mEnabled\033[0m"
        fi
        echo -e "${bar} ${enabled}"
    done
}


startBar()
{
    BAR_BG="48;5;15"
    BAR_FG="38;5;16"
    PREV_BAR_FG=0
    PREV_BAR_BG=0
    BAR_COUNT=0

    PS1=""
}

addBar()
{
    local FG=${1:-${BAR_FG}}
    local BG=${2:-${BAR_BG}}
    local CONTENT=$3
    local EXTRAS="${4:-}"

    PREV_BAR_FG=${BAR_FG}
    PREV_BAR_BG=${BAR_BG}
    BAR_FG=${FG}
    BAR_BG=${BG}

    if [[ -n "${EXTRAS}" ]]; then
        EXTRAS="${EXTRAS};"
    fi

    local s=""
    if [[ ${BAR_COUNT} == 0 ]]; then
        if [[ -n "${BG}" && -n "${FG}" ]]; then
            FG="${FG};"
        fi

        s="\[\033[${EXTRAS}${FG}${BG}m\]${CONTENT}\[\033[0m\]"
    else
        local PBG=${PREV_BAR_BG}
        if [[ -n "${PBG}" ]]; then
            PBG="3${PBG:1}";
        fi
        if [[ -n "${BG}" ]]; then
            PBG="${PBG};"
        fi

        s="\[\033[${PBG}${BG}m\]▶\[\033[${EXTRAS}${FG}m\]${CONTENT}\[\033[0m\]"
    fi

    ((BAR_COUNT++))
    PS1="${PS1}${s}"
}

endBar()
{
    PREV_BAR_FG=${BAR_FG}
    PREV_BAR_BG=${BAR_BG}

    local s="\[\033[3${PREV_BAR_BG:1};49m\]▶\[\033[0m\] "
    PS1="${PS1}${s}"
}
