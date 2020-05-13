Usage
=====

The `help` command shows all the available commands.

::

  pass keybase help

The `version` command shows the version of the program.

::

  pass keybase version

The `init` command initialize the program. This must be called before the program can be used.
`keybase-id...` is a space separated list of keybase usernames which will be used to encrypt or decrypt passwords.

::

  pass keybase init keybase-id...

The `encrypt` command can be use to decrypt the given `pass-name` via gpg and pipe it to keybase to encrypt it under the same path but with extension '.keybase'.

::

  pass keybase encrypt pass-name
  
`encrypt-all` is there to make a keybase encrypted backup of all your gpg encrypted passwords.

::

  pass keybase encrypt-all

Use the `decrypt` command to decrypt a given pass-name

::

  pass keybase decrypt pass-name

It is also possible to decrypt a password file and put the first line on the clipboard.
The clipboard will be cleared in $CLIP_TIME seconds.

::

  pass keybase clip pass-name

To remove a given pass-name use the command described below.

::

  pass keybase remove pass-name

With `remove-all` all of your keybase encrypted passwords will be removed.

::

  pass keybase remove-all

`report` print out how many GPG and how many Keybase encrypted files you have.

::

  pass keybase report

Over the time it will happen that you have to update your password from a given
website. If so, you will use `pass` to update your GPG password, and maybe
forget to update your keybase entry via `pass keybase encrypt`. And this can
happen to many of your passwords. Using the `diff` command can help to get an
overview which passwords are not in sync / are not equal to each other.

::

  pass keybase diff

