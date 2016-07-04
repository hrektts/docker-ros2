all: build

build:
	@docker build -t hrektts/ros2:latest .

release: build
	@docker build -t hrektts/ros2:$(shell cat VERSION) .

.PHONY: test
test:
	@docker build -t hrektts/ros2:bats .
	bats test
