
init-docker-net:
	@if [ $(shell docker network ls | grep concourse-test | wc -l) != 1 ]; then \
		docker network create --driver bridge concourse-test > /dev/null; \
	fi
    
build-a:
	docker build . -f ComponentA/Dockerfile -t jbn/concourse-test-a:0.0.1

run-a: init-docker-net
	docker run -it -d --rm --network concourse-test --name concourse-test-a jbn/concourse-test-a:0.0.1

stop-a:
	@if [ -n "$(shell docker ps -q --filter 'name=concourse-test-a')" ]; then \
		docker rm -f concourse-test-a ; \
	fi

build-b:
	docker build . -f ComponentB/Dockerfile -t jbn/concourse-test-b:0.0.1

run-b: init-docker-net
	docker run -it -d --rm --network concourse-test --name concourse-test-b jbn/concourse-test-b:0.0.1

stop-b:
	@if [ -n "$(shell docker ps -q --filter 'name=concourse-test-b')" ]; then \
		docker rm -f concourse-test-b ; \
	fi

run: run-a run-b

stop: stop-a stop-b

push-ci-pipeline:
	fly -t simspace set-pipeline -c ci/concourse.yml -p jnb-test
