source $HOME/.config/fish/alias.fish
set -x PATH "$HOME/.local/bin" $PATH
set -x PATH "$HOME/bin" $PATH

set fish_greeting ''

switch (uname)
    case Linux
        set -x PATH "/cray/css/compiler/cost/testing/bin" $PATH
    case Darwin
        set -x PATH "/Users/migsaldivar/Library/Python/3.9/bin" $PATH
end

