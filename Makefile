WASM_BUILD_DIR = wasm_build
HDF5_VERSIONS = 1_12_1 1_13_0 1_10_8
INSTALL_PATHS = $(patsubst %, $(WASM_BUILD_DIR)/%/hdf5, $(HDF5_VERSIONS))
TARBALLS = $(patsubst %, libhdf5-%-wasm.tar.gz, $(HDF5_VERSIONS))

all: $(INSTALL_PATHS)
release: $(TARBALLS)

$(WASM_BUILD_DIR)/%/hdf5: VERSION=$(*)
$(WASM_BUILD_DIR)/%/hdf5:
	mkdir -p $(WASM_BUILD_DIR)/$(VERSION);
	cd $(WASM_BUILD_DIR)/$(VERSION) && emcmake cmake ../../ -DHDF5_VERSION=$(VERSION);
	cd $(WASM_BUILD_DIR)/$(VERSION) && emmake make -j8 install;

libhdf5-%-wasm.tar.gz: VERSION=$(*)
libhdf5-%-wasm.tar.gz: $(WASM_BUILD_DIR)/%/hdf5
	cp CMakeLists_dist.txt $(WASM_BUILD_DIR)/$(VERSION)/hdf5/CMakeLists.txt;
	cd $(WASM_BUILD_DIR)/$(VERSION)/hdf5 && tar -czvf ../../../$@ *;

shasum: $(TARBALLS)
	@for t in $(TARBALLS); do shasum -a 256 $$t; done;

clean:
	rm -rf $(WASM_BUILD_DIR);
	rm $(TARBALLS);
