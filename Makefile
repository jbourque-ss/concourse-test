
init-docker-net:
	@if [ $(shell docker network ls | grep concourse-test | wc -l) != 1 ]; then \
		docker network create --driver bridge concourse-test > /dev/null; \
	fi
    
build-a:
	docker build . -f ComponentA/Dockerfile -t jbn/concourse-test-a:0.0.1

run-a: init-docker-net
	docker run -it --rm --network concourse-test --name concourse-test-a jbn/concourse-test-a:0.0.1

build-b:
	docker build . -f ComponentB/Dockerfile -t jbn/concourse-test-b:0.0.1

run-b: init-docker-net
	docker run -it --rm --network concourse-test --name concourse-test-b jbn/concourse-test-b:0.0.1
