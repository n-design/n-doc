.PHONY: all
latesttag:=$(shell git describe --tags --abbrev=0)

all:
	docker build --rm --tag n-design/n-doc:$(latesttag) .
