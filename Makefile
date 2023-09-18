container:
	docker build --ulimit "nofile=1024:1048576" . --tag chameleon-cloud

chameleon:
	docker run --rm -ti chameleon-cloud /home/chameleon-cloud/build.sh
