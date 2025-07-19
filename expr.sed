# multiline display math to single line: convert newline to space and then remove leading and trailing spaces
# match lines with $$CHARS, read next lines until a line ends with $$, substitute $$SPACE or SPACE$$ with $$
/^'$B'$/{
:x N; /'$E'$/!bx
s/\n/ /g
s/^'$B' +/\1/g
s/ +'$E'$/\1/g
}
# single-line display math
# match lines like $$CHARS$$ and pass them to m2i
/^'$B'.+'$E'$/{
s/.*/'"$P"'&'"$A"'/e; n 
}
# inline eqn
# substitute all $EQN$ with $(_m2i $EQN$ eqn) and echo the line
# if non-backslash or BOL precedes $EQN$, substitute
# [^$]* make non-greedy search
# echoing the line is prone to several shell expansions e.g. `data`, [^1], etc.
# escape all single quotations in a line
/[^\]*\$.+\$/{
s/'\''/'"'\\\''"'/g
# re-escape quotes inside eqn. TODO: deal multiple quotes
s/([^\]|^)(\$[^$]*)('"\\\'"')([^$]*\$)/\1\2'"\"'\\\''\""'\4/
s/([^\]|^)(\$[^$]*\$)/\1'\''$('"$P"'\2'"$A"')'\''/g
s/.*/echo '\''&'\''/e
}
