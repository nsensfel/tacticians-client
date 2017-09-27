TARGETS = battlemap
PAGES = $(addsuffix .html,$(TARGETS))

all: $(TARGETS) $(PAGES)

upload_demo: $(PAGES) LICENSE
	scp -r $^ dreamhost:~/tacticians.online/

$(TARGETS):
	$(MAKE) -C elm/$@ index.html

%.html: elm/%/index.html
	cp $< $@
