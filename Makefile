
.PHONY: lib

all: lib

lib:
	coffee --output lib --compile src
