.PHONY: image publish

image:
	docker build $(CACHE_OPTION) --build-arg ctanmirror --build-arg baseimage --tag n-design/n-doc:latest .

publish:
	docker tag n-design/n-doc dockerregistrytest.n-design.de/n-design/n-doc:latest
	docker tag n-design/n-doc dockerregistry.n-design.de/n-design/n-doc:latest
	docker push dockerregistrytest.n-design.de/n-design/n-doc:latest
	docker push dockerregistry.n-design.de/n-design/n-doc:latest
