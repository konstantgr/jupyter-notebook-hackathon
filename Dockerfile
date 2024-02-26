#Specify the base image
FROM ubuntu:20.04

#Install required packages
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl
RUN apt-get install -y gcc
RUN apt-get install -y python3-dev
RUN apt-get install -y git
RUN apt-get install python3-dev


#Install python 3.10 and python3.10-dev
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.10 python3.10-dev

#Upgrade pip
RUN cd /usr/local/bin && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3.10 get-pip.py && \
    rm get-pip.py

#Set working directory in the container
WORKDIR /app

#Copy all the files from your source project to /app directory
COPY requirements.txt /app

RUN python3.10 -m pip install -r requirements.txt
RUN jupyter nbextension install --py mining_extension --user
RUN jupyter nbextension enable --py mining_extension --user

#Set environment variables used by the jupyter
ENV IP=0.0.0.0
ENV PORT=8888

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--NotebookApp.token=''", "--NotebookApp.notebook_dir=/app", "--allow-root"]

