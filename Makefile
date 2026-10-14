INSTALL_PREFIX = $(CURDIR)/dist
BUILD_DIR = build
TOOLS_DIR = tools
TOOLS_PACKAGE_DIR = tools-package
HDF5_VERSIONS = 1_10_11 1_12_3 1.14.6 2.0.0
HDF5_DEFAULT_VERSION = $(lastword $(HDF5_VERSIONS))
HDF5_TARBALLS = $(patsubst %, HDF5-%-Emscripten.tar.gz, $(HDF5_VERSIONS))
HDF5_DEFAULT_TARBALL = HDF5-$(HDF5_DEFAULT_VERSION)-Emscripten.tar.gz
HDF5_WASM64_TARBALL = HDF5-$(HDF5_DEFAULT_VERSION)-wasm64-Emscripten.tar.gz
HDF5_TARBALLS += $(HDF5_WASM64_TARBALL)
# a "-wasm64" stem builds with -sMEMORY64=1 (emcc applies EMCC_CFLAGS to every compile and link)
WASM64_ENV = $(if $(findstring -wasm64,$*),EMCC_CFLAGS=-sMEMORY64=1)

.PHONY: all default wasm64 tools shasum clean help

all: $(HDF5_TARBALLS)
default: $(HDF5_DEFAULT_TARBALL)
wasm64: $(HDF5_WASM64_TARBALL)

HDF5-%-Emscripten.tar.gz:
	$(WASM64_ENV) emcmake cmake -DCMAKE_INSTALL_PREFIX="$(INSTALL_PREFIX)/$(*)" -DHDF5_VERSION=$(*:-wasm64=) -S . -B $(BUILD_DIR)/$(*);
	$(WASM64_ENV) cmake --build $(BUILD_DIR)/$(*) -j8;
	cmake --install $(BUILD_DIR)/$(*);
	cd $(INSTALL_PREFIX)/$(*) && tar -cvzf ../../$@ *;

$(TOOLS_DIR)/.ready:
	@echo "Extracting tools from default version..."
	@mkdir -p $(TOOLS_DIR);
	emcmake cmake -DCMAKE_INSTALL_PREFIX="$(INSTALL_PREFIX)/tools" \
		-DHDF5_VERSION=$(HDF5_DEFAULT_VERSION) \
		-S . -B $(BUILD_DIR)/tools \
		-DHDF5_BUILD_TOOLS=ON;
	cmake --build $(BUILD_DIR)/tools -j8;
	cmake --install $(BUILD_DIR)/tools;
	@cp $(INSTALL_PREFIX)/tools/bin/* $(TOOLS_DIR)/;
	@mkdir -p $(TOOLS_PACKAGE_DIR)/bin/;
	@cp $(INSTALL_PREFIX)/tools/bin/* $(TOOLS_PACKAGE_DIR)/bin/;
	@touch $@

tools: $(TOOLS_DIR)/.ready
	@echo "Tools extracted to $(TOOLS_DIR)/"

shasum: $(HDF5_TARBALLS)
	@for t in $(HDF5_TARBALLS); do shasum -a 256 $$t; done;

clean:
	rm -rf $(BUILD_DIR)
	rm -f *-Emscripten.tar.gz;
	rm -rf dist;
	rm -rf build;
	rm -rf $(TOOLS_DIR);
	rm -rf $(TOOLS_PACKAGE_DIR)/bin/*;