#! /usr/bin/env nix-shell
#! nix-shell -I "nixpkgs=channel:nixpkgs-unstable" -i "make -f" -p gnumake nixUnstable findutils nixpkgs-fmt

.PHONY: build-% install activate clean
NIX_FLAGS := --experimental-features 'nix-command flakes'

all: build-gregnix-personal build-gregnix-nubank build-gregnix-ssd

clean:
	rm -rf result

update:
	nix $(NIX_FLAGS) flake update

update-and-commit:
	nix $(NIX_FLAGS) flake update --commit-lock-file

install:
ifeq (,$(wildcard ./result/nixos-version))
	@>&2 echo "Nothing to install. Run 'make build-<hostname>' first!"
	@exit 1
endif
	nixos-install --system ./result

activate:
ifeq (,$(wildcard ./result/activate))
	@>&2 echo "Nothing to activate. Run 'make build-<hostname>' first!"
	@exit 1
endif
	./result/activate

switch:
	./result/bin/switch-to-configuration switch

build-%:
	nix $(NIX_FLAGS) build '.#nixosConfigurations.$*.config.system.build.toplevel'

build-vm-%:
	nix $(NIX_FLAGS) build '.#nixosConfigurations.$*.config.system.build.vm'

run-vm-%: build-vm-%
	QEMU_OPTS="-cpu host -smp 2 -m 4096M -machine type=q35,accel=kvm" ./result/bin/run-$*-vm

# Local Variables:
# mode: Makefile
# End:
