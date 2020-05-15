cmd_version() {
  echo '0.4'
}

cmd_description() {
  cat << _EOF
=================================================================
= pass-keybase: Re-encrypt and decrypt pass entries via keybase =
=                                                               =
=                           0.4                                 =
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
  pass keybase init keybase-id...
    Setup pass-keybase and creates a config file (.extensions/keybase-id) with keybase usernames.
    The parameter 'keybase-id...' is a space separated list of keybase usernames.
  pass keybase encrypt pass-name
    Decrypt temporary the give pass-name via gpg and encrypt it with keybase under the same path but with extension '.keybase'.
  pass keybase encrypt-all
    Decrypt all gpg encrypted passwords temporary and encrypt everything again via keybase under the the same path but with extension '.keybase'
  pass keybase decrypt pass-name
    Decrypt the given pass-name with keybase.
  pass keybase clip pass-name
    Decrypt the given pass-name with keybase and put it on the clipboard.
    The clipboard will be cleared in $CLIP_TIME seconds.
  pass keybase remove pass-name
    Remove the given pass-name from the store.
  pass keybase remove-all
    Remove all pass-names from the store.
  pass keybase report
    Print out a report about how many gpg and keybase encrypted entries you have.
  pass keybase diff
    Print out all entries from the store which are not in sync. Either the content of the GPG and Keybase passwords are not the same
    or a GPG password is not encrypted with Keybase.
    This command can be run a while, because all entries from your store will be decrypted to make the comparison.
_EOF
}

set_keybase_recipients() {
  KEYBASE_RECIPIENTS=( )
  local kbid="${XDG_CONFIG_HOME:-$HOME/.config}/pass-keybase/keybase-id"
  if [[ ! -f $kbid ]]; then
    cat << _EOF
      Error: You must run '$PROGRAM keybase init keybase-id...' before you want to use the password store keybase extension.
_EOF
      exit 1
  fi
  local keybase_user
  while read -r keybase_user; do
      KEYBASE_RECIPIENTS+=( "$keybase_user" )
  done < "$kbid"
}

cmd_encrypt() {
  set_keybase_recipients
  local path="$1"
  local passfile="$PREFIX/$path.gpg"
  local keybasefile="$PREFIX/$path.keybase"
  check_sneaky_paths "$path"

  if [[ -f "$passfile" ]]; then
    $GPG -d "${GPG_OPTS[@]}" "$passfile" | keybase encrypt -o "$keybasefile" ${KEYBASE_RECIPIENTS[@]}
    set_git "$keybasefile"
    git_add_file "$keybasefile" "Encrypt $path via keybase for user: ${KEYBASE_RECIPIENTS[@]}"
  elif [[ -z "$path" ]]; then
    die ""
  else
    die "Error: $path is not in the password store."
  fi
}

cmd_encrypt_all() {
  set_keybase_recipients
  while read -r -d "" passfile; do
    local keybasefile="${passfile%.gpg}.keybase"
    $GPG -d "${GPG_OPTS[@]}" "$passfile" | keybase encrypt -o "$keybasefile" ${KEYBASE_RECIPIENTS[@]}
    set_git "$keybasefile"
  done < <(find "$PREFIX" -iname '*.gpg' -print0)
  git_add_file "$PREFIX" "Reencrypt password store using keybase-id ${KEYBASE_RECIPIENTS[@]}"
}

cmd_init() {
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/pass-keybase"
  printf "%s\n" "$@" > "${XDG_CONFIG_HOME:-$HOME/.config}/pass-keybase/keybase-id"
}

cmd_remove() {
  local path="$1"
  local passfile="$PREFIX/$path.keybase"
  check_sneaky_paths "$path"

  if [[ -f "$passfile" ]]; then
    set_git "$passfile"
    rm "$passfile"
    git -C "$INNER_GIT_DIR" rm -qr "$passfile"
    set_git "$passfile"
    git_commit "Remove $path from store."
  elif [[ -z "$path" ]]; then
    die ""
  else
    die "Error: $path is not in the password store."
  fi
}

cmd_remove_all() {
  while read -r -d "" passfile; do
    git -C "$INNER_GIT_DIR" rm -qr "$passfile"
    set_git "$passfile"
  done < <(find "$PREFIX" -iname '*.keybase' -print0)
  git_commit "Remove all keybase files from store."
}

cmd_decrypt() {
  local path="$1"
  local passfile="$PREFIX/$path.keybase"
  check_sneaky_paths "$path"

  if [[ -f "$passfile" ]]; then
    keybase decrypt --force -i "$passfile" 
  elif [[ -z "$path" ]]; then
    die ""
  else
    die "Error: $path is not in the password store."
  fi
}

cmd_clip() {
  local path="$1"
  local passfile="$PREFIX/$path.keybase"
  check_sneaky_paths "$path"

  if [[ -f "$passfile" ]]; then
      local pass="$(keybase decrypt --force -i $passfile 2>/dev/null | head -n 1)"
      clip "$pass" "$path"
  elif [[ -z "$path" ]]; then
    die ""
  else
    die "Error: $path is not in the password store."
  fi
}

cmd_report() {
  local gpgcount=0;
  local kbcount=0;

  echo ''
  while read -r -d "" passfile; do
    let gpgcount++;
  done < <(find "$PREFIX" -iname '*.gpg' -print0)
  echo 'Number of GPG encryped files: '$gpgcount

  while read -r -d "" passfile; do
    let kbcount++;
  done < <(find "$PREFIX" -iname '*.keybase' -print0)
  echo 'Number of Keybase encryped files: '$kbcount

  echo ''
  echo 'GPG encrypted passwords which are not encrypted with Keybase:'
  echo '*************************************************************'
  while read -r -d "" passfile; do
      local keytoshow="${passfile%.gpg}"
      local keybasefile="${passfile%.gpg}.keybase"
      [ ! -f "$keybasefile" ] && echo "${keytoshow#$PREFIX/}"
  done < <(find "$PREFIX" -iname '*.gpg' -print0)

}

cmd_diff() {
  while read -r -d "" passfile; do
    local keytoshow="${passfile%.gpg}"
    local keybasefile="${passfile%.gpg}.keybase"
    if [[ ! -f "$keybasefile" ]]; then
      echo ${keytoshow#$PREFIX/}
    else
      local md5_gpg=$($GPG -d "${GPG_OPTS[@]}" $passfile | md5sum)
      local md5_keybase="$(keybase decrypt --force -i $keybasefile 2> /dev/null | md5sum)"
      [[ $md5_gpg != $md5_keybase ]] && echo ${keytoshow#$PREFIX/}
    fi
  done < <(find $PREFIX -iname '*.gpg' -print0)
}

case "$1" in
  help)
    cmd_help
    ;;
  version)
    cmd_version
    ;;
  init)
    shift;
    cmd_init "$@"
    ;;
  encrypt)
    shift;
    cmd_encrypt "$@"
    ;;
  encrypt-all)
    shift;
    cmd_encrypt_all
    ;;
  decrypt)
    shift;
    cmd_decrypt "$@"
    ;;
  clip)
    shift;
    cmd_clip "$@"
    ;;
  remove)
    shift;
    cmd_remove "$@"
    ;;
  remove-all)
    cmd_remove_all
    ;;
  report)
    cmd_report
    ;;
  diff)
    cmd_diff
    ;;
  *)
    cmd_help
    ;;
esac
exit 0
