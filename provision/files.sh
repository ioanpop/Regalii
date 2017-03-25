#!/bin/bash

echo "Creating ansible file"
cat <<'EOF' >> /home/vagrant/app.yml
---
- hosts: localhost
  become: true
  become_user: vagrant
  tasks:
    - name: Bundle install
      command: bash -lc '/usr/local/bin/bundle install'
      args:
        chdir: /home/vagrant/app/
    - name: Run app
      command: bash -lc '/bin/rackup -s puma -p 8080 &'
      args:
        chdir: /home/vagrant/app/
EOF
echo "Creating service check file"
cat <<'EOF' >> /home/vagrant/app_check.sh
#!/bin/bash
SERVICE='puma'
HOST=$(hostname)
EMAIL='gosthman@gmail.com'
 
if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    echo "$SERVICE service running, everything is fine"
else
    echo "$SERVICE is not running"
    echo "$SERVICE is not running" | mail -s "$SERVICE is down on $HOST" $EMAIL
fi
EOF
echo "Setting permisions"
chown -R vagrant:vagrant /home/vagrant/app.yml
chown -R vagrant:vagrant /home/vagrant/app_check.sh
chown -R vagrant:vagrant /home/vagrant/cron.txt
chmod +x /home/vagrant/app_check.sh