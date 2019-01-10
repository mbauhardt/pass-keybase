Installation
============

You have to enable the extension support for pass by exporting the following variable.

::

  export PASSWORD_STORE_ENABLE_EXTENSIONS=true

Copy the script `keybase.bash` to your extension directory.

Quick and Dirty
---------------

*via curl*

::

  mkdir ~/.password-store/.extensions
  cd ~/.password-store/.extensions
  curl -fsSL https://raw.githubusercontent.com/mbauhardt/pass-keybase/master/keybase.bash -o keybase.bash
  chmod u+x keybase.bash

*via wget*

::

  mkdir ~/.password-store/.extensions
  cd ~/.password-store/.extensions
  wget https://raw.githubusercontent.com/mbauhardt/pass-keybase/master/keybase.bash -O
  chmod u+x keybase.bash

The recommended way
-------------------

*via git submodule*

Install pass-keybase as submodule

::

  mkdir ~/.password-store/.extensions
  cd ~/.password-store/.extensions
  git submodule add git@github.com:mbauhardt/pass-keybase.git pass-keybase
  ln -s pass-keybase/keybase.bash keybase.bash

Commit and push the submodule to your existing git repo

::

  cd ~/.password-store
  git add .extensions/pass-keybase
  git add .gitmodules
  git add .extensions/keybase.bash
  git commit -m 'added submodule pass-keybase'

Update to the latest version

::

  cd ~/.password-store/
  git submodule update --remote

