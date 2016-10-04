execute 'postMirror' do 
	command 'yum localinstall http://yum.postgresql.org/9.4/redhat/rhel-6.4-i386/pgdg-centos94-9.4-3.noarch.rpm -y'
end

#Instalacion de postgres 9.4 server a traves de YUM
yum_package 'postgresql94-server' do
  action :install
end

#Inicia el servicio de base de datos de Postgres
execute 'initdb' do
  command 'service postgresql-9.4 initdb'
end

#Se subieron los comandos para insertar los files en la maquina virtual ya que eran necesarios antes de iniciar el servicio de postgres para que la configuracion de los
#archivos fuera tomada a la hora de iniciar el servicio
#Tambien se edito el owner y el group por "postgres" para darle los permisos necesarios a este usuario para acceder a los archivos de configuracion


#Crea el archivo el archivo pg_hba.conf en el directorio /var/lib/pgsql/9.4/data/ en la maquina virtual. Este archivo se encuentra en el directorio files/default
cookbook_file "/var/lib/pgsql/9.4/data/pg_hba.conf" do
	source "pg_hba.conf"
	mode 0711
	owner "postgres"
	group "postgres"
        action :create
end

#Crea el archivo el archivo postgresql.conf en el directorio /var/lib/pgsql/9.4/data/ en la maquina virtual. Este archivo se encuentra en el directorio files/default
cookbook_file "/var/lib/pgsql/9.4/data/postgresql.conf" do
	source "postgresql.conf"
	mode 0711
	owner "postgres"
	group "postgres"
        action :create
end

#Inicia el servicio de postgres cada vez que se enciende la maquina virtual
execute 'nextinitdb' do
  command 'chkconfig postgresql-9.4 on'
end

#Inicia el servicio de postgres
execute 'nextnextinitdb' do
  command 'service postgresql-9.4 start'
end

#Se elimino el comando que modifica los permisos de red de la maquina virtual para permitir el acceso al puerto 80 por el cual se reciben las peticiones http
#ya que este puerto no es necesario para la maquina de base de datos


#El siguiente comando modifica los permisos de red de la maquina virtual para permitir el acceso al puerto 5432 por el cual se reciben las conexiones a la base de datos Postgres
bash "open port" do
	user "root"
	code <<-EOH
	iptables -I INPUT 5 -p tcp -m state --state NEW -m tcp --dport 5432 -j ACCEPT
	service iptables save
	EOH
end


#Crea el archivo el archivo create_schema.sql en el directorio temporal /tmp/ en la maquina virtual. Este archivo se encuentra en el directorio files/default.
#Este archivo contiene el script SQL para la creacion del esquema en la base de datos
cookbook_file "/tmp/create_schema.sql" do
	source "create_schema.sql"
	mode 0644
	owner "root"
	group "wheel"
end

#Ejecuta el archivo create_schema.sql a traves del motor de postgres ejecutado por el comando psql
bash "create schema" do
	user "postgres"
	cwd "/tmp"
	code <<-EOH
	psql < create_schema.sql
	EOH
end
bash "postgres restart" do
	user "root"
	code <<-EOH
	service postgresql-9.4 restart
	EOH
end
