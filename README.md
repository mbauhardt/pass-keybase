# Background
The idea behind this project is to have an encrypted backup of my gpg container maintained with pass.
One question could be why would I like to have a backup?
Here are some reasons why I want to have a backup of my gpg-encrypted passwords.

* It happened to me that I went to the office and I forget my yubikey. So I was not able to decrypt any of my passwords. No email, no irc, no webbased logins, no git usage or ssh logins at this time.
* It happened to me that I type in a wrong password 3 times in a row for my yubikey. So my yubikey was locked and I hadn't my admin/reset pin with me.
* Sometimes I'm to lazy to standup go to my physical keyring to grab my yubikey. In such moment it would be nice to decrypt a password without my gpg key.

# Goal
I love [pass](http://passwordstore.org). I don't want to use a new tool.
So the goal is to use [pass](http://passwordstore.org) and write an extension to create an encrypted backup from all of my existing gpg encypted passwords.
I will use [keybase](http://www.keybase.io) for backup encryption.
The version control functionality (via git) of pass will also be supported by this extension.
In other words, keybase encrypted passwords will be commited to your git repo.

# Solution

## Tutorial

Lets create a new password store and enable the extension support

    /tmp/passwords
    ❯ export PASSWORD_STORE_ENABLE_EXTENSIONS=true

    /tmp/passwords
    ❯ export PASSWORD_STORE_DIR=/tmp/passwords

Generate a new password, e.g. for github.com

    /tmp/passwords
    ❯ pass generate Websites/github.com
    [master a0befb2] Add generated password for Websites/github.com.
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 Websites/github.com.gpg
    The generated password for Websites/github.com is:
    9lllpU3K4NUx#r&vn{(<dtCqr

Double check if the password is added to the git repo

    /tmp/passwords
    ❯ glol
    * a0befb2 - (HEAD -> master) Add generated password for Websites/github.com. (5 seconds ago) <Marko Bauhardt>
    * 73a0e91 - Configure git repository for gpg file diff. (20 seconds ago) <Marko Bauhardt>
    * 0e00d33 - Add current contents of password store. (21 seconds ago) <Marko Bauhardt>

Use pass-keybase report to figure out if there is a new gpg entry

    /tmp/passwords
    ❯ pass keybase report

    Number of GPG encryped files: 1
    Number of Keybase encryped files: 0

    GPG encrypted passwords which are not encrypted with Keybase:
    *************************************************************
    Websites/github.com


You can encrypt the whole password store

    /tmp/passwords
    ❯ pass keybase encrypt-all
    [master 20b145b] Reencrypt password store using keybase-id mbauhardt
     3 files changed, 218 insertions(+)
     create mode 100644 Websites/github.com.keybase

    /tmp/passwords
    ❯ glol
    * 20b145b - (HEAD -> master) Reencrypt password store using keybase-id mbauhardt (19 seconds ago) <Marko Bauhardt>
    * a0befb2 - Add generated password for Websites/github.com. (3 minutes ago) <Marko Bauhardt>
    * 73a0e91 - Configure git repository for gpg file diff. (3 minutes ago) <Marko Bauhardt>
    * 0e00d33 - Add current contents of password store. (3 minutes ago) <Marko Bauhardt>

Lets decrpt with keybase to make sure everyting went well.

    /tmp/passwords
    ❯ pass keybase decrypt Websites/github.com
    Authored by mbauhardt (you).
    9lllpU3K4NUx#r&vn{(<dtCqr

For sure, you can also encrypt a single gpg entry

    /tmp/passwords
    ❯ pass generate Websites/mailbox.org

    /tmp/passwords
    ❯ pass keybase encrypt Websites/mailbox.org

    /tmp/passwords
    ❯ pass
    Password Store
    └── Websites
        ├── github.com
        ├── github.com.keybase
        ├── mailbox.org
        └── mailbox.org.keybase


## Installation

You have to enable the extension support for pass by exporting the following variable.

    export PASSWORD_STORE_ENABLE_EXTENSIONS=true

Copy the script `keybase.bash` to your extension directory.

### Quick and Dirty

*via curl*

    mkdir ~/.password-store/.extensions
    cd ~/.password-store/.extensions
    curl -fsSL https://raw.githubusercontent.com/mbauhardt/pass-keybase/master/keybase.bash -o keybase.bash
    chmod u+x keybase.bash

*via wget*

    mkdir ~/.password-store/.extensions
    cd ~/.password-store/.extensions
    wget https://raw.githubusercontent.com/mbauhardt/pass-keybase/master/keybase.bash -O
    chmod u+x keybase.bash

### The recommended way
 *via git submodule*

Install pass-keybase as submodule

    mkdir ~/.password-store/.extensions
    cd ~/.password-store/.extensions
    git submodule add git@github.com:mbauhardt/pass-keybase.git pass-keybase
    ln -s pass-keybase/keybase.bash keybase.bash

Commit and push the submodule to your existing git repo

    cd ~/.password-store
    git add .extensions/pass-keybase
    git add .gitmodules
    git add .extensions/keybase.bash
    git commit -m 'added submodule pass-keybase'

## Usage

The `help` command shows all the available commands.

    pass keybase help

The `version` command shows the version of the program.

    pass keybase version

The `init` command initialize the program. This must be called before the program can be used.
`keybase-id...` is a space separated list of keybase usernames which will be used to encrypt or decrypt passwords.

    pass keybase init keybase-id...

The `encrypt` command can be use to decrypt the given `pass-name` via gpg and pipe it to keybase to encrypt it under the same path but with extension '.keybase'.
   
    pass keybase encrypt pass-name
  
`encrypt-all` is there to make a keybase encrypted backup of all your gpg encrypted passwords.
    
    pass keybase encrypt-all

Use the `decrypt` command to decrypt a given pass-name
    
    pass keybase decrypt pass-name

It is also possible to decrypt a password file and put the first line on the clipboard.
The clipboard will be cleared in $CLIP_TIME seconds.
    
    pass keybase clip pass-name

To remove a given pass-name use the command described below.
    
    pass keybase remove pass-name

With `remove-all` all of your keybase encrypted passwords will be removed.

    pass keybase remove-all

`report` print out how many GPG and how many Keybase encrypted files you have.

    pass keybase report


