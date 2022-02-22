WASM_BUILD_DIR = wasm_build
INSTALL_DIR = libhdf5
WASM_LIB_DIR = $(INSTALL_DIR)/lib
WASM_INCLUDE_DIR = $(INSTALL_DIR)/include
WASM_LIBS = $(WASM_LIB_DIR)/libhdf5.a $(WASM_LIB_DIR)/libhdf5_hl.a 

$(WASM_LIBS):
	mkdir -p $(WASM_BUILD_DIR);
	cd $(WASM_BUILD_DIR) && emcmake cmake ../;
	cd $(WASM_BUILD_DIR) && emmake make -j8 install;

clean:
	rm -rf $(WASM_BUILD_DIR);
	rm -rf $(INSTALL_DIR);