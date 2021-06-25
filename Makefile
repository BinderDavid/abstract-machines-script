.PHONY: gen-apps
gen-apps:
	$(MAKE) -C elm-apps
	mkdir -p static/javascript
	cp elm-apps/target/* static/javascript/
