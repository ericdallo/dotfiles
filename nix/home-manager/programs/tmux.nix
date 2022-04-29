{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        {
            plugin = dracula;
            extraConfig = ''
                set -g @dracula-show-fahrenheit false
                set -g @dracula-show-weather false
                set -g @dracula-show-battery false
                set -g @dracula-show-powerline true
                set -g @dracula-show-left-icon smiley
            '';
        }
     ];

    extraConfig = ''
        # Dracula Color Pallette
        white='#f8f8f2'
        gray='#44475a'
        dark_gray='#282a36'
        light_purple='#bd93f9'
        dark_purple='#6272a4'
        cyan='#8be9fd'
        green='#50fa7b'
        orange='#ffb86c'
        red='#ff5555'
        pink='#ff79c6'
        yellow='#f1fa8c'

        bind-key -n M-x kill-pane
        bind-key -n M-c new-window
        bind -n M-Right next-window
        bind -n M-Left previous-window
        bind-key -n M-h split-window -h
        bind-key -n M-v split-window -v
        bind-key -n M-o select-pane -t :.+
        bind-key M-a last-window
        bind-key -n F10 resize-pane -Z
        bind-key m set-option -g mouse on \; display 'Mouse: ON'
        bind-key M set-option -g mouse off \; display 'Mouse: OFF'
        bind-key -n C-Left select-pane -L
        bind-key -n C-Right select-pane -R
        bind-key -n C-Up select-pane -U
        bind-key -n C-Down select-pane -D
        bind-key -n C-S-Left resize-pane -L
        bind-key -n C-S-Right resize-pane -R
        bind-key -n M-y copy-mode
        bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -selection c"
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "xclip -in -selection clipboard"

        set -s escape-time 0
        set-option -g allow-rename off
        set-option -g mouse on
        set -g history-limit 20000
        setw -g mode-keys vi
        set-option -g status-interval 3
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{b:pane_current_path}'

        set-window-option -g window-status-current-format "#[fg=$gray,bg=$dark_purple]$left_sep#[fg=$white,bg=$dark_purple] #W$current_flags #[fg=$dark_purple,bg=$gray]$left_sep"
        set-window-option -g window-status-format "#[fg=$white]#[bg=$gray] #W$flags"
    '';
  };
}
