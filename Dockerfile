FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 \
    imagemagick \
    curl \
    procps \
    net-tools \
    vim \
    tree \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/fotosocial/{fotos,albums,usuarios,thumbnails,publicacoes,logs,backups} \
    && mkdir -p /app/scripts \
    && mkdir -p /app/source \
    && mkdir -p /var/log/fotosocial

COPY scripts/ /app/scripts/
COPY source/ /app/source/
COPY source/ /var/www/html/

RUN chmod +x /app/scripts/*.sh

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]