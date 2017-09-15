TARGETS = battlemap

all: $(TARGETS) $(addsuffix .html,$(TARGETS))

$(TARGETS):
	$(MAKE) -C elm/$@ index.html

%.html: elm/%/index.html
	cp $< $@
