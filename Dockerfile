FROM ubuntu:16.04

# install baseline OS requirements and PPA for Python3.6
RUN apt-get -y update \
	&& apt-get install -y --no-install-recommends apt-utils software-properties-common vim nano wget \
	&& add-apt-repository ppa:jonathonf/python-3.6

# install Python 3.6
RUN apt-get update -y \
	&& apt-get install -y build-essential python3.6 python3-pip

# add PPA for PostgreSQL
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  apt-key add -

# install PostgreSQL 10 and wal-e dependencies
RUN apt-get -y update \
	&& apt-get install -y curl lzop pv libpq5 postgresql-common postgresql-client-10 cron \
     	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# upgrade pip
RUN python3 -m pip install --upgrade pip

# install wal-e requirements
COPY requirements.txt ./
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# finalize container with TimescaleDB + WAL-E scripts
COPY src/wale-rest.py .
COPY start.sh .
COPY backup_push.sh .
RUN chmod +x backup_push.sh

EXPOSE 5000
CMD [ "bash", "./start.sh" ]
#ENTRYPOINT ["tail", "-f", "/dev/null"]
