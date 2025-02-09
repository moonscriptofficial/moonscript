.PHONY: build
build: bin/moon

.PHONY: spec
spec:
	crystal spec --error-on-warnings --error-trace --progress

.PHONY: spec-cli
spec-cli: build
	crystal spec spec_cli/*_spec.cr spec_cli/**/*_spec.cr --error-on-warnings --error-trace --progress

.PHONY: format
format:
	crystal tool format

.PHONY: format-core
format-core: build
	cd core && ../bin/moon format
	cd core/tests && ../../bin/moon format

.PHONY: ameba
ameba:
	bin/ameba

.PHONY: test
test: spec ameba

.PHONY: test-core
test-core: build
	cd core/tests && ../../bin/moon test -b chrome

.PHONY: development
development: build
	mv bin/moon ~/.bin/moon-dev

.PHONY: local
local: build
	mv bin/moon ~/.bin/moon

.PHONY: documentation
documentation:
	rm -rf docs && crystal docs

.PHONY: development-release
development-release:
	docker-compose run --rm app \
		crystal build src/moon.cr -o moon-dev --static --no-debug --release
		mv ./moon-dev ~/.bin/

src/assets/runtime.js: \
	$(shell find runtime/src -type f) \
	runtime/index.js
	cd runtime && make index

src/assets/runtime_test.js: \
	$(shell find runtime/src -type f) \
	runtime/index_testing.js \
	runtime/index.js
	cd runtime && make index_testing

# This builds the binary and depends on files in some directories.
bin/moon: \
	$(shell find core/source -type f) \
	$(shell find runtime/src -type f) \
	$(shell find src -type f) \
	src/assets/runtime_test.js \
	src/assets/runtime.js
	shards build --error-on-warnings --error-trace --progress