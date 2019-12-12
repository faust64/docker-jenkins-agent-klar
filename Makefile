SKIP_SQUASH?=1

.PHONY: build
build:
	SKIP_SQUASH=$(SKIP_SQUASH) hack/build.sh

.PHONY: test
test:
	SKIP_SQUASH=$(SKIP_SQUASH) TAG_ON_SUCCESS=$(TAG_ON_SUCCESS) TEST_MODE=true hack/build.sh
