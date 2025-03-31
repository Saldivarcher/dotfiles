source $HOME/.config/fish/alias.fish

set -x PATH "$HOME/.local/bin" $PATH
set -x PATH "$HOME/bin" $PATH
set -x PATH "$HOME/.local/share/junest/bin" $PATH

set current_hostname (hostname)
if  string match -q "*pinoak*" $current_hostname
    set -x PATH "$HOME/css/opt/x86/nvim-root/usr/bin/" $PATH
end

set fish_greeting ''

switch (uname)
    case Linux
        set -x PATH "/hpcdc/project/compiler/cost/testing/bin/" $PATH
    case Darwin
        set -x PATH "/Users/migsaldivar/Library/Python/3.9/bin" $PATH
        set -x PATH "/Users/migsaldivar/Library/Python/3.11/bin" $PATH
end

switch (uname -m)
    case aarch64
        set -x NIX '/cray/css/users/saldivar/opt/aarch64/nix' 
    case x86_64
        set -x NIX '/cray/css/users/saldivar/opt/x86/nix'
end

set -x NIX_STORE $NIX/store
set -x NIX_DATA_DIR $HOME/.local/share

set -g async_prompt_functions _pure_prompt_git  # run this async! dope.
# I don't need a prompt symbol for you-got-things-in-yr-stash
set --erase pure_symbol_git_stash

# Readline colors
set -g fish_color_autosuggestion 555 yellow
set -g fish_color_command 5f87d7
set -g fish_color_comment 808080
set -g fish_color_cwd 87af5f
set -g fish_color_cwd_root 5f0000
set -g fish_color_error 870000 --bold
set -g fish_color_escape af5f5f
set -g fish_color_history_current 87afd7
set -g fish_color_host 5f87af
set -g fish_color_match d7d7d7 --background=303030
set -g fish_color_normal normal
set -g fish_color_operator d7d7d7
set -g fish_color_param 5f87af
set -g fish_color_quote d7af5f
set -g fish_color_redirection normal
set -g fish_color_search_match --background=purple
set -g fish_color_status 5f0000
set -g fish_color_user 5f875f
set -g fish_color_valid_path --underline

set -g fish_color_dimmed 555
set -g fish_color_separator 999

# Git prompt status
set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_showupstream auto
set -g pure_git_untracked_dirty false

# Status Chars
#set __fish_git_prompt_char_dirtystate '*'
set __fish_git_prompt_char_upstream_equal ''
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'
set __fish_git_prompt_color_ranch yellow
set __fish_git_prompt_color_dirtystate 'red'

set __fish_git_prompt_color_upstream_ahead ffb90f
set __fish_git_prompt_color_upstream_behind blue

set -gx PATH "$HOME/.cargo/bin" $PATH
