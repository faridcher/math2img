# Why
We may use Mathjax javascript library to render mathematical equations in a web page. But it's heavery and not supported everywhere; For example, Github Wiki does not allow use of external javascript libraries.  HTML pages with bitmap equations are light and with as little dependency as possible.

# What
This script generates png images from equations in a (R)Markdown document and replace an equation enclosed in \$ or \$\$ with a reference to the rendered image.

# Installation and Dependencies
In a Debian based OS:
```sh
sudo apt install bash texlive-base grep sed imagemagick
# install required latex packages
tlmgr install array standalone mathtools amssymb amsthm

git clone https://gist.github.com/3b113c1f7b9c2c3a40abd31e27b915ab.git math2eqn
cd math2eqn
chmod +x eqn2img.sh
```

# Usage
```sh
# first argument is an auto-created directory to put the images and a (Github) Markdown document is read from stdin
./math2img.sh eqn </path/to/gfm.md
```

# Alternatives
- [A Pandoc filter](https://github.com/liamoc/latex-formulae)
- [GladTex](https://github.com/humenda/GladTeX) written in Python; use it in combination with `pandoc --gladtex` option.
- [math2img](https://github.com/kkew3/math2img) written in Perl

Why to use this script over the others? Mainly due to its simplicity and minimal dependencies.

# Limitations
- Only works with equations enclosed in single $ for inline and double dollar sign ($$) for display equations
- Sed scripts are concise but notorious for not being readable and hence this Bash script as well

# Todo
- Support \[\] for display and \(\) for inline equations

# License
GPL v3
