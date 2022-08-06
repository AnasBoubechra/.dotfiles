---
title: "Productivity - CS - Terminal #001"
summary: “It’s not that I’m so smart, it’s just that I stay with problems longer.”

date: 2022-08-06T12:34:11+01:00
draft: false
author: ANAS BOUBECHRA
tags:
- Productivity
- Terminal
- Efficiency
- Linux
- Automation
categories:
- Productivity
asciinema : true
ShowPostNavLinks: true
autonumbering: true

cover:
    image: "/img/productivity.jpg"
---


> Have you ever find yourself trying to tweak things for a better productivity setup or maybe because you're lazy , so you're trying to find a quick way to do things ?

 I certainly been there. 

I've gathered in `#PRODUCTIVITY - CS` posts everything I've
learned,found or come across From **window managers**, simple __terminal__ __aliases__ ,
__shortcuts__ that will definitely make your life easier, __scripts__, and a nice setup
for quick and effective __note__ __taking__.

I'll be using a GNU/Linux (`Arch`) distro, any `UNIX` system will do the trick too!

## 1. Touch typing

Whatever your working at , you will be far more productive if you can type _20 wpm_ faster!
In short touch typing is a technique that helps you type `faster` and more
efficiently by using __all__ your fingers.

A good touch typist does not *look down* at the keyboard when typing.
This can help you reach typing speeds of over __60__ wpm! Below are a few of the top benefits to touch typing.

Here are some great websites to help you with that:

1. https://www.keybr.com/
2. https://10fastfingers.com/typing-test/english
3. https://github.com/lemnos/tt   *For terminal fan folks:*
    > ( A terminal based typing test written in go. )

## 2. Terminal
### 2.1 Fuzzy finder

You might find yourself typing `cd` and `cd ..` over and over again to go back
and forth, Or maybe your using a `GUI` file manager for that! The best solution
I've come across to open files, recursively search for a string in a file! And
do all the fancy (`grep` & `find`) stuff simply using a `fuzzy finder` .


```
fzf
```
{{< asciinema key="fzf" rows="10" preload="1" >}}

