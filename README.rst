pass-keybase
============

- Documentation_

*pass-keybase* is a pass_ extension to create an encrypted backup of all your existing gpg encypted passwords.
Under the hood keybase_ is used to encrypt the backup.

The version control functionality (via git) of pass will also be supported by this extension.
In other words, keybase encrypted passwords will be commited to your git repo.

.. _pass: https://www.passwordstore.org/
.. _keybase: https://keybase.io/
.. _Documentation: https://pass-keybase.readthedocs.io/

Encrypt one or all password

.. image:: https://pass-keybase.readthedocs.io/en/latest/_images/encrypt.png

Decrypt a password

.. image:: https://pass-keybase.readthedocs.io/en/latest/_images/decrypt.png

There are several more commands, e.g. reporting to figure out if your
GPG and Keybase keychain is in sync.

