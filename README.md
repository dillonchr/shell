# Shell Scripts

Inspired by [this blog post on write.as](https://write.as/bpsylevc6lliaspe) I'm going to start collecting all the random functions I have in my `.zshrc` into standalone scripts.

Wherever you decide to clone this, here's the key to getting this repo plugged in:

Add the following to your `~/.bash(or whatever)rc`:

```
ZSHRC_D=~/.config/shell
[[ -r ${ZSHRC_D}/bootstrap ]] && . ${ZSHRC_D}/bootstrap
```
