#!/usr/bin/env sh

function install {
  for f in ./*; do
    basename=$(basename $f)

    # Skip sourcing isntaller itself
    if [ "$basename" == "$(basename $0)" ] ; then continue; fi
    target=$(echo $basename | sed 's_\(.*\)\.ln_\.\1_')

    if [ -s ~/$target ]; then
      echo "Found $target, going to remove..."
      rm ~/$target
    fi

    ln -s $f ~/$target
  done
}

while true; do
  read -p "Do you wish to install this program? (Y/N): " yn
    case $yn in
      [Yy]* ) install;  break;;
      [Nn]* ) echo "Aborting..."; exit;;
      * ) echo "Please answer Y or N.";;
    esac
done

echo "Installation complete."
