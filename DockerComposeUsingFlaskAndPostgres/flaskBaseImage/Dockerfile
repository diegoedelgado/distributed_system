FROM ubuntu
MAINTAINER Diego Delgado <diego.e.delgado@ieee.org>
#Instalacion python y pip
USER root
RUN apt-get update && apt-get install -y python python-pip python-dev libpq-dev
#Actualizacion de pip a la version mas reciente
RUN pip install --upgrade pip
#Instalando dependencias para la conexion con la base de datos en postgres
RUN apt-get install python-psycopg2 -y
ADD flaskApp /flaskApp
WORKDIR /flaskApp
#Instalacion de las dependencias del contenedor
RUN pip install -r requirements.txt
EXPOSE 80
EXPOSE 5000
CMD python server.py
