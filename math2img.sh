# Expects a gfm markdown document from pandoc (-t gfm) with TeX equations (without --webtex).
# ARGS: a GFM markdown file and an output directory
# STDOUT: a new GFM markdown with equations replaced with their references to png files
# Example: math2img eqn <~/code/sh/tex/gfm.md
math2img(){
  # assume no space in OUTDIR
  # [ $# -ne 2 ] && echo "two arguments are needed; received $#" >&2 && return 1
  local OUTDIR=$1 GFM=$2
  # get formulas with sed; generate pngs and replace with img links
  # ' instead of " for sed expression to inhibit bash expansions of $, !, etc.
  # echo \'\\\\\'\' or "'\\\''" is '\\''; sed uses first \ to escape the second
  # we want this in the sed expression: bash -ic '_m2i '\\''$$EQN$$'\\'' dir'
  # for inline eqn, quote non-equation text to prevent expansions: 'this is tex '$eqn$' and more text'
  # $P&$A or $P\2$A
  # interactive bash calls stty -ixon and gives "Inappropriate ioctl for device" warning. 
  local P="bash -c '. ~\/code\/sh\/tex\/math2img.sh; _m2i '\\\''" 
  local A="'\\\'' $OUTDIR'"
  local B='(\$\$[^$]*|\\begin\{(align|multiline|equation|displaymath).?\})'
  local E='(\$\$|\\end\{(align|multiline|equation|displaymath).?\})'
  local EXPR='
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
  '
  if [ $# -eq 2 ]; then
    sed -E "$EXPR" "$GFM"
  elif [ $# -eq 1 ]; then
    sed -E "$EXPR"
  else
   echo "one or two arguments are needed; received $#" >&2 && return 1
  fi
}

# generate png from a LaTeX equation and write it to a directory
# ARGS: A LateX equation and an output directory
# STDOUT: Markdown image pointing to the generated png file
_m2i(){
  # MATH="$\theta^2+\sum_{i=1}^n$"
  [ $# -ne 2 ] && echo "two arguments are needed; received $#" >&2 && return 1
  local MATH=$1 OUTDIR=$2
  [ -e $OUTDIR ] || mkdir -p $OUTDIR
  # generate a filename by summarizing the equation with sum (16bit checksum)
  FNAME=$(echo "$MATH" | cksum | cut -f 1 -d ' ' | paste -d '' - )
  [ -e $OUTDIR/$FNAME.pdf ] || \
    pdflatex -halt-on-error -output-directory $OUTDIR -jobname $FNAME \
    "\def\formula{$MATH}\input{~/code/sh/tex/math.tex}" > /dev/null
  [ -e $OUTDIR/$FNAME.pdf ] || {
    # the $MATH is executed again in sed expression and is prone to expansions
    echo 'ERROR:' "$MATH" ' '
    grep '^!' -A 1 $OUTDIR/$FNAME.log
    return 1
  }
  [ -e $OUTDIR/$FNAME.png ] || \
    convert -density 150 $OUTDIR/$FNAME.pdf -quality 90 $OUTDIR/$FNAME.png &> /dev/null
  echo "![]($OUTDIR/$FNAME.png)"
}

math2img "$@"
