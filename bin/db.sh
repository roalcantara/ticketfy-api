if [ -f /root/.my.cnf ]; then
  # If /root/.my.cnf exists then it won't ask for root password
  mysql -e "CREATE USER 'ticketfy'@localhost IDENTIFIED;"
  mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'ticketfy'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
else
  # If /root/.my.cnf doesn't exist then it'll ask for root password
  echo "Please enter root user MySQL password!"
  read rootpasswd
  mysql -uroot -p${rootpasswd} -e "CREATE USER 'ticketfy'@'localhost';"
  mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON *.* TO 'ticketfy'@'localhost';"
  mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
fi
