################################################################################
## CONFIG ######################################################################
################################################################################
NUMBER_OF_CHAR_TYPES ?= 16

SRC_DIR ?= ${CURDIR}/src/
TEMPLATE_DIR ?= ${CURDIR}/template
CSS_DIR ?= ${CURDIR}/www/

GENERATE_N_COLORS_SCRIPT ?= $(SRC_DIR)/generate_n_colors.py
GENERATE_N_ENTITIES ?= $(SRC_DIR)/generate_n_entities.py

CHAR_STYLE_TEMPLATE ?= $(TEMPLATE_DIR)/character_icon_entry.css

# outputs
CHAR_STYLE_CSS ?= $(CSS_DIR)/characters.css

################################################################################
## MAKEFILE MAGIC ##############################################################
################################################################################
TOTAL_NUMBER_OF_COLORS = $(NUMBER_OF_CHAR_TYPES)
	#$(shell expr $(NUMBER_OF_TILE_TYPES) + $(NUMBER_OF_CHAR_TYPES))

SENSITIVITY_LIST = \
	Makefile \
	$(GENERATE_N_COLORS_SCRIPT)\
	$(GENERATE_N_ENTITIES)

################################################################################
## SANITY CHECKS ###############################################################
################################################################################
ifeq ($(wildcard $(GENERATE_N_COLORS_SCRIPT)),)
$(error\
	"Could not find script to generate N colors (GENERATE_N_COLORS_SCRIPT="\
	"$(GENERATE_N_COLORS_SCRIPT))."\
)
endif

ifeq ($(wildcard $(GENERATE_N_ENTITIES)),)
$(error\
	"Could not find script to generate N colors (GENERATE_N_ENTITIES="\
	"$(GENERATE_N_ENTITIES))."\
)
endif

ifeq ($(wildcard $(CHAR_STYLE_TEMPLATE)),)
$(error\
	"Could not find template for character styles (CHAR_STYLE_TEMPLATE="\
	"$(CHAR_STYLE_TEMPLATE))."\
)
endif

################################################################################
## TARGET RULES ################################################################
################################################################################
build: $(CHAR_STYLE_CSS)

clean:
	rm -f $(CHAR_STYLE_CSS)

reset: clean

################################################################################
## INTERNAL RULES ##############################################################
################################################################################
$(CHAR_STYLE_CSS): $(SENSITIVITY_LIST) $(CHAR_STYLE_TEMPLATE)
	$(GENERATE_N_COLORS_SCRIPT) $(TOTAL_NUMBER_OF_COLORS) \
		0 | \
		$(GENERATE_N_ENTITIES) $(NUMBER_OF_CHAR_TYPES) $(CHAR_STYLE_TEMPLATE) > \
		$(CHAR_STYLE_CSS)
