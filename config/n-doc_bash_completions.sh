#/usr/bin/env bash

function _release-documents_completions()
{
  local the_documents=$(cat common/db/releases.csv | tail -n+2 | cut -d ';' -f1 | xargs)
  COMPREPLY=($(compgen -W "--all --assume-yes --print-table --help --dry-run $the_documents" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

complete -F _release-documents_completions release_documents.sh


