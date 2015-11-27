#!/usr/bin/env bash

files_dir=../files

function absolute_path {
  echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

function install_dotfiles {
  for f in $files_dir/*; do
    basename=$(basename $f)

    # Skip sourcing odd files
    if test $basename == ".ln" ; then continue ; fi
    target=$(echo $basename | sed 's_\(.*\)\.ln_\.\1_')

    if [ -s ~/$target ]; then
      echo "Found ~/$target, going to remove it..."
      rm -r ~/$target
    fi

    ln -s $(absolute_path $f) ~/$target
  done
}

function install_plug {
  echo "Installing Plug, a Vim package manager.."
  local plug_path="$HOME/.vim/autoload/plug.vim"

  if [ ! -d $plug_path ]; then
    curl -fLo $plug_path --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

function install_dependencies {
  local os=$(uname -s)

  case $os in
    Linux)
      . /etc/lsb-release

      if [ "$DISTRIB_ID" = "Ubuntu" ]; then
        echo "Going to install Vim plugin dependencies"
        sudo apt-get -y install silversearcher-ag
        echo "Vim plugin dependencies installed"
      else
        echo "Don't know how to install dependencies for $DISTRIB_ID"
      fi
      ;;
    Darwin)
      # brew update && brew install ctags make clang
      brew update && brew install ag
      ;;
  esac
}

while true; do
  echo "Your existing dotfiles will be replaced with those from the 'files' directory."
  read -p "Proceed (Y/N): " yn

  case $yn in
    [Yy]* ) install_dotfiles && echo "Done installing dotfiles"; break;;
    [Nn]* ) echo "Aborting..."; exit;;
    * ) echo "Please answer Y or N.";;
  esac
done

source ~/.bashrc
install_plug && echo "Done installing NeoBundle"
install_dependencies && echo "Dependenciea installed"

echo "Installation complete."
