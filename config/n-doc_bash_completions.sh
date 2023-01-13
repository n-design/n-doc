#/usr/bin/env bash

function list_documents() {
    echo $(cat common/db/releases.csv | tail -n+2 | cut -d ';' -f1 | xargs)
}

function _release-documents_completions()
{
  COMPREPLY=($(compgen -W "--all --assume-yes --print-table --help --dry-run $(list_documents)" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

function _remove-document_completions()
{
  COMPREPLY=($(compgen -W "$(list_documents)" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

complete -F _release-documents_completions release_documents.sh
complete -F _remove-document_completions remove_document.sh


