**Start the container**
docker-compose up
docker-compose down
docker-compose ps

**#Create a test Topic**
docker exec kafka kafka-topics --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

**List topics**
docker exec kafka kafka-topics --list --bootstrap-server localhost:9092

**Produce Messages**
docker exec -it kafka kafka-console-producer --broker-list localhost:9092 --topic test-topic

**Consume Messages**
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic test-topic --from-beginning

