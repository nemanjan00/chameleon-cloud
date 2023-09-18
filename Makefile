container:
	docker build --ulimit "nofile=1024:1048576" . --tag chameleon-cloud

chameleon:
	bash ./build-chameleon.sh

all: container chameleon
