gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure

ssh host
sudo apt update 
sudo apt install -y ruby-full ruby-bundler build-essential

#проверка -v
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
#update + install mongo

sudo apt update 
sudo apt install -y mongodb-org
sudo systemctl start mongod 
sudo systemctl enable mongod

git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d

# get port (tcp://0.0.0.0:9292)  
ps aux | grep puma 

#puma-server tag vpc
