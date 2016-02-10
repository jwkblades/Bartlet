STATUS_GOOD_FG="standard"
STATUS_GOOD_BG=76
STATUS_GOOD_CONTENT=""

STATUS_BAD_FG="standard"
STATUS_BAD_BG=196
STATUS_BAD_CONTENT=""

lastStatusBar()
{
    local statusFG=${STATUS_GOOD_FG}
    local statusBG=${STATUS_GOOD_BG}
    local content="${STATUS_GOOD_CONTENT}"
    if [[ ${LAST_RETURN} != 0 ]]; then
        statusFG=${STATUS_BAD_FG}
        statusBG=${STATUS_BAD_BG}
        content="${STATUS_BAD_CONTENT}"
    fi
    ${1} ${statusFG} ${statusBG} "${content}" "bold"
}
bartlet_define "LastStatus" "lastStatusBar"
