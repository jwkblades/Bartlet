#!/usr/bin/bash

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
            dirty="$($(return $(hg status 2>/dev/null | wc -l)) && echo '166' || echo '160;1')"
        elif [[ ${repo} == "git" ]]; then
            dirty="$($(git diff-files --quiet &>/dev/null) && echo '166' || echo '160;1')"
        fi
        branch=" \[\033[38;5;${dirty}m\]⎇ \[\033[38;5;166m\]${branch} "
    fi
    echo -n "${branch}"
}

branchBar()
{
    local branch="$(determineBranch)"
    addBar "38;5;45" "48;5;235" "$(determineBranch)"
}
defineBar "Branch" "branchBar"
