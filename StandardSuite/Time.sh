TIME_FG=250
TIME_BG=26

LAST_TIME=0

timeBar()
{
    local delta=$((${SECONDS} - ${LAST_TIME}))
    if [[ ${delta} -gt 15 ]]; then
        bartlet_segment ${TIME_FG} ${TIME_BG} " ${delta} "
    fi
    LAST_TIME=${SECONDS}
}
bartlet_define "Time" "timeBar"
