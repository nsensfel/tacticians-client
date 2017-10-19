MODULES = battlemap
SRC_DIR = ${CURDIR}/src
WWW_DIR = ${CURDIR}/www

MODULES_SRC = $(addprefix $(SRC_DIR)/,$(MODULES))
MODULES_WWW = $(addprefix $(WWW_DIR)/,$(MODULES))

all: build $(MODULES_WWW)

build:
	for module in $(MODULES_SRC) ; do \
		$(MAKE) -C $$module build ; \
	done

clean:
	for module in $(MODULES_SRC) ; do \
		$(MAKE) -C $$module clean ; \
	done

$(MODULES_WWW): %: $(WWW_DIR)
	ln -s $(SRC_DIR)/$(notdir $<)/www $@

$(WWW_DIR):
	mkdir -p $@
