FROM python:3.6-stretch

RUN apt-get update && apt-get install curl lzop pv postgresql-client-10 cron -y \
     && rm -rf /var/lib/apt/lists/*

ADD https://bootstrap.pypa.io/get-pip.py .
RUN python3 get-pip.py

WORKDIR /usr/src/app
        
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY src/wale-rest.py .
COPY start.sh .
COPY backup_push.sh .
RUN chmod +x backup_push.sh

CMD [ "bash", "./start.sh" ]
