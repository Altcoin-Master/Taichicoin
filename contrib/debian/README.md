
Debian
====================
This directory contains files used to package taichicoind/taichicoin-qt
for Debian-based Linux systems. If you compile taichicoind/taichicoin-qt yourself, there are some useful files here.

## taichicoin: URI support ##


taichicoin-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install taichicoin-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your taichicoin-qt binary to `/usr/bin`
and the `../../share/pixmaps/taichicoin128.png` to `/usr/share/pixmaps`

taichicoin-qt.protocol (KDE)

