.PHONY: image publish

image:
	docker build $(CACHE_OPTION) --build-arg ctanmirror --build-arg baseimage --tag ndesign/n-doc:latest .
	docker build $(CACHE_OPTION) -f Dockerfile.plantuml --tag ndesign/n-doc-plantuml:latest .

publish:
	docker push ndesign/n-doc:latest
	docker push ndesign/n-doc-plantuml:latest
