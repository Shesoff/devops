#!/usr/bin/env bash

# Cluster nodes, minimum 6, 3 masters and 3 slaves
nodes=6
port=6378
ports=()

# System prepare
yum update -y
yum install -y mc nmap vim sed htop telnet
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl enable --now docker

# Create file configuration
cat << EOT > cluster-config.conf
port $port
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOT

# Edit port number in config, then start docker redis instance
for (( newport=port; newport < port + nodes; newport++ ))
do
	cp cluster-config.conf redis-$newport.config
	sed -i -e "s/$port/$newport/g" redis-$newport.conf
 	docker run -d -v $PWD/redis-$newport.conf:/usr/local/etc/redis/redis.conf \
 	--name redis-$newport --net host --restart unless-stopped redis:5.0.5 \
 	redis-server /usr/local/etc/redis/redis.conf
	ports+=( $newport )
done

rm -rf cluster-config.conf
# Configuration Redis cluster
if [ -n $1 ]
	docker run --net host -i redis:5.0.5 redis-cli --cluster \
	create $1:${ports[0]} $1:${ports[1]} $1:${ports[2]} $1:${ports[3]} $1:${ports[4]} $1:${ports[5]} \
	--cluster-replicas 1

# Check cluster status
docker run --net host -i redis:5.0.5 redis-cli cluster nodes
