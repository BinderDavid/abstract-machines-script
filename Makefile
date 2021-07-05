JSPATH = static/javascript/
.PHONY: gen-apps
gen-apps:
	mkdir -p $(JSPATH)
	$(MAKE) -C elm-apps
	cp elm-apps/target/* $(JSPATH)
	$(MAKE) -C purescript-apps
	cp purescript-apps/purescript.js $(JSPATH)
