Mathjax (the javascript library) renders mathematical equations in a web page. But it's heavy and may not be supported everywhere. For example, Github Wiki does not allow use of external javascript libraries.  HTML pages with bitmap equations are light and with as little dependency as possible.

# What
This script generates png images from equations in a (R)Markdown document and replace an equation enclosed in \$ or \$\$ with a reference to the rendered image.

# Installation and Dependencies
In a Debian based OS:
```sh
sudo apt install bash texlive-base grep sed imagemagick
# install required latex packages
tlmgr install array standalone mathtools amssymb amsthm

git clone https://github.com/faridcher/math2img
cd math2eqn
chmod +x eqn2img.sh
```

# Usage
```sh
# first argument is an auto-created directory to put the images and a (Github) Markdown document is read from stdin
./math2img eqn/ < gfm.md
```

# Alternatives
- [A Pandoc filter](https://github.com/liamoc/latex-formulae)
- [GladTex](https://github.com/humenda/GladTeX) written in Python; use it in combination with `pandoc --gladtex` option.
- [math2img](https://github.com/kkew3/math2img) written in Perl

Compared to the above alternatives, this script is simpler and with minimal dependencies.

# Limitations
- Only works with equations enclosed in single $ for inline and double dollar sign ($$) for display equations
- Sed scripts are concise but notorious for being inaccessible to human

# Todo
- Support \[\] for display and \(\) for inline equations

# License
GPL v2
