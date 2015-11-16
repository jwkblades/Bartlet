LAST_TIME=0
timeBar()
{
    local delta=$((${SECONDS} - ${LAST_TIME}))
    if [[ ${delta} -gt 15 ]]; then
        addBar "38;5;250" "48;5;26" " ${delta} "
    fi
    LAST_TIME=${SECONDS}
}
defineBar "Time" "timeBar"
