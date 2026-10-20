#! /usr/bin/env nix-shell
#! nix-shell -I "nixpkgs=channel:nixpkgs-unstable" -i "make -f" -p gnumake nixUnstable findutils nixpkgs-fmt

.PHONY: build-% activate clean update update-and-commit
NIX_FLAGS := --experimental-features 'nix-command flakes'

clean:
	rm -rf result

update:
	nix $(NIX_FLAGS) flake update

update-and-commit:
	nix $(NIX_FLAGS) flake update --commit-lock-file

activate:
ifeq (,$(wildcard ./result/activate))
	@>&2 echo "Nothing to activate. Run 'make build-<hostname>' first!"
	@exit 1
endif
	./result/activate

# Like nixos-rebuild switch: a new generation of the system profile (the boot
# menu lists those; systemd-boot boots nothing else), the next boot and the
# running system. Booted into a specialisation (/etc/specialisation names it,
# like grog), it stays in it; the boot menu still comes from the system itself.
switch:
	nix-env -p /nix/var/nix/profiles/system --set "$$(readlink -f result)"
	./result/bin/switch-to-configuration boot
	./result$(if $(wildcard /etc/specialisation),/specialisation/$(shell cat /etc/specialisation))/bin/switch-to-configuration test

build-%:
	nix $(NIX_FLAGS) build '.#nixosConfigurations.$*.config.system.build.toplevel'

build-vm-%:
	nix $(NIX_FLAGS) build '.#nixosConfigurations.$*.config.system.build.vm'

run-vm-%: build-vm-%
	QEMU_OPTS="-cpu host -smp 2 -m 4096M -machine type=q35,accel=kvm" ./result/bin/run-$*-vm

# Local Variables:
# mode: Makefile
# End:
