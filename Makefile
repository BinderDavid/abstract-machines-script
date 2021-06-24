.PHONY: gen-apps
gen-apps:
	$(MAKE) -C elm-apps
	cp elm-apps/target/* static/javascript/
