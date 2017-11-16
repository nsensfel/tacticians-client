NUMBER_OF_TILE_TYPES ?= 16
NUMBER_OF_CHAR_TYPES ?= 16

SRC_DIR ?= ${CURDIR}/src/
TEMPLATE_DIR ?= ${CURDIR}/template
CSS_DIR ?= ${CURDIR}/www/

CHAR_STYLE_CSS ?= $(CSS_DIR)/characters.css
TILE_STYLE_CSS ?= $(CSS_DIR)/tiles.css

GENERATE_N_COLORS_SCRIPT ?= $(SRC_DIR)/generate_n_colors.py
GENERATE_N_ENTITIES ?= $(SRC_DIR)/generate_n_entities.py

CHAR_STYLE_TEMPLATE ?= $(TEMPLATE_DIR)/character_icon_entry.css
TILE_STYLE_TEMPLATE ?= $(TEMPLATE_DIR)/tile_entry.css

################################################################################
TOTAL_NUMBER_OF_COLORS = \
	$(shell expr $(NUMBER_OF_TILE_TYPES) + $(NUMBER_OF_CHAR_TYPES))

SENSITIVITY_LIST = \
	Makefile \
	$(GENERATE_N_COLORS_SCRIPT) $(GENERATE_N_ENTITIES)

################################################################################
build: $(TILE_STYLE_CSS) $(CHAR_STYLE_CSS)

clean:
	rm -f $(CHAR_STYLE_CSS) $(TILE_STYLE_CSS)

reset: clean


$(TILE_STYLE_CSS): $(SENSITIVITY_LIST) $(TILE_STYLE_TEMPLATE)
	$(GENERATE_N_COLORS_SCRIPT) $(TOTAL_NUMBER_OF_COLORS) 0 | \
		$(GENERATE_N_ENTITIES) $(NUMBER_OF_TILE_TYPES) $(TILE_STYLE_TEMPLATE) > \
		$(TILE_STYLE_CSS)

$(CHAR_STYLE_CSS): $(SENSITIVITY_LIST) $(CHAR_STYLE_TEMPLATE)
	$(GENERATE_N_COLORS_SCRIPT) $(TOTAL_NUMBER_OF_COLORS) \
		$(NUMBER_OF_TILE_TYPES) | \
		$(GENERATE_N_ENTITIES) $(NUMBER_OF_CHAR_TYPES) $(CHAR_STYLE_TEMPLATE) > \
		$(CHAR_STYLE_CSS)

