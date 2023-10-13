SZIP_SRC_DIR = szip
ZLIB_SRC_DIR = zlib

BUILD_DIR = build
HDF5_VERSIONS = 1.12.2 # 1.14.2 1.10.10
HDF5_TARBALLS = $(patsubst %, HDF5-%-Emscripten.tar.gz, $(HDF5_VERSIONS))
PRIVATE_LIBS = Libs.private: -lm -ldl -lz -lsz -lhdf5

all: $(HDF5_TARBALLS) szip_tarball libz_tarball

libaec-1.0.6-Emscripten.tar.gz:
	emcmake cmake -S $(SZIP_SRC_DIR) -B $(BUILD_DIR)/libaec;
	cmake --build $(BUILD_DIR)/libaec;
	cpack -G TGZ --config $(BUILD_DIR)/libaec/CPackConfig.cmake;

szip_tarball: libaec-1.0.6-Emscripten.tar.gz

libz-1.3-Emscripten.tar.gz:
	emcmake cmake -S $(ZLIB_SRC_DIR) -B $(BUILD_DIR)/libz;
	cmake --build $(BUILD_DIR)/libz;
	cpack -G TGZ --config $(BUILD_DIR)/libz/CPackConfig.cmake;

libz_tarball: libz-1.3-Emscripten.tar.gz

HDF5-%-Emscripten.tar.gz: szip_tarball libz_tarball
	emcmake cmake -DHDF5_VERSION=$(*) -S . -B $(BUILD_DIR)/$(*);
	cmake --build $(BUILD_DIR)/$(*) -j8;
	sed -i -- 's/^Libs\.private.*$$/$(PRIVATE_LIBS)/g' $(BUILD_DIR)/$(*)/_deps/hdf5-build/CMakeFiles/hdf5.pc;
	cpack -G TGZ --config $(BUILD_DIR)/$(*)/CPackConfig.cmake;

shasum: $(HDF5_TARBALLS)
	@for t in $(HDF5_TARBALLS); do shasum -a 256 $$t; done;

clean:
	rm -rf $(BUILD_DIR)
	rm -f *-Emscripten.tar.gz;
	rm -rf libaec;
	rm -rf libz;