FROM amneziavpn/amneziawg-go:latest

LABEL maintainer="AmneziaVPN"

#Install required packages
RUN apk add --no-cache curl dumb-init sudo ipcalc
RUN apk --update upgrade --no-cache

COPY ./amnezia /opt/amnezia
RUN chmod a+x /opt/amnezia/*.sh

ENTRYPOINT [ "dumb-init", "/opt/amnezia/start.sh" ]
CMD [ "" ]
