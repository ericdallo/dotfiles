set -v

if [ -z "$*" ]; then
    echo "First arg must be the path of the host.nix file";
    exit 1
fi

sudo ln -sf $1 /etc/nixos/host.nix
sudo ln -sf ~/dev/dotfiles/nix/configurations /etc/nixos/configurations
sudo ln -sf ~/dev/dotfiles/nix/configuration.nix /etc/nixos/configuration.nix
sudo ln -sf ~/dev/dotfiles/nix/home.nix ~/.config/nixpkgs/home.nix

echo "Links created successfully"
