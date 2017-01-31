#!/usr/bin/env bash

set -e

usage() {
  cat >&2 <<EOF

usage: $(basename "$0") <args>
  $(basename "$0") backs up documents to the desired SMB remote path.

args:
  --mountdir, -m <mountdir>  Path to mount buffalo to.
  --password, -p <password>  Password for specified user to mount drive.
  --user, -u [user]  Optional username to mount as. Defaults to 'admin'.
  --remote, -r [remote]  Remote path to mount to local disk.
EOF
}

parse_args() {
  while :; do
    case $1 in
      -h|--help)
        usage
        exit
        ;;
      -m|--mountdir)
        if [ -n "$2" ]; then
          MOUNTDIR=$2
          shift
          shift
        else
          echo -e "ERROR: '--mountdir' requires a non-empty string argument" >&2
          usage
          exit 1
        fi
        ;;
      -u|--user)
        if [ -n "$2" ]; then
          USER=$2
          shift
          shift
        else
          USER="admin"
        fi
        ;;
      -p|--password)
        if [ -n "$2" ]; then
          PASSWORD=$2
          shift
          shift
        else
          echo -e "ERROR: '--password' requires a non-empty string argument" >&2
          usage
          exit 1
        fi
        ;;
      *)
        if [ -n "$MOUNTDIR" ] && [ -n "$PASSWORD" ]; then
          break
        else
          echo -e "ERROR: specify '--mountdir' and '--password' args" >&2
          usage
          exit 1
        fi
        ;;
    esac
  done
}

main() {

  parse_args "$@"

  if [ ! -d "$MOUNTDIR" ]; then
    mkdir -p "$MOUNTDIR"
  fi

  ALREADY_MOUNTED=$(mount | grep buffalo/backup_drive)

  mount -t smbfs //"$USER":"$PASSWORD"@buffalo/backup_drive "$MOUNTDIR"

}

main "$@"
