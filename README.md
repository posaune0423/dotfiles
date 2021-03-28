# dotfiles
I really respect the settings of [Takuya Matsuyama](https://github.com/craftzdog/dotfiles-public).

## neovim

if you have an error such as `this plugin requires python3 support`
you may well run below

```
pip3 install --user pynvim
```

## dein.vim

### before start using

you should run below

```
cd
touch .cache/dein

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
# For example, we just use `~/.cache/dein` as installation directory
sh ./installer.sh ~/.cache/dein
```
