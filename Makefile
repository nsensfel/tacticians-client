################################################################################
## CONFIG ######################################################################
################################################################################
MODULES ?= css global main-menu login roster-editor map-editor asset battle

SRC_DIR = ${CURDIR}/src
WWW_DIR = ${CURDIR}/www
DATA_DIR ?= /my/src/tacticians-data/

################################################################################
## MAKEFILE MAGIC ##############################################################
################################################################################
MODULES_SRC = $(addprefix $(SRC_DIR)/,$(MODULES))
MODULES_WWW = $(addprefix $(WWW_DIR)/,$(MODULES))

################################################################################
## SANITY CHECKS ###############################################################
################################################################################
ifeq ($(strip $(wildcard $(DATA_DIR))),)
$(error "Could not find the game's data folder (currently set to $(DATA_DIR)). Download it and set the DATA_DIR variable to match its location.")
endif

################################################################################
## INCLUDES ####################################################################
################################################################################
main_target: all

include ${CURDIR}/mk/preprocessor.mk

################################################################################
## TARGET RULES ################################################################
################################################################################
all: $(PREPROCESSOR_RESULT) build $(WWW_DIR) $(MODULES_WWW)

upload_to:
	$(MAKE) CONFIG_FILE=conf/tacticians.conf
	rsync -avz -L -e "ssh" $(WWW_DIR) procyon_:/static_content_node/

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
$(MODULES_WWW): %:
	ln -s $(SRC_DIR)/$(patsubst $(WWW_DIR)/%,%,$@)/www/ $@

$(WWW_DIR):
	mkdir -p $@
