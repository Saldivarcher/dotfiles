test -z "$PROFILEREAD" && . /etc/profile || true

load_dev_env=$HOME/.local/bin/load_dev_env
if [ -e "$load_dev_env" ] ; then
  . "$HOME/.local/bin/load_dev_env"
fi

cargo=$HOME/.cargo
if [ -d "$cargo" ] ; then
  . "$HOME/.cargo/env"
fi


# The reason for explicitly setting `$SHELL` is for tmux.
case $- in
  *i*)
    # Interactive session. Try switching to fish.
    if [ -z "$FISH_VERSION" ]; then # do nothing if running under fish already
      fish= $(command -v fish)
      if [ -x "$fish" ]; then
        export SHELL="$fish"
        exec "$fish"
      fi
    else
      # Explicitly set 
      fish=$(command -v fish)
      export SHELL="$fish"
    fi
esac

if [ -e /home/users/saldivar/.nix-profile/etc/profile.d/nix.sh ]; then . /home/users/saldivar/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# This is needed for nix, it uses these certs to install packages.
export SSL_CERT_FILE=/etc/ssl/ca-bundle.pem
export NIX_SSL_CERT_FILE=/etc/ssl/ca-bundle.pem
