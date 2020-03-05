#!/bin/bash -e

CUSTOM_SCRIPTS_DIR=${CUSTOM_SCRIPTS_DIR:-/opt/custom-scripts}

function run_custom_scripts() {
  echo "Looking for custom setup scripts..."
  ls -l $CUSTOM_SCRIPTS_DIR | grep -e "^.*\.sh$"

  if [[ "$?" = 0 ]]; then
    chmod +x $CUSTOM_SCRIPTS_DIR/*.sh
    for file in $CUSTOM_SCRIPTS_DIR/*.sh; do

      if [[ -f "$file" && -x "$file" ]]; then
        echo "Executing custom setup script: $file"

        bash $file

        if [[ "$?" = 0 ]]; then
          echo "Done instaling $file."
        else
          echo "Failed to execute $file"
          return 1
        fi
      fi
    done
  else
    echo "no custom install script found."
  fi
}

run_custom_scripts
echo "Install done."
