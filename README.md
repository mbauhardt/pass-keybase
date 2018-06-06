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

# Solution

The `help` command shows all the available commands.

    pass keybase help

The `version` command shows the version of the program.

    pass keybase version

The `init` command initialize the program. This must be called before the program can be used.
`keybase-id...` is a space separated list of keybase usernames which will be used to encrypt or decrypt passwords.

    pass keybase init keybase-id...
