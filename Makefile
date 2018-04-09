MODULES ?= battlemap global asset
CONFIG_FILE ?= ${CURDIR}/conf/constants.conf

SRC_DIR = ${CURDIR}/src
WWW_DIR = ${CURDIR}/www

MODULES_SRC = $(addprefix $(SRC_DIR)/,$(MODULES))
MODULES_WWW = $(addprefix $(WWW_DIR)/,$(MODULES))

PREPROCESSOR_FILES = $(shell find ${CURDIR} -name "*.m4")
PREPROCESSED_FILES = $(patsubst %.m4,%,$(PREPROCESSOR_FILES))

ifeq ($(wildcard $(CONFIG_FILE)),)
$(error "Missing CONFIG_FILE ($(CONFIG_FILE)), use the example to make one.")
endif

export

all: $(PREPROCESSED_FILES) build $(WWW_DIR) $(MODULES_WWW)

$(PREPROCESSED_FILES): %: $(CONFIG_FILE) %.m4
	m4 $^ > $@

upload_demo:
	scp -r $(WWW_DIR)/* dreamhost:~/tacticians.online/

build:
	for module in $(MODULES_SRC) ; do \
		$(MAKE) -C $$module build ; \
	done

clean:
	for module in $(MODULES_SRC) ; do \
		$(MAKE) -C $$module clean ; \
	done
	rm $(PREPROCESSED_FILES)

reset:
	for module in $(MODULES_SRC) ; do \
		$(MAKE) -C $$module clean; \
		$(MAKE) -C $$module reset; \
	done

$(MODULES_WWW): %:
	ln -s $(SRC_DIR)/$(patsubst $(WWW_DIR)/%,%,$@)/www/ $@

$(WWW_DIR):
	mkdir -p $@
