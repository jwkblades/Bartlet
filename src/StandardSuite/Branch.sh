BRANCH_DIRTY_FG=160
BRANCH_CLEAN_FG=166
BRANCH_BAR_BG=235

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
    if [[ -n "${branch}" ]]; then
        local dirty=""
        if [[ ${repo} == "hg" ]]; then
            dirty="$($(return $(hg status 2>/dev/null | wc -l)) && echo '${BRANCH_CLEAN_FG}' || echo '${BRANCH_DIRTY_FG};1')"
        elif [[ ${repo} == "git" ]]; then
            dirty="$($(git diff-files --quiet &>/dev/null) && echo '${BRANCH_CLEAN_FG}' || echo '${BRANCH_DIRTY_FG};1')"
        fi
        branch=" \[\033[38;5;${dirty}m\]⎇ \[\033[38;5;${BRANCH_CLEAN_FG}m\]${branch} "
    fi
    echo -n "${branch}"
}

branchBar()
{
    ${1} ${BRANCH_CLEAN_FG} ${BRANCH_BAR_BG} "$(determineBranch)"
}
bartlet_define "Branch" "branchBar"
