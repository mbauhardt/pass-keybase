.. pass-keybase documentation master file, created by
   sphinx-quickstart on Mon Jan  7 21:58:29 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to pass-keybase's documentation!
========================================

*pass-keybase* is a pass_ extension to create an encrypted backup of all your existing gpg encypted passwords.
Under the hood keybase_ is used to encrypt the backup.

The version control functionality (via git) of pass will also be supported by this extension.
In other words, keybase encrypted passwords will be commited to your git repo.

.. _pass: https://www.passwordstore.org/
.. _keybase: https://keybase.io/

Encrypt one or all password

.. image:: /images/encrypt.png

Decrypt a password

.. image:: /images/decrypt.png



.. toctree::
   :caption: Users
   :maxdepth: 2

   background
   tutorial
   usage
   installation

.. toctree::
   :caption: General
   :maxdepth: 2

   support
   license
