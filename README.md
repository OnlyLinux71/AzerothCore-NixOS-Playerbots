# AzerothCore NixOS Playerbots

This repository provides a ready-to-build AzerothCore WotLK server with Playerbots and several modules, pre-configured for **NixOS**. Includes a one-shot install/update script to make building easy for other users.

## Features

## - Playerbots
## modules included:
- mod-ah-bot
- mod-aoe-loot
- mod-arac
- mod-assistant
- mod-congrats-on-level
- mod-duel-reset
- mod-fly-anywhere
- mod-item-level-up
- mod-learn-spells
- mod-money-for-kills
- mod-npc-beastmaaster
- mod-npc-buffer
- mod-npc-enchanter
- mod-playerbots
- mod-reforging
- One-shot `install_playerbot.sh` script
- Build tools pre-configured for NixOS
- Modules and scripts up-to-date with the Playerbot fork

 ## Clone the repository:
```bash
git clone git@github.com:OnlyLinux71/AzerothCore-NixOS-Playerbots.git
cd ~/AzerothCore-NixOS-Playerbots

``` 

## Requirements

## Run on **NixOS** with the following packages:

```bash
nix-shell -p cmake ninja gcc openssl boost zlib bzip2 mariadb pkg-config readline clang

```

## Installation / Build
## From the repository root:
```bash
./install_playerbot.sh
```
## By default, the server and tools will be installed in:

~/Desktop/azerothcore-wotlk

## Change the path inside install_playerbot.sh if you want a custom location.

## Keeping Updated
## To stay updated with this repository:
```bash
git pull

```
Any questions feel free to reach out to me at email: tracey@onlylinux.org
