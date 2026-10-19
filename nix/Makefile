#! /usr/bin/env nix-shell
#! nix-shell -I "nixpkgs=channel:nixpkgs-unstable" -i "make -f" -p gnumake nixUnstable findutils nixpkgs-fmt

.PHONY: build-% activate clean iso update update-and-commit usb
NIX_FLAGS := --experimental-features 'nix-command flakes'

clean:
	rm -rf result iso-result

update:
	nix $(NIX_FLAGS) flake update

update-and-commit:
	nix $(NIX_FLAGS) flake update --commit-lock-file

# Installing a new machine: see README.md. `make iso` builds the installer
# (hosts/installer), `make usb DEVICE=/dev/sdX` writes it to a USB stick.
iso:
	nix $(NIX_FLAGS) build '.#nixosConfigurations.installer.config.system.build.isoImage' --out-link iso-result
	@ls -lh iso-result/iso/*.iso

usb:
	@test -n "$(DEVICE)" || { >&2 echo "usage: make usb DEVICE=/dev/sdX (the stick, see lsblk)"; exit 1; }
	@test "$$(lsblk -dno TRAN $(DEVICE) 2>/dev/null)" = usb || { >&2 echo "$(DEVICE) isn't a USB disk, refusing."; lsblk -do NAME,SIZE,TRAN,MODEL; exit 1; }
	@test -n "$(wildcard iso-result/iso/*.iso)" || { >&2 echo "No ISO: run 'make iso' first."; exit 1; }
	@lsblk -o NAME,SIZE,MODEL,LABEL $(DEVICE)
	@read -p "Erase $(DEVICE) and write $(notdir $(wildcard iso-result/iso/*.iso)) to it? [y/N] " a && [ "$$a" = y ]
	sudo dd if=$(wildcard iso-result/iso/*.iso) of=$(DEVICE) bs=4M status=progress oflag=sync conv=fsync

activate:
ifeq (,$(wildcard ./result/activate))
	@>&2 echo "Nothing to activate. Run 'make build-<hostname>' first!"
	@exit 1
endif
	./result/activate

# Booted into a specialisation (/etc/specialisation names it, like grog), it
# stays in it; the boot menu still comes from the system itself.
switch:
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
