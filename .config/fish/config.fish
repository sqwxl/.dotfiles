set -gx EDITOR /usr/bin/nvim
set -gx VISUAL /usr/bin/nvim
set -gx MANPAGER '/usr/bin/nvim +Man!'

abbr -ag n nvim
abbr -ag s sudo
abbr -ag se sudoedit

abbr -ag o xdg-open

# alias docker podman
abbr -ag dc docker-compose

abbr -ag g git
abbr -ag ga 'git add'
abbr -ag gaa 'git add .'
abbr -ag gs 'git status'
abbr -ag gc 'git commit'
abbr -ag gca 'git commit -a'
abbr -ag gcam 'git commit -a -m'
abbr -ag gp 'git push'
abbr -ag gpf 'git push -f'
abbr -ag grv 'git remote -v'

abbr -ag cfgsway 'cd ~/.config/sway && nvim config'
abbr -ag cfgvim 'cd ~/.config/nvim && nvim lua/plugins.lua'
abbr -ag cfgfish 'cd ~/.config/fish && nvim config.fish'
abbr -ag cfgterm 'cd ~/.config/kitty && nvim kitty.conf'
# abbr -ag cfgtmux 'nvim ~/.tmux.conf'
# abbr -ag cfgterm 'nvim ~/.alacritty.yml'
abbr -ag cfgterm 'nvim ~/.config/kitty/kitty.conf'

abbr -ag rmr 'rm -rf'

# config abbr for dotfiles
alias cfg "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

abbr -ag myip "curl -4 icanhazip.com"

if type -q bat
  alias cat bat
end

if type -q exa
  abbr -ag l 'exa'
  abbr -ag ll 'exa -l'
  abbr -ag lll 'exa -la'
  alias ls exa
else if type -q lsd
  abbr -ag l 'lsd'
  abbr -ag ll 'lsd -l'
  abbr -ag lll 'lsd -lah'
  alias ls lsd
else
  abbr -ag l 'ls'
  abbr -ag ll 'ls -l'
  abbr -ag lll 'ls -lah'
end

if type -q rg
  set -gx FZF_DEFAULT_COMMAND rg --files
  set -gx FZF_DEFAULT_OPTS -m
end

if type -q go
  fish_add_path (go env GOPATH)/bin
end

fish_add_path $HOME/.local/bin

if type -q node
  fish_add_path $HOME/.npm-global/bin
end

if type -q rustup
  fish_add_path $HOME/.cargo/bin
end

if type -q fdfind
  alias fd fdfind
end

# if not type -q fisher
#   curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
#   fisher update
# end

# set -gx ANDROID_SDK $HOME/Android/Sdk
# set -gx ANDROID_HOME $HOME/Android/Sdk

# fish_add_path $ANDROID_HOME/emulator
# fish_add_path $ANDROID_HOME/tools
# fish_add_path $ANDROID_HOME/tools/bin
# fish_add_path $ANDROID_HOME/platform-tools

# direnv hook fish | source

if type -q zoxide
  zoxide init fish | source
end

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

complete -c cht.sh -xa '(curl -s cht.sh/:list)'
