.PHONY: image publish

image:
	docker build $(CACHE_OPTION) --rm --tag n-design/n-doc .

publish:
	docker tag n-design/n-doc dockerregistry.n-design.de/n-design/n-doc
	docker push dockerregistry.n-design.de/n-design/n-doc
