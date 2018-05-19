cmd_version() {
  echo 'v0.1'
}

cmd_description() {
  cat << _EOF
=================================================================
= pass-keybase: Re-encrypt and decrypt pass entries via keybase =
=                                                               =
=                           v0.1                                =
=                                                               =
=           https://github.com/mbauhardt/pass-keybase           =
=================================================================
_EOF
}

cmd_help() {
  cmd_description
  echo
  cat << _EOF
Usage:
  pass keybase help
    Show this help text
  pass keybase version
    Show the version
_EOF
}

case "$1" in
  help)
    cmd_help
    ;;
  version)
    cmd_version
    ;;
  *)
    cmd_help
    ;;
esac
exit 0
