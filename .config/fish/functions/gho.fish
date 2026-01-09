function gho --description 'Open GitHub PR page if exists, otherwise repo page'
    gh pr view --web 2>/dev/null; or gh browse
end
