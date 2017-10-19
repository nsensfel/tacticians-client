MODULES = battlemap
SRC_DIR = ${CURDIR}/src
WWW_DIR = ${CURDIR}/www

MODULES_SRC = $(addprefix $(SRC_DIR)/,$(MODULES))
MODULES_WWW = $(addprefix $(WWW_DIR)/,$(MODULES))

all: build $(WWW_DIR) $(MODULES_WWW)

build:
	for module in $(MODULES_SRC) ; do \
		$(MAKE) -C $$module build ; \
	done

clean:
	for module in $(MODULES_SRC) ; do \
		$(MAKE) -C $$module clean ; \
	done

$(MODULES_WWW): %:
	ln -s $(SRC_DIR)/$(patsubst $(WWW_DIR)/%,%,$@)/www/ $@

$(WWW_DIR):
	mkdir -p $@
