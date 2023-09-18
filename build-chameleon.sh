ID=$(docker run -d chameleon-cloud /home/chameleon-cloud/build.sh)

docker logs -f $ID

docker commit $ID chameleon-cloud:$ID

COMMIT=$(docker run -i --workdir /home/chameleon-cloud/ChameleonUltra --rm chameleon-cloud:$ID git rev-parse --short HEAD)

docker tag chameleon-cloud:$ID nemanjan00/chameleon-cloud:$COMMIT

echo nemanjan00/chameleon-cloud:$COMMIT
