docker_tebako_all: docker_tebako_3_2_2 docker_tebako_3_1_4 docker_tebako_3_0_6 docker_tebako_2_7_7

docker_tebako_3_2_2:
	RUBY_VERSION=3.2.2 ALPINE_VERSION=3.14 DOCKER_TAG=3.2.2-openssl1_1 make docker_tebako
	RUBY_VERSION=3.2.2 ALPINE_VERSION=3.17 DOCKER_TAG=3.2.2-openssl3_0 make docker_tebako
	# RUBY_VERSION=3.2.2 ALPINE_VERSION=3.18 DOCKER_TAG=3.2.2-openssl3_1 make docker_tebako
docker_tebako_3_1_4:
	RUBY_VERSION=3.1.4 ALPINE_VERSION=3.14 DOCKER_TAG=3.1.4-openssl1_1 make docker_tebako
	RUBY_VERSION=3.1.4 ALPINE_VERSION=3.17 DOCKER_TAG=3.1.4-openssl3_0 make docker_tebako
	# RUBY_VERSION=3.1.4 ALPINE_VERSION=3.18 DOCKER_TAG=3.1.4-openssl3_1 make docker_tebako
docker_tebako_3_0_6:
	RUBY_VERSION=3.0.6 ALPINE_VERSION=3.14 DOCKER_TAG=3.0.6-openssl1_1 make docker_tebako
	RUBY_VERSION=3.0.6 ALPINE_VERSION=3.17 DOCKER_TAG=3.0.6-openssl3_0 make docker_tebako
	# RUBY_VERSION=3.0.6 ALPINE_VERSION=3.18 DOCKER_TAG=3.0.6-openssl3_1 make docker_tebako
docker_tebako_2_7_7:
	RUBY_VERSION=2.7.7 ALPINE_VERSION=3.14 DOCKER_TAG=2.7.7-openssl1_1 make docker_tebako
	RUBY_VERSION=2.7.7 ALPINE_VERSION=3.17 DOCKER_TAG=2.7.7-openssl3_0 make docker_tebako
	# RUBY_VERSION=2.7.7 ALPINE_VERSION=3.18 DOCKER_TAG=2.7.7-openssl3_1 make docker_tebako

docker_tebako:
	docker build -f Dockerfile.press_builder --progress=plain -t you54f/tebako:$$DOCKER_TAG . --build-arg RUBY_VERSION=$$RUBY_VERSION --build-arg ALPINE_VERSION=$$ALPINE_VERSION
	# docker push you54f/tebako:$$DOCKER_TAG
