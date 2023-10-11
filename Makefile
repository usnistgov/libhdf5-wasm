SZIP_SRC_DIR = szip
ZLIB_SRC_DIR = zlib

BUILD_DIR = build
HDF5_VERSIONS = 1.12.2 # 1.14.2 1.10.10
HDF5_TARBALLS = $(patsubst %, HDF5-%-Emscripten.tar.gz, $(HDF5_VERSIONS))

all: $(HDF5_TARBALLS) szip_tarball libz_tarball

libaec: 
	emcmake cmake -S $(SZIP_SRC_DIR) -B $(BUILD_DIR)/libaec;
	cmake --build $(BUILD_DIR)/libaec;
	cmake --install $(BUILD_DIR)/libaec --prefix=libaec;

libaec-1.0.6-Emscripten.tar.gz: libaec
	cpack -G TGZ --config $(BUILD_DIR)/libaec/CPackConfig.cmake;

szip_tarball: libaec-1.0.6-Emscripten.tar.gz

libz: 
	emcmake cmake -S $(ZLIB_SRC_DIR) -B $(BUILD_DIR)/libz;
	cmake --build $(BUILD_DIR)/libz;
	cmake --install $(BUILD_DIR)/libz --prefix=libz;

LIBZ-1.3-Emscripten.tar.gz: libz
	cpack -G TGZ --config $(BUILD_DIR)/libz/CPackConfig.cmake;

libz_tarball: LIBZ-1.3-Emscripten.tar.gz

HDF5-%-Emscripten.tar.gz: libaec libz
	emcmake cmake -DHDF5_VERSION=$(*) -S . -B $(BUILD_DIR)/$(*);
	cmake --build $(BUILD_DIR)/$(*) -j8;
	cpack -G TGZ --config $(BUILD_DIR)/$(*)/CPackConfig.cmake;

shasum: $(HDF5_TARBALLS)
	@for t in $(HDF5_TARBALLS); do shasum -a 256 $$t; done;

clean:
	rm -rf $(BUILD_DIR)
	rm -f *-Emscripten.tar.gz;
	rm -rf libaec;
	rm -rf libz;