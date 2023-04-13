source $HOME/.config/fish/alias.fish
set -x PATH "$HOME/.local/bin" $PATH
set -x PATH "$HOME/bin" $PATH
set -x PATH "$HOME/.local/share/junest/bin" $PATH

set fish_greeting ''

switch (uname)
    case Linux
        set -x PATH "/cray/css/compiler/cost/testing/bin" $PATH
    case Darwin
        set -x PATH "/Users/migsaldivar/Library/Python/3.9/bin" $PATH
end

switch (uname -m)
    case aarch64
        set -x NIX '/cray/css/users/saldivar/opt/aarch64/nix' 
    case x86_64
        set -x NIX '/cray/css/users/saldivar/opt/x86/nix'
end
