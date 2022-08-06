if status is-interactive
    # Commands to run in interactive sessions can go here
    source $HOME/.config/fish/alias.fish
    set -x PATH "/cray/css/compiler/cost/testing/bin" $PATH
end
