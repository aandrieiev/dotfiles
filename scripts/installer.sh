#!/usr/bin/env sh

files_dir=./files

function absolute_path {
  echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

function install {
  for f in $files_dir/*; do
    basename=$(basename $f)

    # Skip sourcing odd files
    if test $basename == ".ln" ; then continue ; fi
    target=$(echo $basename | sed 's_\(.*\)\.ln_\.\1_')

    if [ -s ~/$target ]; then
      echo "Found ~/$target, going to remove it..."
      rm -r ~/$target
    fi

    echo $(absolute_path $f)
    ln -s $(absolute_path $f) ~/$target
  done
}

while true; do
  echo "Your existing dotfile will be replaced with those from the 'files' directory."
  read -p "Proceed (Y/N): " yn
    case $yn in
      [Yy]* ) install;  break;;
      [Nn]* ) echo "Aborting..."; exit;;
      * ) echo "Please answer Y or N.";;
    esac
done

source ~/.bashrc

echo "Installation complete."
