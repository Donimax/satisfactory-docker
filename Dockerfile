FROM donimax/steamcmd:v1.1.0

USER root

RUN mkdir -p /config \
    && chown steam:steam /config

COPY --chown=steam:steam init.sh /
COPY --chown=steam:steam Game.ini Engine.ini Scalability.ini run.sh /home/steam/

RUN chmod +x /init.sh /home/steam/run.sh

WORKDIR /config

ENV DEBUG="false" \
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

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep -f "FactoryGame" > /dev/null || pgrep -f "steamcmd" > /dev/null || exit 1

USER steam

ENTRYPOINT [ "/init.sh" ]
