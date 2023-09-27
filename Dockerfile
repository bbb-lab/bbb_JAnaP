#Ubuntu version placeholder

ARG UBUNTU_VERSION=18.04

FROM Ubuntu:$(UBUNTU_VERSION)

LABEL maintainer="Chloe Kaplan"

#Can not run apt-get install and upgrade to get latest versions cuz deprecated python. 
#apt-get clean + rm -rf var capabilities makes it lighter
RUN apt-get update && \
    apt-get install -y python2.7 python-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#Create directory structure for the application
RUN mkdir -p /app/bin/packages

#Gather JAnaP from the og babes and place in packages folder
RUN wget -P /app/bin/packages https://s3.amazonaws.com/umd-cells/packages/ij150-linux64-java8.zip && \
    unzip /app/bin/packages/ij150-linux64-java8.zip -d /app/bin/packages

#Gather requirements.txt for pip installs
COPY bin/requirements.txt .
RUN pip install -r requirements.txt /app/tmp/requirements.txt && \
    rm -f /app/tmp/requirements.txt


#Documentation keep
COPY "JAnaP User Guide_v1.2_190625.pdf" /app/

#Jupyter notebook step
RUN jupyter nbextension enable --py widgetsnbextension

#Establish working directory
WORKDIR /JAnaP/web

#Run initialize script
CMD ["python", "application.py"]