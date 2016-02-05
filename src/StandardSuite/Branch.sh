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
            dirty="$($(return $(hg status 2>/dev/null | wc -l)) && echo '${BRANCH_CLEAN_FG}' || echo '${BRANCH_DIRTY_FG};1')"
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
            dirty="$($(return $(git status --porcelain 2>/dev/null | wc -l)) && echo '${BRANCH_CLEAN_FG}' || echo '${BRANCH_DIRTY_FG};1')"
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
        branch=" \[\033[38;5;${dirty}m\]${BRANCH_CHAR}\[\033[38;5;${BRANCH_CLEAN_FG}m\]${branch} \[\033[$(bartlet_color 1 ${inColor})m\]${BRANCH_IN}\[\033[$(bartlet_color 1 ${outColor})m\]${BRANCH_OUT} "
    fi
    echo -n "${branch}"
}

branchBar()
{
    ${1} ${BRANCH_CLEAN_FG} ${BRANCH_BAR_BG} "$(determineBranch)"
}
bartlet_define "Branch" "branchBar"
