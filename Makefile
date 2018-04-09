################################################################################
## CONFIG ######################################################################
################################################################################
MODULES ?= battlemap global asset
CONFIG_FILE ?= ${CURDIR}/conf/constants.conf

SRC_DIR = ${CURDIR}/src
WWW_DIR = ${CURDIR}/www

################################################################################
## MAKEFILE MAGIC ##############################################################
################################################################################
MODULES_SRC = $(addprefix $(SRC_DIR)/,$(MODULES))
MODULES_WWW = $(addprefix $(WWW_DIR)/,$(MODULES))

PREPROCESSOR_FILES = $(shell find ${CURDIR} -name "*.m4")
PREPROCESSED_FILES = $(patsubst %.m4,%,$(PREPROCESSOR_FILES))

################################################################################
## SANITY CHECKS ###############################################################
################################################################################
ifeq ($(wildcard $(CONFIG_FILE)),)
$(error "Missing CONFIG_FILE ($(CONFIG_FILE)), use the example to make one.")
endif

################################################################################
## TARGET RULES ################################################################
################################################################################

all: $(PREPROCESSED_FILES) build $(WWW_DIR) $(MODULES_WWW)

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
	rm -f $(PREPROCESSED_FILES)

reset:
	$(MAKE) clean
	for module in $(MODULES_SRC) ; do \
		$(MAKE) -C $$module reset; \
	done

################################################################################
## INTERNAL RULES ##############################################################
################################################################################
$(PREPROCESSED_FILES): %: $(CONFIG_FILE) %.m4
	m4 -P $^ > $@

$(MODULES_WWW): %:
	ln -s $(SRC_DIR)/$(patsubst $(WWW_DIR)/%,%,$@)/www/ $@

$(WWW_DIR):
	mkdir -p $@
