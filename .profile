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
