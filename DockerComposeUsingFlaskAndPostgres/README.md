#DOCKER-COMPOSE
<b><i>UNIVERSIDAD ICESI</i></b><br>
<b><i>SISTEMAS DISTRIBUIDOS</i></b><br>
<b><i>Diego E Delgado 12107019</i></b><br>

#
<li>GitHub: https://github.com/diegoedelgado/distributed_system/tree/master/DockerComposeUsingFlaskAndPostgres 
</li>

Este informe tiene como finalidad ilustrar el proceso que se llevó a cabo para realizar el aprovisionamiento automático de una aplicación web ejecutándose en el microframework Flask, la aplicación realiza una consulta por medio de una URL a la base de datos mostrando los datos que han sido almacenados en una tabla.


Se presenta entonces la arquitectura a usar en esta solución:


![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/esquema.png)


#RECOMENDACIONES:
A continuación se consignan una serie de recomendaciones propuestas directamente por la página de Docker, en las que se especifica lo que se debe tener en cuenta a la hora de aprovisionar empleando contenedores:

## 1 .Correr un solo proceso por contenedor:  
Se recomienda que se tenga un solo proceso o la menor cantidad de procesos posibles por contenedor, ya que el desacoplamiento de las aplicaciones y la escalabilidad tanto horizontal como vertical se facilita al usar un solo proceso por contenedor. En caso de necesitar que un contenedor se enlace con otro se puede usar la herramienta container linking.
## 2. Evitar la instalación de paquetes innecesarios: 
Se debe tener bien definido las paquetes necesarios para la instalación de los contenedores, al conocer bien las dependencias necesarias no se instalan paquetes que no se necesitan, lo que reduce el tamaño de los archivos y los tiempos de compilación.
## 3. Minimizar el número de capas: 
Se debe tener un balance entre la legibilidad y el mantenimiento de un Dockerfile, teniendo en cuenta las capas que le agregamos al sistema.
## 4. Organizar argumentos en varias líneas:
Se recomienda organizar de forma alfanumérica las dependencias que se vayan a instalar en un contenedor, esto nos permitirá tener cierto control y facilitar las revisiones. 
## 5. Los contenedores deben ser efímeros:
Esto hace referencia al hecho de que los contenedores deben poder ser iniciados y detenidos en cualquier momento que se necesite.
## 6. Archivo .dockerignore:
Se recomienda que la ubicación en la que esté el Dockerfile no contenga otro tipo de archivos, es decir el directorio solo tenga los archivos necesarios para que se compile el contenedor. En caso de  no ser posible que el Dockerfile se encuentre en una locación vacía se recomienda crear un archivo de extensión .dockerignore para que ignore los demás archivos y directorios en el que se encuentra el Dockerfile


#PROCESO
Para la realización de este proyecto se usarán dos contenedores, el primero un contenedor con el microframework flask, en el cual se encuentra el servicio web que realizará las consultas al otro contenedor postgres, que funciona como motor de base de datos PostgreSQL. 


## 1. Clonar Repositorio
```
$ git clone https://github.com/diegoedelgado/distributed_system/tree/master/DockerComposeUsingFlaskAndPostgres
```

Este proyecto se ha realizado sobre un ambiente Windows 10, x64 con la siguiente versión de Docker:

![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/dockerversion.PNG)


Contenedor Flask para servicio Web
A continuación se muestra la estructura de archivos necesaria para el aprovisionamiento del contenedor con el microframework Flask.

![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/DockerFlask.PNG)


En esta carpeta flaskApp encontramos los archivos necesarios para el aprovisionamiento de este contenedor, iniciamos entonces explicando el contenido de los archivos:

###Dockerfile
![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/DockerFlask1.PNG)

Se puede observar que se realiza la instalación inicial de las dependencias del contenedor como lo son python, pip en su versión más reciente, posterior a esto se procede a la instalación de las dependencias necesarias para la comunicación con la base de datos instalando python-psycopg2, luego de esto se carga el archivo con el resto de dependencias ubicado en el archivo requirements.txt. Finalmente se exponen los puertos 80 y 5000 para el posible consumo del servicio vía web.


###Requirements.txt
![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/DockerFlask2.PNG)


Este archivo contiene una lista de las dependencias del sistema necesarias para realizar el aprovisionamiento del contenedor con flask. Dentro de estas las más relevantes son psycopg2, flask, flask-SQLAlchemy y SQLAlchemy, dependencias que permitirán la comunicación con la base de datos.


