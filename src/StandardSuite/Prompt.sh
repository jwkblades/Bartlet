PROMPT_GOOD_BG=45
PROMPT_GOOD_FG=16
PROMPT_BAD_BG=178
PROMPT_BAD_FG=16

ENABLE_STANDARD_BAR_STATUS=0

promptBar()
{
    local FG=${PROMPT_GOOD_FG}
    local BG=${PROMPT_GOOD_BG}
    if [[ ${LAST_RETURN} != 0 && ${ENABLE_STANDARD_BAR_STATUS} != 0 ]]; then
        FG=${PROMPT_BAD_FG}
        BG=${PROMPT_BAD_BG}
    fi
    bartlet_segment ${FG} ${BG} "$(bartlet_color_wrap bold)\u@\h $(bartlet_color_wrap regular)\W " ""
}
bartlet_define "Prompt" "promptBar"
