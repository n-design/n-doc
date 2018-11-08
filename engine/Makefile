.PHONY: image publish

image:
	docker build $(CACHE_OPTION) --rm --tag n-design/n-doc .
	docker tag n-design/n-doc dockerregistry.n-design.de/n-design/n-doc
	docker tag n-design/n-doc dockerhub.n-design.de/n-design/n-doc

publish:
	docker push dockerregistry.n-design.de/n-design/n-doc
