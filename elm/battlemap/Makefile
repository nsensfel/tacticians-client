ELM_CC = elm-make --warn
SRC_DIR = src

MAIN_MODULE = $(SRC_DIR)/Main.elm
SUB_MODULES = $(shell find $(SRC_DIR) -type f | grep "elm$$")

index.html: $(MAIN_MODULE) $(SUB_MODULES)
	$(ELM_CC) $(MAIN_MODULE)

clean:
	rm -f index.html