>  [fzf](https://github.com/junegunn/fzf) is a general-purpose command-line fuzzy finder.

Out of the box the fuzzy finder is very similar to the find command in any
Unix based systems but certainly does **more than that!**

We'll use this tool to quickly search and open any files with the appropriate software!

For example automatically open:
- images -**-->** feh ( image viewer )
- videos -**-->** mpv , vlc
- pdf  -**-->** zathura, libreoffice

If you're using the bash shell you can create an alias for this command or even
a keybinding simply put this command in your :
```sh
$HOME/.bashrc # Or .zshrc (if you are using the ZSH shell)
```

If you just want to quickly open files use it with xdg-open

`xdg-open` opens a file or URL in the user's preferred application. More info on [xdg-open](http://www.freedesktop.org/wiki/Specifications/mime-apps-spec/)

```sh
xdg-open $(find ~ -type f| fzf)
```

More fancy way is to add `-e` argument (for command) and add some nice features,
open a terminal and paste this:


```sh
find ~ -type f |fzf -e --multi --bind 'ctrl-l:toggle-preview' --bind 'ctrl-k:change-preview-window(down,80%)' --reverse --pointer="->" --prompt="-->: " --preview 'bat -p -f {}')"
```

Or put it in your `.bashrc` file
```sh
# Creating an alias ( instead of typing the whole command every time ... simply type 'fopen')
alias fopen="xdg-open "$(find ~ -type f |fzf -e --multi --bind 'ctrl-l:toggle-preview' --bind 'ctrl-k:change-preview-window(down,80%)' --reverse --pointer="->" --prompt="-->: " --preview 'bat -p -f {}')""
```
{{< asciinema key="fzf_xdg" rows="10" preload="1" >}}

### 2.2 Terminal aliases

Here are some aliases that will save you a lot of time:

```sh
# to quickly get the path of a file
alias getpath='find ~ -type f | fzf --reverse | sed "s/\.[/]//" | tr -d '\n' | c'
# Open whatever the last file you have edited (using vim)
alias lvi=`vim -c "normal '\''0"`

# Open the last edited files ( for either today or the last 24h )
alias today_files_24h='find -mtime -1 | fzf --reverse'
alias today_files='find -newermt $(date +%F) | fzf --reverse'

# Quickly get the wifi password (only for netwok-manager)
alias showpass='nmcli dev wifi show-password'

# Ips
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias localip="ipconfig getifaddr en0"

# Navigation
alias ....="cd ../../.."
alias ...="cd ../.."
alias ..='cd ..'
alias ~="cd ~"
alias cd..='cd ..' # correcting common typos
alias nz="$EDITOR ~/.zshrc"  # quickly edit your .zshrc
alias nb="$EDITOR ~/.bashrc"  # quickly edit your .zshrc

# Merge PDF files
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf'

```

### 2.3 Automation with `bash && dmenu`

`dmenu` is a fast and lightweight dynamic menu for X. It reads arbitrary text
from __stdin__, and creates a menu with one item for each line.

For more info's on `dmenu` : https://tools.suckless.org/dmenu/

Install `dmenu`:

```sh
git clone https://git.suckless.org/dmenu
cd dmenu
sudo make && sudo make install
```
We will use it to quickly run installed applications and search the web with a one click.
Here is a simple shell script to do that:

```sh
#!/bin/sh
SEARCH=$(echo "" | dmenu -fn "Monokai Nerd Font:size=26" -p "")
check(){
	if [ -z $1 ];
	then
		exit
	fi
}
case $SEARCH in
	y|[yY] | yt | youtube)
		YTB=$(echo "" | dmenu  -p "")
		check $YTB
		librewolf "https://www.youtube.com/results?search_query=${YTB}"
		;;
	w|[wi] | wiby)
		WIBY=$(echo "" | dmenu -p "")
		check $WIBY
		librewolf "https://wiby.me/?q=$(sed 's/ /+/g' <<< $WIBY)"
        ;;
	ar|ar|arch)
		arch=$(echo "" | dmenu -p "")
		check $arch
		librewolf "https://wiki.archlinux.org/index.php?search=$(sed 's/ /+/g' <<< $arch)"
        ;;

esac
```

You can add as many websites as you want !
This way you can quickly and directly search your favorite websites without wasting time.

If you don't like to open the terminal + the fuzzy finder you can use `dmenu`
for that too !

`dmenu_open`


```
#!/bin/sh
check(){
	if [ -z $1 ];
	then
		exit
	fi
}
choice=$(find ~ -type f | dmenu -i -p "  Open File " -l 20)
check $choice
TERM="alacritty -e "
MUS="mpv --no-video"
EDITOR="nvim"
IMG="sxiv"
MPV="mpv"
PDF="zathura"
TAR="tar -xvzf"
ZIP="unzip"
case "$choice" in
    *.tar.gz)
            $TAR "$choice" &>/dev/null & disown;;
    *.tgz)
            $TAR "$choice" &>/dev/null & disown;;
    *.mp4|*.mkv|*.webm|*.wav|*.ac3|*.wma)
            $MPV "$choice" &>/dev/null & disown;;
    *.mp3|*.ogg)
            $MUS "$choice" &>/dev/null & disown;;
    *.zip)
            $ZIP "$choice" &>/dev/null & disown;;
    *.jpeg|*.JPEG|*.gif|*.GIF|*.png|*.JPG|*.jpg)
            $IMG "$choice" &>/dev/null & disown;;
    *.pdf|*.PDF)
            $PDF "$choice" &>/dev/null & disown;;
    *)
            $TERM $EDITOR "$choice" &>/dev/null & disown;;
esac
```
> More `dmenu` scripts can be found here 
* [Link1](https://github.com/AnasBoubechra/Scripts) 
* [link2](https://github.com/debxp/dmenu-scripts)

