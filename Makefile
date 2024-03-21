
init-docker-net:
	@if [ $(shell docker network ls | grep concourse-test | wc -l) != 1 ]; then \
		docker network create --driver bridge concourse-test > /dev/null; \
	fi
    
build-a:
	docker build . -f ComponentA/Dockerfile -t jbn/component-a:0.0.1

run-a: init-docker-net
	docker run -it -d --rm --network concourse-test --name component-a jbn/component-a:0.0.1

stop-a:
	@if [ -n "$(shell docker ps -q --filter 'name=component-a')" ]; then \
		docker rm -f component-a ; \
	fi

build-b:
	docker build . -f ComponentB/Dockerfile -t jbn/component-b:0.0.1

run-b: init-docker-net
	docker run -it -d --rm --network concourse-test --name component-b jbn/component-b:0.0.1

stop-b:
	@if [ -n "$(shell docker ps -q --filter 'name=component-b')" ]; then \
		docker rm -f component-b ; \
	fi

build: build-a build-b

run: run-a run-b

stop: stop-a stop-b

push-ci-pipeline:
	fly -t simspace set-pipeline -c ci/concourse.yml -p jnb-test
