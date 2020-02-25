#!/usr/bin/env bash

# Prepare MWE body for compilation
# If no "body" file is present, create one from template.

BODY_FILE="$1/$1_body.tex"

if [[ ! -f $BODY_FILE ]]; then
    cat > "$BODY_FILE" <<EOF
% Beispieldatei zum Ausprobieren eigener Inhalte
% Bitte nicht einchecken!




%%% Local Variables:
%%% TeX-master: "$1"
%%% TeX-engine: luatex
%%% TeX-parse-self: t
%%% TeX-auto-save: t
%%% mode: latex
%%% End:

EOF
fi
