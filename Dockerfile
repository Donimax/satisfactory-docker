FROM steamcmd:0.1

RUN mkdir -p /config \
    && chown steam:steam /config

COPY --chown=steam:steam init.sh /

COPY --chown=steam:steam Game.ini Engine.ini Scalability.ini run.sh /home/steam/

WORKDIR /config

ENV DEBUG="false" \
    USER=steam \
    PGID="1000" \
    PUID="1000" \
    GAMECONFIGDIR="/config/gamefiles/FactoryGame/Saved" \
    GAMESAVESDIR="/home/steam/.config/Epic/FactoryGame/Saved/SaveGames" \
    MAXPLAYERS="16" \
    SERVERBEACONPORT="15000" \
    SERVERGAMEPORT="7777" \
    SERVERIP="0.0.0.0" \
    SERVERQUERYPORT="15777" \
    SKIPUPDATE="false" \
    STEAMAPPID="1690800" \
    STEAMBETA="false"

EXPOSE 7777/udp 15000/udp 15777/udp

# Switch to user
USER ${USER}

ENTRYPOINT [ "/init.sh" ]
