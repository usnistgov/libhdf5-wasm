BUILD_DIR = build
HDF5_VERSIONS = 1.12.2 1.14.2 1.10.10
TARBALLS = $(patsubst %, HDF5-%-Emscripten.tar.gz, $(HDF5_VERSIONS))

all: $(TARBALLS)

HDF5-%-Emscripten.tar.gz: VERSION=$(*)
HDF5-%-Emscripten.tar.gz:
	rm -rf $(BUILD_DIR);
	emcmake cmake -DHDF5_VERSION=$(VERSION) -S . -B $(BUILD_DIR);
	cmake --build $(BUILD_DIR) --target zlibstatic sz_static;
	cmake --build $(BUILD_DIR) -j8;
	cpack -G TGZ --config $(BUILD_DIR)/CPackConfig.cmake;

shasum: $(TARBALLS)
	@for t in $(TARBALLS); do shasum -a 256 $$t; done;

clean:
	rm -rf $(BUILD_DIR);
	rm -f HDF5-*-Emscripten.tar.gz;
