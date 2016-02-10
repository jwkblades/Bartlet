declare -A BARTLET_ALL_BARS

BARTLET_PROMPT_FG=245
BARTLET_PROMPT_BG=16
BARTLET_BAR_ORDER=()
BARTLET_LSEP="▶"
BARTLET_RSEP="◀"

BARTLET_ENABLED_FG=28
BARTLET_DISABLED_FG=125

bartlet_color()
{
    local mod=""
    local reset_re="\breset|none\b"
    local fore_re="^f:"
    local back_re="^b:"
    for mod in $@; do
        if [[ $mod =~ $reset_re ]]; then
            echo -ne "\033[0m"
        elif [[ $mod =~ $fore_re ]]; then
            mod=${mod#f:}
            if [[ $mod == "standard" ]]; then
                echo -ne "\033[39m"
            else
                echo -ne "\033[38;5;${mod}m"
            fi
        elif [[ $mod =~ $back_re ]]; then
            mod=${mod#b:}
            if [[ $mod == "standard" ]]; then
                echo -ne "\033[49m"
            else
                echo -ne "\033[48;5;${mod}m"
            fi
        elif [[ $mod == "bold" ]]; then
            echo -ne "\033[1m"
        elif [[ $mod == "faint" ]]; then
            echo -ne "\033[2m"
        elif [[ $mod == "italic" ]]; then
            echo -ne "\033[3m"
        elif [[ $mod == "underline" ]]; then
            echo -ne "\033[4m"
        elif [[ $mod == "invert" ]]; then
            echo -ne "\033[7m"
        elif [[ $mod == "regular" ]]; then
            echo -ne "\033[22;23;24;27m"
        fi
    done
    return 0
}

bartlet_color_wrap()
{
    echo -ne "\[$(bartlet_color $@)\]"
    return 0
}

bartlet_show_colors()
{
    local index=0
    while [[ ${index} -lt 256 ]]; do
        local offset=0
        while [[ ${offset} -lt 8 ]]; do
            local pindex="${index}"
            while [[ ${#pindex} -lt 3 ]]; do
                pindex=" ${pindex}"
            done
            echo -ne "$(bartlet_color b:${index})    ${pindex}    $(bartlet_color reset)"
            (( index++ ))
            (( offset++ ))
        done
        echo ""
    done
}

bartlet_define()
{
    local name="${1}"
    local callback="${2}"

    BARTLET_ALL_BARS["${name}"]="L 0 ${callback}"
}

bartlet_enable()
{
    local name="${1}"
    local item=( ${BARTLET_ALL_BARS["${name}"]} )
    if [[ ${item[1]} == 1 ]]; then
        return 0
    fi

    item[1]=1
    BARTLET_ALL_BARS["${name}"]="${item[@]}"
    BARTLET_BAR_ORDER[${#BARTLET_BAR_ORDER[*]}]=${name}
}

bartlet_disable()
{
    local name="${1}"
    local item=( ${BARTLET_ALL_BARS["${name}"]} )
    item[1]=0
    BARTLET_ALL_BARS["${name}"]="${item[@]}"
    local removed=( "${name}" )
    BARTLET_BAR_ORDER=( "${BARTLET_BAR_ORDER[@]/${removed}}" )
}

bartlet_align()
{
    local name="${1}"
    local align="${2:-"L"}"
    echo ${align}

    local item=( ${BARTLET_ALL_BARS["${name}"]} )
    item[0]="${align}"
    BARTLET_ALL_BARS["${name}"]="${item[@]}"
}

bartlet_available()
{
    for bar in "${!BARTLET_ALL_BARS[@]}"; do
        local item=( ${BARTLET_ALL_BARS["${bar}"]} )
        local enabled="$(bartlet_color f:${BARTLET_DISABLED_FG})Disabled$(bartlet_color reset)"
        if [[ ${item[1]} == 1 ]]; then
            enabled="$(bartlet_color f:${BARTLET_ENABLED_FG})Enabled$(bartlet_color reset)"
        fi
        echo -e "${bar} ${enabled}"
    done
}
bartlet_status()
{
    bartlet_available
}

__bartlet_start()
{
    BARTLET_RBAR_BG=${BARTLET_PROMPT_BG}
    BARTLET_RBAR_FG=${BARTLET_PROMPT_FG}
    BARTLET_RPREV_BAR_FG=0
    BARTLET_RPREV_BAR_BG=0
    BARTLET_BAR_RCOUNT=0

    BARTLET_LBAR_BG=${BARTLET_PROMPT_BG}
    BARTLET_LBAR_FG=${BARTLET_PROMPT_FG}
    BARTLET_LPREV_BAR_FG=0
    BARTLET_LPREV_BAR_BG=0
    BARTLET_BAR_LCOUNT=0
}

bartlet_rsegment()
{
    local FG=${1:-${BARTLET_RBAR_FG}}
    local BG=${2:-${BARTLET_RBAR_BG}}
    local CONTENT=$3
    local EXTRAS="${4:-}"

    BARTLET_RPREV_BAR_FG=${BARTLET_RBAR_FG}
    BARTLET_RPREV_BAR_BG=${BARTLET_RBAR_BG}
    BARTLET_RBAR_FG=${FG}
    BARTLET_RBAR_BG=${BG}

    if [[ -n "${EXTRAS}" ]]; then
        EXTRAS="${EXTRAS}"
    fi

    local s=""
    local PBG=${BARTLET_RPREV_BAR_BG}
    s="$(bartlet_color_wrap f:${BG})${BARTLET_RSEP}$(bartlet_color_wrap ${EXTRAS} f:${FG} b:${BG})${CONTENT}$(bartlet_color_wrap reset)"

    ((BARTLET_BAR_RCOUNT++))
    BARTLET_BAR_STRING="${s}"
}

bartlet_segment()
{
    local FG=${1:-${BARTLET_LBAR_FG}}
    local BG=${2:-${BARTLET_LBAR_BG}}
    local CONTENT=$3
    local EXTRAS="${4:-}"

    BARTLET_LPREV_BAR_FG=${BARTLET_LBAR_FG}
    BARTLET_LPREV_BAR_BG=${BARTLET_LBAR_BG}
    BARTLET_LBAR_FG=${FG}
    BARTLET_LBAR_BG=${BG}

    if [[ -n "${EXTRAS}" ]]; then
        EXTRAS="${EXTRAS}"
    fi

    local s=""
    if [[ ${BARTLET_BAR_LCOUNT} == 0 ]]; then
        s="$(bartlet_color_wrap ${EXTRAS} f:${FG} b:${BG})${CONTENT}$(bartlet_color_wrap reset)"
    else
        local PBG=${BARTLET_LPREV_BAR_BG}
        s="$(bartlet_color_wrap f:${PBG} b:${BG})${BARTLET_LSEP}$(bartlet_color_wrap ${EXTRAS} f:${FG})${CONTENT}$(bartlet_color_wrap reset)"
    fi

    ((BARTLET_BAR_LCOUNT++))
    BARTLET_BAR_STRING="${s}"
}

#bartlet_header()
#{
#    local FG=${1:-${BAR_FG}}
#    local BG=${2:-${BAR_BG}}
#    local CONTENT=$3
#
#    local spaces=$(( (${COLUMNS} - ${#CONTENT} + 4) / 2))
#    BARTLET_BAR_STRING=""
#    for ((i=0; i<${spaces}; i++)); do
#        BARTLET_BAR_STRING=" ${BARTLET_BAR_STRING}"
#    done
#    BARTLET_BAR_STRING="${BARTLET_BAR_STRING}\[\033[3${BG:1}m\]${BARTLET_RSEP}\[\033[${FG};${BG}m\] ${CONTENT} \[\033[49;3${BG:1}m\]${BARTLET_LSEP}\[\033[0m\]"
#}

__bartlet_end()
{
    BARTLET_PREV_BAR_FG=${BARTLET_LBAR_FG}
    BARTLET_PREV_BAR_BG=${BARTLET_LBAR_BG}

    local s="$(bartlet_color_wrap f:${BARTLET_PREV_BAR_BG} b:standard)${BARTLET_LSEP}$(bartlet_color_wrap reset)"
    BARTLET_BAR_STRING="${s}"
}


__bartlet_prompt_cmd()
{
    LAST_RETURN=$?
    PS1=""
    local item
    __bartlet_start
    local line=""
    local index=0
    local PL=""
    local PR=""
    for bar in "${BARTLET_BAR_ORDER[@]}"; do
        if [[ -z "${bar}" ]]; then
            unset BARTLET_BAR_ORDER[${index}]
            continue
        fi
        item=( ${BARTLET_ALL_BARS["${bar}"]} )

        BARTLET_BAR_STRING=""
        if [[ ${item[1]} == 1 ]]; then
            if [[ "${item[0]}" == "L" ]]; then
                ${item[2]} bartlet_segment
                PL="${PL}${BARTLET_BAR_STRING}"
            else
                ${item[2]} bartlet_rsegment
                PR="${PR}${BARTLET_BAR_STRING}"
            fi
        fi
        (( index++ ))
    done
    __bartlet_end
    PS1="${PL}${BARTLET_BAR_STRING}"

    return 0
}

__bartlet_is_enabled=0
BARTLET_MAINTAIN_PROMPT_COMMAND=1
bartlet_on()
{
    if [[ ${__bartlet_is_enabled} == 0 ]]; then
        __BARTLET_PREV_PROMPT=${PS1}
        __BARTLET_PREV_PROMPT_CMD=${PROMPT_COMMAND}
        if [[ ${BARTLET_MAINTAIN_PROMPT_COMMAND} == 1 && -n "${__BARTLET_PREV_PROMPT_CMD}" ]]; then
            PROMPT_COMMAND="${PROMPT_COMMAND};__bartlet_prompt_cmd"
        else
            PROMPT_COMMAND="__bartlet_prompt_cmd"
        fi
        __bartlet_is_enabled=1
    fi
}

bartlet_off()
{
    if [[ ${__bartlet_is_enabled} == 1 ]]; then
        PS1=${__BARTLET_PREV_PROMPT}
        PROMPT_COMMAND="${__BARTLET_PREV_PROMPT_CMD}"
        __bartlet_is_enabled=0
    fi
}

bartlet_restart()
{
    bartlet_off
    bartlet_on
}

# include all plugins
__bartlet_init()
{
    local owd=${1:-}
    local cwd="$(pwd)"
    local dir

    if [[ ! -d "${owd}" ]]; then
        return 1
    fi

    cd "${owd}"
    for dir in *; do
        if [[ -d "${dir}" && -f "${dir}/${dir}.sh" ]]; then
            cd "${owd}/${dir}"
            source "${dir}.sh"
        fi
    done

    cd "${cwd}" # zsh error ^[[0m
    return 0
}

BARTLET_BAR_ORDER=()

if [[ $- == *i* ]]; then
    trap 'echo -ne "\033[0m"' DEBUG

    __bartlet_init /etc/bartlet_plugins/
    __bartlet_init ${HOME}/.bartlet_plugins/

    if [[ -e "${HOME}/.bartlet_colors" ]]; then
        source "${HOME}/.bartlet_colors"
    fi

fi
