Tutorial
========

Lets create a new password store and enable the extension support

::

  /tmp/passwords
  ❯ export PASSWORD_STORE_DIR=/tmp/passwords

Generate a new password, e.g. for github.com

::

  /tmp/passwords
  ❯ pass generate Websites/github.com
  [master a0befb2] Add generated password for Websites/github.com.
  1 file changed, 0 insertions(+), 0 deletions(-)
  create mode 100644 Websites/github.com.gpg
  The generated password for Websites/github.com is:
  9lllpU3K4NUx#r&vn{(<dtCqr

Double check if the password is added to the git repo

::

  /tmp/passwords
  ❯ glol
  * a0befb2 - (HEAD -> master) Add generated password for Websites/github.com. (5 seconds ago) <Marko Bauhardt>
  * 73a0e91 - Configure git repository for gpg file diff. (20 seconds ago) <Marko Bauhardt>
  * 0e00d33 - Add current contents of password store. (21 seconds ago) <Marko Bauhardt>

Use pass-keybase report to figure out if there is a new gpg entry

::

  /tmp/passwords
  ❯ pass keybase report
  
  Number of GPG encryped files: 1
  Number of Keybase encryped files: 0
  
  GPG encrypted passwords which are not encrypted with Keybase:
  *************************************************************
  Websites/github.com

You can encrypt the whole password store

::

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

::

  /tmp/passwords
  ❯ pass keybase decrypt Websites/github.com
  Authored by mbauhardt (you).
  9lllpU3K4NUx#r&vn{(<dtCqr

For sure, you can also encrypt a single gpg entry

::

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