###Server.py
![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/server.PNG)

Este script de python es quien permite la comunicación con la base de datos, inicialmente se encarga de levantar el servicio de consulta de la base de datos y luego de realizar la consulta. Para nuestro caso realiza la consulta sobre la dirección IP principal sobre la que corre docker en Windows 192.168.99.100 sobre el puerto 5432 definido como el de consulta a la base de datos. Se define el puerto 5000 como el puerto de escucha del servicio Web.
Adicional a esto se define el proceso de consulta, para nuestro caso se ha definido un esquema REST, en el cual si se desea conocer la información almacenada en la base de datos se debe cargar la información de la siguiente forma:
	-http://192.168.99.100:5000 : Si se desea conocer la información almancenada en la base de datos.
	-http://192.168.99.100:5000/prueba : Si se desea agregar la frase “Funciona!” de forma estática a la base de datos.
	-http://192.168.99.100:5000/____: Con cualquier otra combinación de palabra sobre la linea está será agregada directamente a la base de datos.


###data.html
![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/DockerFlask3.PNG)

Este script en html es consumido dentro del script server.py y permite listar la información guardada en la base de datos.


Finalmente se debe construir la imagen con la configuración del Dockerfile de la siguiente forma:
```
$ cd flaskBaseImage
$ docker build -t flask .
```
De esta forma se inicia el proceso de construcción de la imagen:

![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/DockerFlask4.PNG)


## 2. Contenedor Postgres para base de datos
Para el proceso de aprovisionamiento del contenedor donde se encuentra la base de datos tenemos el siguiente Dockerfile:

### Dockerfile
![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/DockerPostgres.PNG)

Como se puede observar en este Dockerfile se instalan todas las dependencias necesarias para el funcionamiento de la base de datos con el motor PostgreSQL, se define un usuario postgres sobre el cual se corren los procesos de configuración de acceso a la base de datos, en la parte final se determinan los puertos a Exponer serán el 5432, pues es por el cual recibirá la consulta desde el contenedor flask.
Finalmente se realiza la construcción de la imagen:
```
$ cd postgresBaseImage
$ docker build -t postgres .
```
![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/DockerPostgres2.PNG)

## 3. Aprovisionamiento usando Docker-compose
Una vez definidas las imágenes para los contenedores que servirán como servicio web y base de datos, flask y postgres respectivamente procedemos a realizar el aprovisionamiento completo para este proyecto por medio de un docker-compose.yml, este archivo se describe a continuación:

### Docker-compose.yml
![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/dockercompose.PNG)

Se forma muy sencilla se define que tenemos dos contenedores, flask en su versión más reciente y postgres en su versión más reciente. Se define que se usarán los puertos 5000:5000 tanto para el anfitrión como para el uso interno del contenedor flask y en el caso de postgres serán los puertos 5432:5432 respectivamente. En este caso se debe tener en cuenta que al levantar estas dos máquinas de esta forma, sin especificar su dirección IP, el levantará el proceso sobre la dirección 0.0.0.0 siendo la misma dirección IP del anfitrión, para nuestro caso será la dirección IP 192.168.99.100 como se especifico anteriormente. 
Dentro de los errores más comunes que ocurren en esta etapa están relacionados con la selección de puertos que están siendo usados por el host anfitrión, para esto se recomienda usar herramientas como nmap o netstat -a en el caso de windows para saber qué procesos están corriendo y en qué puertos y así escoger otros libres. 

Finalmente tenemos el despliegue de la aplicación funcionando, recomendamos el uso de Google Chrome como navegador para esta prueba:
```
$ docker-compose up .
```
![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/dockercompose1.PNG)

![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/dockercompose2.PNG)

Como podemos observar al cargar por primera vez no tenemos datos agregados.

![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/dockercompose3.PNG)


Se ejecuta el Script prueba el cual debe agregar la palabra Funciona! como lo hace correctamente.

![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/dockercompose4.PNG)


Agregamos la palabra Gracias a la base de datos.

![alt tag] (https://github.com/diegoedelgado/distributed_system/blob/master/DockerComposeUsingFlaskAndPostgres/images/dockercompose5.PNG)

Finalmente tenemos la lista de datos almacenados en la base de datos mostrada de forma correcta.
