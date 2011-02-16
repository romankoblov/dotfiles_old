#!/bin/bash
dotfile(){
	if [ -f "$HOME/$1" ]; then
		echo "File exists: $1"
    else
		ln -s "$HOME/dotfiles/$1" "$HOME/$1";
	fi
}

dotfile ".bash_profile"
dotfile ".bashrc"
dotfile ".nanorc"
dotfile ".gitconfig"
