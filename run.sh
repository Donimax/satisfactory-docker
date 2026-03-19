#!/bin/bash

set -e

NUMCHECK='^[0-9]+$'

if ! [[ "$MAXPLAYERS" =~ $NUMCHECK ]] ; then
    printf "Invalid max players given: ${MAXPLAYERS}\\n"
    MAXPLAYERS="16"
fi

printf "Setting max players to ${MAXPLAYERS}\\n"
sed -i "s/MaxPlayers=.*/MaxPlayers=${MAXPLAYERS}/" "/home/steam/Game.ini"

if [[ "$SKIPUPDATE" == "false" ]]; then
    if [[ "$STEAMBETA" == "true" ]]; then
        printf "Experimental flag is set. Experimental will be downloaded instead of Early Access.\\n"
        STEAMBETAFLAG="-beta experimental"
    fi

    space=$(df -BG . | awk 'NR==2 {gsub(/G/,"",$4); print $4}')
    printf "Checking available space...${space}GB detected\\n"

    if [[ "$space" -lt 5 ]]; then
        printf "You have less than 5GB (${space}GB detected) of available space to download the game.\\nIf this is a fresh install, it will probably fail.\\n"
    fi

    printf "Downloading the latest version of the game...\\n"

    /home/steam/steamcmd/steamcmd.sh +force_install_dir /config/gamefiles +login anonymous +app_update $STEAMAPPID ${STEAMBETAFLAG:+$STEAMBETAFLAG} +quit
else
    printf "Skipping update as flag is set\\n"
fi

cp -a /config/saves/. /config/backups/
cp -a "${GAMESAVESDIR}/server/." /config/backups/ # useless in first run, but useful in additional runs
rm -rf "${GAMESAVESDIR}/server"
ln -sf /config/saves "${GAMESAVESDIR}/server"
ln -sf /config/ServerSettings.15777 "${GAMESAVESDIR}/ServerSettings.15777"

cp /home/steam/{Engine.ini,Game.ini,Scalability.ini} "${GAMECONFIGDIR}/Config/LinuxServer"

# Check game binary file
BINARY_DIR="/config/gamefiles/Engine/Binaries/Linux"
if [ -f "${BINARY_DIR}/UnrealServer-Linux-Shipping" ]; then
    GAMEBINARY="UnrealServer-Linux-Shipping"
elif [ -f "${BINARY_DIR}/UE4Server-Linux-Shipping" ]; then
    GAMEBINARY="UE4Server-Linux-Shipping"
elif [ -f "${BINARY_DIR}/FactoryServer-Linux-Shipping" ]; then
    GAMEBINARY="FactoryServer-Linux-Shipping"
else
    printf "Game binary is missing.\\n"
    exit 1
fi

printf "Using %s binary\\n" "${GAMEBINARY}"

cd /config/gamefiles || exit 1

Engine/Binaries/Linux/$GAMEBINARY FactoryGame -log -NoSteamClient -unattended ?listen -Port=$SERVERGAMEPORT -BeaconPort=$SERVERBEACONPORT -ServerQueryPort=$SERVERQUERYPORT -multihome=$SERVERIP
