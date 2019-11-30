FROM balenalib/raspberrypi3

RUN [ "cross-build-start" ]

#labeling
LABEL maintainer="lemariva@gmail.com" \
      version="V1.0.1" \
      description="Raspbian(stretch) with cups"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  vim \
  locales \
  whois \
  cups \
  cups-client \
  cups-bsd \
  printer-driver-all \
  printer-driver-gutenprint \
  hpijs-ppds \
  hp-ppd  \
  hplip \
  printer-driver-foo2zjs

#RUN sed -i "s/^#\ \+\(en_US.UTF-8\)/\1/" /etc/locale.gen \
#  && locale-gen en_US en_US.UTF-8

ENV LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  LANGUAGE=en_US:en

RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
  && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /var/lib/apt/lists/partial


COPY etc-cups/cupsd.conf /etc/cups/cupsd.conf

EXPOSE 631

ENTRYPOINT ["/usr/sbin/cupsd", "-f"]

RUN [ "cross-build-end" ]