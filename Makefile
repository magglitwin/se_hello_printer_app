.PHONY: test test_ui

deps:
	pip install -r requirements.txt; \
	pip install -r test_requirements.txt

lint:
	flake8 hello_world test

test:
	PYTHONPATH=. py.test --verbose -s --ignore=test_ui

test2:
	PYTHONPATH=. py.test ... -v -m "not uitest"

test_cov:
	PYTHONPATH=. py.test --verbose -s --cov=. --ignore=test_ui

test_xunit:
	PYTHONPATH=. py.test -s --cov=.  --junit-xml=test_results.xml --ignore=test_ui

test_ui:
	py.test test_ui/test_ui.py

test_smoke:
	curl -I --fail 127.0.0.1:5000

docker_build:
	docker build -t hello-world-printer .
docker_run: docker_build
	docker run \
	--name hello-world-printer-dev \
	-p 5000:5000 \
	-d hello-world-printer

USERNAME=mlitwin
TAG=$(USERNAME)/hello-world-printer

docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag hello-world-printer $(TAG); \
	docker push $(TAG);\
	docker logout;
