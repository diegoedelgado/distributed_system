Sistemas Distribuidos
Informe del Parcial 1
Diego E Delgado 
https://github.com/diegoedelgado/distributed_system/tree/master/Vagrant/Flask_Postgres 

Introducción
A continuación, se expone la solución planteada para un esquema de aprovisionamiento como el presentado en la siguiente imagen:

  <a href='https://postimg.org/image/bki58ba4j/' target='_blank'><img src='https://s13.postimg.org/bki58ba4j/image.png' border='0' alt="1"/></a><br/><br/>

 
Se plantea la siguiente distribución para el desarrollo de este proyecto, se hará uso de la herramienta Vagrant y una serie de Cookbooks de chef. Inicialmente se mostrará la configuración del archivo Vagrantfile, posteriormente los cookbooks necesarios para el aprovisionamiento de un micro-Framework disponible para usar en el lenguaje Python llamado Flask, el cual nos servirá como puente entre el nodo de consulta y la base de datos, para esta última usaremos PostgresSQL como motor. Finalmente se mostrarán las recetas necesarias para el despliegue de la base de datos.
1.	Despliegue Vagrant 
Con base en la arquitectura propuesta anteriormente, se decide aprovisionar dos máquinas virtuales, una encargada de contener el micro framework Flask y la segunda soportara todo lo correspondiente a la base de datos PostgresSQL.
Partimos con un script, provisioner, ubicado en el archivo VagrantFile, el cual se encarga de instalar todas las dependencias necesarias para la primera máquina con el micro framework.

   <a href='https://postimg.org/image/zcrgjuc5f/' target='_blank'><img src='https://s13.postimg.org/zcrgjuc5f/image.png' border='0' alt="2"/></a> 

Ilustración 1 Script provisioner
Luego de este script iniciamos con la configuración para aprovisionar las dos máquinas, maquina uno centos_flask y centos_databases.
 <a href='https://postimg.org/image/ry24rgq9v/' target='_blank'><img src='https://s13.postimg.org/ry24rgq9v/image.png' border='0' alt="3"/></a> 

Ilustración 2 Configuración Centos_Flask
De la anterior imagen se puede observar que se usara una imagen de centos6.6, se determinan dos direcciones Ips, una interna y otra externa con su respectiva mascara de red, además de esto se determinan parámetros como memoria, cpus, nombre de la máquina entre otros. Posterior a esto se determinan las recetas de Chef a usarse, para este caso tendremos una receta, <<mirror>> la cual nos ayudara a que los repositorios de la maquina apunten a otra máquina ubicada de forma local. Posterior a eso tenemos <<flask>> receta que se encarga de instalar todas las dependencias necesarias para que el micro framework funcione.
Por otra parte, contamos con la configuración de la maquina centos_databases:
 <a href='https://postimg.org/image/kw4759mo3/' target='_blank'><img src='https://s13.postimg.org/kw4759mo3/image.png' border='0' alt="4"/></a> 
Ilustración 3 Centos_databases

De forma inicial el aprovisionamiento de la maquina centos_databases es muy similar a la primera a excepción porque esta cuenta con un récipe llamado <<postgres>> con el cual se realizan todas las configuraciones necesarias para que esta máquina pueda operar. El funcionamiento de este servicio será explicado con más detalle más adelante.
2.	Cookbooks Micro Framework Flask
En esta sección se establecen las configuraciones necesarias para el aprovisionamiento de la máquina que tendrá el Flask como micro framework.
Se dispone de la siguiente distribución de archivos:
<a href='https://postimg.org/image/5ossynk77/' target='_blank'><img src='https://s13.postimg.org/5ossynk77/image.png' border='0' alt="5"/></a> 

Ilustración 4 Distribución de Archivos recipe Flask
Como se observa en la anterior distribución de archivos, tenemos una sección de files y otra se récipes. En la primera encontramos todos los archivos que incluiremos dentro de nuestra máquina, el primero archivo greedy.py se encarga de realizar la consulta con la máquina centos_databases en la que se encuentra la base de datos PostgreSQL. El archivo service.conf  se encarga de convertir las instrucciones escritas en el archivo greedy.py en un servicio nativo del sistema facilitando el proceso de prueba y ejecución. 
  <a href='https://postimg.org/image/8wxabp6gz/' target='_blank'><img src='https://s13.postimg.org/8wxabp6gz/image.png' border='0' alt="6"/></a>
Ilustración 5 Archivo service.conf
 <a href='https://postimg.org/image/uxdmsbp4z/' target='_blank'><img src='https://s13.postimg.org/uxdmsbp4z/image.png' border='0' alt="7"/></a> 

