<VirtualHost *:80>

     ServerName THIS_BOOKTYPE_SERVER
     ServerAdmin ADMIN_EMAIL
     SetEnv HTTP_HOST "THIS_BOOKTYPE_SERVER"

     SetEnv LC_TIME "LANGUAGE_CODE.UTF-8"
     SetEnv LANG "LANGUAGE_CODE.UTF-8"

     WSGIScriptAlias / DEFAULT_INSTANCE_DIR/DEFAULT_INSTANCE_NAME/DEFAULT_INSTANCE_NAME_site/wsgi.py

     <Location "/">
       #Require all granted
       Options -Indexes
     </Location>

     Alias /static/ "DEFAULT_INSTANCE_DIR/DEFAULT_INSTANCE_NAME/static/"
     <Directory "DEFAULT_INSTANCE_DIR/DEFAULT_INSTANCE_NAME/static/">
       #Require all granted
       Options -Indexes
     </Directory>

     Alias /data/ "DEFAULT_INSTANCE_DIR/DEFAULT_INSTANCE_NAME/data/"
     <Directory "DEFAULT_INSTANCE_DIR/DEFAULT_INSTANCE_NAME/data/">
       #Require all granted
       Options -Indexes
     </Directory>

     ErrorLog ${APACHE_LOG_DIR}/booktype-DEFAULT_INSTANCE_NAME-error.log
     LogLevel warn
     CustomLog ${APACHE_LOG_DIR}/booktype-DEFAULT_INSTANCE_NAME-access.log combined

</VirtualHost>
