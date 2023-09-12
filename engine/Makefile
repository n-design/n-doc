.PHONY: all image publish n-doc n-doc-plantuml

all: images

images: n-doc-plantuml

n-doc-plantuml: n-doc
	docker buildx build --platform linux/arm64,linux/amd64 --push $(CACHE_OPTION) -f Dockerfile.plantuml --progress plain --tag ndesign/n-doc:latest-plantuml .

n-doc:
	docker buildx build --platform linux/arm64,linux/amd64 --push $(CACHE_OPTION) --progress plain --build-arg ctanmirror --build-arg baseimage --tag ndesign/n-doc:latest .

