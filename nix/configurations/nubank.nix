# nucli (`nu`) for the whole graphical session, not only interactive zsh.
#
# ~/.nurc and ~/.extra (.nubank_extra) set these too, but only .zshrc sources
# them. Hyprland starts from SDDM, so anything it launches (Super+E's
# `doom run`, rofi) had no `nu` in PATH and no NU_HOME. Then ECA's
# `${cmd:nu genai ai-gateway token}` failed (nucli runs with `set -u`:
# "NU_HOME: unbound variable"), leaving the nubank providers without
# credentials. sessionVariables go to PAM (SDDM/Hyprland), /etc/set-environment
# (shells) and environment.d (systemd user services, e.g. emacs.service).
{ ... }:

{
  environment.sessionVariables = {
    NU_HOME = "$HOME/dev/nu";
    NUCLI_HOME = "$HOME/dev/nu/nucli";
    PATH = [ "$HOME/dev/nu/nucli" ];
  };
}