Ilustración 6 Archivo greedy.py
En cuanto a la sección de récipes, contamos con un archivo llamado install_flask.rb en el cual se definen las dependencias necesarias para que Flask funcione.

 <a href='https://postimg.org/image/eaw2j8w77/' target='_blank'><img src='https://s13.postimg.org/eaw2j8w77/image.png' border='0' alt="8"/></a> 

Ilustración 7 Archivo install_flask.rb
En este script podemos observar las distintas dependencias que instalaremos para el funcionamiento de Flask, inicialmente movemos los archivos provisioner.py, greedy.py y service.conf a las rutas determinadas en el formato. Además, se especifica en las líneas de bash el puerto por el cual se estará escuchando el servicio web, para este caso el puerto 80.
3.	Cookbooks Aprovisionamiento PostgreSQL
Para la sección de aprovisionamiento de la máquina de base de datos haremos uso de los siguientes archivos:
 
 <a href='https://postimg.org/image/feg6v7gub/' target='_blank'><img src='https://s13.postimg.org/feg6v7gub/image.png' border='0' alt="9"/></a> 
Ilustración 8 Directorio de Archivos Cookbook PostgreSQL
Para la configuración de esta máquina se hace uso de un cookbook en el que se modificaron los siguientes archivos.
Inicialmente el archivo pg_hba.conf establece las políticas de conexiones seguras a la base de datos, es decir en este archivo de configuración se encuentran las direcciones ips desde las cuales se pueden realizar consultas a la base de datos.
<a href='https://postimg.org/image/a4b83wwlf/' target='_blank'><img src='https://s13.postimg.org/a4b83wwlf/image.png' border='0' alt="10"/></a> 


Archivo de configuración pg_hba.conf
En el siguiente archivo postfgresql.conf determina los distintos parámetros de configuración para la base de datos como las unidades métricas de memoria, kB, MB, GB, TB, los directorios para los archivos y dentro de los parámetros de nuestro interés los de conexión a la base de datos y los de autenticación.
<a href='https://postimg.org/image/b7vcfvh8j/' target='_blank'><img src='https://s13.postimg.org/b7vcfvh8j/image.png' border='0' alt="11"/></a> 

Archivo de configuración postgresql.conf
En este caso el parámetro más significativo es el puerto de conexión establecido en el 5432, el cual será el puerto por el que la base de datos estará escuchando. 
En la carpeta récipes se encuentra el archivo installpostgres.rb en el cual se encuentran los scripts necesarios para la instalación de todas las dependencias usadas para que el servicio de la base de datos funcione de forma correcta, dentro de este archivo se adicionaron las siguientes líneas las cuales permiten reiniciar el servicio de la base de datos una vez terminadas todas las configuraciones, esto con el fin de resolver un error que impedía que se aplicarán de forma correcta las configuraciones.
 <a href='https://postimg.org/image/q53tgvugz/' target='_blank'><img src='https://s13.postimg.org/q53tgvugz/image.png' border='0' alt="12"/></a> 

Líneas de configuración archivo, installpostgres.rb
Con esta línea se termina la configuración respectiva para el funcionamiento de la base de datos, los demás archivos se dejaron en su normalidad y pueden ser encontrados en este directorio.
<a href='https://postimg.org/image/xz4f2a29v/' target='_blank'><img src='https://s13.postimg.org/xz4f2a29v/image.png' border='0' alt="14"/></a> 


4.	Resultados
Una vez realizado todo el proceso anterior obtenemos unos logs similares a los de la siguiente imagen, mostrando que toda la configuración se realizó de forma adecuada.
<a href='https://postimg.org/image/xz4f2a29v/' target='_blank'><img src='https://s13.postimg.org/xz4f2a29v/image.png' border='0' alt="14"/></a> 

Configuración exitosa de las maquinas.
Al realizar la consulta desde la ip determinada para la maquina centos_flask: 192.168.56.51 observamos el funcionamiento de ambas maquinas, una brindándonos un servicio web por el cual se puede consultar a la base de datos.
<a href='https://postimg.org/image/sozgazi0z/' target='_blank'><img src='https://s13.postimg.org/sozgazi0z/image.png' border='0' alt="15"/></a>  
Se observa la consulta que se realiza a la base de datos, trayendo consigo la información solicitada de la tabla swm.


Archivo créate_schema.sql
 <a href='https://postimg.org/image/8695jnthf/' target='_blank'><img src='https://s13.postimg.org/8695jnthf/image.png' border='0' alt="16"/></a> 

