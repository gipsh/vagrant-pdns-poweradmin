PASSWORD='pass'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/"
    <Directory "/var/www/html/">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

#mcrypt
sudo apt-get install php5-mcrypt
sudo php5enmod mcrypt

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

# install curl 
sudo apt-get -y install curl

# install nano 
# para giles
#sudo apt-get -y install nano


#install nmap 
sudo apt-get install nmap

#install wget
sudo apt-get install wget



## pdns
sudo debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/dbconfig-install boolean true" 
sudo debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/db/name string pdns" 
sudo debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/mysql/admin-user string root" 
sudo debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/remote/port string 3306" 
sudo debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/remote/host string localhost" 

sudo apt-get -y install pdns-server pdns-backend-mysql

sudo cp /vagrant/pdns.conf /etc/powerdns/

sudo service pdns restart



## poweradmin

# get poweradmin
wget http://sourceforge.net/projects/poweradmin/files/poweradmin-2.1.7.tgz -P /var/www/html/

# uncompress
tar -xzvf /var/www/html/t/poweradmin-2.1.7.tgz /var/www/html/
sudo chown -R www-data:www-data /var/www/html/poweradmin/

# power admin dependencies
sudo apt-get install gettext libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php-pear php5-imap php5-ming php5-mysql php5-xmlrpc php5-mhash

sudo pear install pear/MDB2#mysql

sudo service apache2 start


