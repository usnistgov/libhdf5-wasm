WASM_BUILD_DIR = wasm_build
INSTALL_DIR = $(WASM_BUILD_DIR)/hdf5
WASM_LIB_DIR = $(INSTALL_DIR)/lib
WASM_LIBS = $(WASM_LIB_DIR)/libhdf5.a $(WASM_LIB_DIR)/libhdf5_hl.a 

$(WASM_LIBS):
	mkdir -p $(WASM_BUILD_DIR);
	cd $(WASM_BUILD_DIR) && emcmake cmake ../;
	cd $(WASM_BUILD_DIR) && emmake make -j8 install;

release: $(WASM_LIBS)
	cp CMakeLists_dist.txt $(INSTALL_DIR)/CMakeLists.txt;
	cd $(INSTALL_DIR) && tar -czvf ../../libhdf5-wasm.tar.gz *;
	shasum -a 256 libhdf5-wasm.tar.gz;

clean:
	rm -rf $(WASM_BUILD_DIR);
	rm -rf $(INSTALL_DIR);
