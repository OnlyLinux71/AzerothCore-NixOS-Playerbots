# AzerothCore NixOS Playerbots

This repository provides a ready-to-build AzerothCore WotLK server with Playerbots and several modules, pre-configured for **NixOS**. Includes a one-shot install/update script to make building easy for other users.

## Features

## Playerbots
### modules included:
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
- mod-npc-beastmaster
- mod-npc-buffer
- mod-npc-enchanter
- mod-playerbots
- mod-reforging
### Other features included: 
- One-shot `install_playerbot.sh` script
- Build tools pre-configured for NixOS
- Modules and scripts up-to-date!!! 

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
## 1. Make the script executable:
```bash
chmod +x install_playerbot.sh

```
## 2. Run this command
```bash
./install_playerbot.sh

```

## By default, the server and tools will be installed in:

~/Desktop/azerothcore-wotlk

Change the path inside install_playerbot.sh if you want a custom location.

## Log directory setup – tell users to point the server to the created logs folder:

# Logs Folder
## The script automatically creates a logs folder for both the worldserver and authserver:

~/Desktop/azerothcore-wotlk/logs/GM

## Make sure your config files point to this folder:

## In authserver.conf:
    LogsDir = /home/<YOUR_USERNAME>/Desktop/azerothcore-wotlk/logs

## In worldserver.conf:
    LogsDir = /home/<YOUR_USERNAME>/Desktop/azerothcore-wotlk/logs

## To stay updated with this repository:
```bash
git pull

```
# Any questions feel free to reach out to me at email: tracey@onlylinux.org
