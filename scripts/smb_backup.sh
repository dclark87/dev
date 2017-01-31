#!/usr/bin/env bash

set -e

usage() {
  cat >&2 <<EOF

usage: $(basename "$0") <args>
  $(basename "$0") backs up documents to the desired SMB remote path.

args:
  --remotedir, -r <remotedir>  Remote directory path to mount.
  --localdir, -l <localdir>  Local directory to mount to.
  --user, -u <user>  Username to mount as.
  --password, -p <password>  Password for specified user to mount drive.
EOF
}

parse_args() {
  while :; do
    case $1 in
      -h|--help)
        usage
        exit
        ;;
      -r|--remotedir)
        if [ -n "$2" ]; then
          REMOTEDIR=$2
          shift
          shift
        else
          echo -e "ERROR: '--remotedir' requires a non-empty string argument" >&2
          usage
          exit 1
        fi
        ;;
      -l|--localdir)
        if [ -n "$2" ]; then
          LOCALDIR=$2
          shift
          shift
        else
          echo -e "ERROR: '--localdir' requires a non-empty string argument" >&2
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
          echo -e "ERROR: '--user' requires a non-empty string argument" >&2
          usage
          exit 1
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
        if [ -n "$REMOTEDIR" ] && [ -n "$LOCALDIR" ] && [ -n "$USER" ] && [ -n "$PASSWORD" ]; then
          break
        else
          echo -e "ERROR: specify '--remotedir', '--localdir', '--user', and '--password' args" >&2
          usage
          exit 1
        fi
        ;;
    esac
  done
}

main() {

  parse_args "$@"

  # Make local directory if it does not exist.
  if [ ! -d "$LOCALDIR" ]; then
    mkdir -p "$LOCALDIR"
  fi

  # If the drive already is not mounted, mount it.
  mounted=$(mount | grep "$REMOTEDIR")
  if [ -z "mounted" ]; then
    echo "Mounting remote...\n"
    mount -t smbfs //"$USER":"$PASSWORD"@"$REMOTEDIR" "$LOCALDIR"
  fi

}

main "$@"
