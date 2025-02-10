alias x='exit'

alias zshrc='nvim ~/.config/zsh/.zshrc'

alias knvim='NVIM_APPNAME=kickstart nvim'

alias wezterm='flatpak run org.wezfurlong.wezterm'

if command -v exa > /dev/null 2>&1; then
    alias ls='exa --group-directories-first --icons'
    alias ll='exa -lh'
    alias la='exa -al'
    alias tree='exa -l --tree --level=2'
else
    alias ls='ls --color'
    alias ll='ls -lh'
    alias la='ll -a'
fi
