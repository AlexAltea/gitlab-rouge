#!/usr/bin/env bash
set -euxo pipefail

# Find latest installation
PATH_GITLAB=/opt/gitlab/embedded
PATH_ROUGE=$(find $PATH_GITLAB -name rouge-* -type d | sort --reverse | head -n1)
if [[ -z "$PATH_ROUGE" ]]; then
    echo "Could not find Rouge installation in $PATH_GITLAB" 1>&2
    exit 1;
fi
echo "Found Rouge installation in $PATH_ROUGE"

# Find lexers
PATH_LEXERS=$PATH_ROUGE/lib/rouge/lexers
if [[ ! -d $PATH_LEXERS ]]; then
    echo "Could not find lexers in Rouge installation" 1>&2
    exit 1;
fi

# Install or uninstall
if [[ $1 = "--remove" ]]; then
    echo "Removing lexers from $PATH_LEXERS"
    for lexer_src in ./lexers/*.rb; do
        lexer_dst="$PATH_LEXERS/$(basename $lexer_src)"
        echo "- $lexer_dst"
        rm $lexer_dst
    done
else
    echo "Testing lexers"
    if ! ./test.sh $PATH_GITLAB/bin/ruby $PATH_ROUGE/bin/rougify; then
        echo "Tests failed, nothing will be installed" 1>&2
        exit 1;
    fi
    echo "Copying lexers to $PATH_LEXERS"
    for lexer_src in ./lexers/*.rb; do
        lexer_dst="$PATH_LEXERS/$(basename $lexer_src)"
        echo "- $lexer_dst"
        if [[ -f $lexer_dst ]]; then
            echo "Destination file already exists, please uninstall first via: $0 --remove" 1>&2
            exit 1;
        fi
        cp -n $lexer_src $lexer_dst
    done
fi

# Restart GitLab
echo "Restarting GitLab"
sudo gitlab-ctl restart
echo "Done!"
