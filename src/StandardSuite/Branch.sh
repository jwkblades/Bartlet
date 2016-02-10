BRANCH_DIRTY_FG=160
BRANCH_CLEAN_FG=166
BRANCH_BAR_BG=235
BRANCH_FADE_FG=240

BRANCH_SHOW_HG_STATUS=0

BRANCH_CHAR="⎇ "
BRANCH_IN="↓"
BRANCH_OUT="↑"

determineBranch()
{
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local repo="git"
    if [[ -z ${branch} ]]; then
        branch=$(hg branch 2>/dev/null)
        repo="hg"
        if [[ -z ${branch} ]]; then
            repo=""
        fi
    fi
    local incoming=0
    local outgoing=0

    local inColor=${BRANCH_FADE_FG}
    local outColor=${BRANCH_FADE_FG}

    if [[ -n "${branch}" ]]; then
        local dirty=""
        if [[ ${repo} == "hg" ]]; then
            dirty="$($(return $(hg status 2>/dev/null | wc -l)) && echo -ne "$(bartlet_color_wrap f:${BRANCH_CLEAN_FG})" || echo -ne "$(bartlet_color_wrap bold f:${BRANCH_DIRTY_FG})")"
            if [[ ${BRANCH_SHOW_HG_STATUS} -eq 1 ]]; then
                $(hg in -l 1 &>/dev/null)
                if [[ $? -eq 0 ]]; then
                    inColor=${BRANCH_DIRTY_FG}
                fi
                $(hg out -l 1 &>/dev/null)
                if [[ $? -eq 0 ]]; then
                    outColor=${BRANCH_DIRTY_FG}
                fi
            fi
        elif [[ ${repo} == "git" ]]; then
            if [[ "${branch}" == "HEAD" ]]; then
                branch="$(git rev-parse --short HEAD 2>/dev/null)"
            fi
            dirty="$($(return $(git status --porcelain 2>/dev/null | wc -l)) && echo -ne "$(bartlet_color_wrap f:${BRANCH_CLEAN_FG})" || echo -ne "$(bartlet_color_wrap bold f:${BRANCH_DIRTY_FG})")"
            local remote="$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2>/dev/null)"
            if [[ -n "${remote}" ]]; then
                local deltas="$(git log --format='%m' --topo-order --left-right ${branch}...${remote} 2>/dev/null)"
                outgoing=$(echo "${deltas}" | grep "^<" | wc -l)
                incoming=$(echo "${deltas}" | grep "^>" | wc -l)
                if [[ ${incoming} -gt 0 ]]; then
                    inColor=${BRANCH_DIRTY_FG}
                fi
                if [[ ${outgoing} -gt 0 ]]; then
                    outColor=${BRANCH_DIRTY_FG}
                fi
            fi
        fi
        branch=" ${dirty}${BRANCH_CHAR}$(bartlet_color_wrap f:${BRANCH_CLEAN_FG})${branch} $(bartlet_color_wrap f:${inColor})${BRANCH_IN}$(bartlet_color_wrap f:${outColor})${BRANCH_OUT} "
    fi
    echo -ne "${branch}"
}

branchBar()
{
    ${1} ${BRANCH_CLEAN_FG} ${BRANCH_BAR_BG} "$(determineBranch)"
}
bartlet_define "Branch" "branchBar"
