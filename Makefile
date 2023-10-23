INSTALL_PREFIX = "$(realpath .)/dist"
HDF5_VERSION = 1.14.2
ZLIB_LIBRARY = $(INSTALL_PREFIX)/lib/libz.a
SZIP_LIBRARY = $(INSTALL_PREFIX)/lib/libsz.a
HDF5_LIBRARY = $(INSTALL_PREFIX)/lib/libhdf5.a


BUILD_DIR = build
HDF5_VERSIONS = 1.14.2 # 1.14.2 1.10.10
HDF5_TARBALLS = $(patsubst %, HDF5-%-Emscripten.tar.gz, $(HDF5_VERSIONS))
PRIVATE_LIBS = Libs.private: -lm -ldl -lz -lsz -lhdf5

all: $(HDF5_TARBALLS)

$(ZLIB_LIBRARY):
	mkdir -p build;
	emcmake cmake -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) -S cmake/libz -B build/libz;
	cmake --build build/libz;
	cmake --install build/libz;

zlib: $(ZLIB_LIBRARY)

$(SZIP_LIBRARY):
	mkdir -p build;
	emcmake cmake -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) -S cmake/libaec -B build/libaec;
	cmake --build build/libaec -j8;
	cmake --install build/libaec;

szip: $(SZIP_LIBRARY)

HDF5-%-Emscripten.tar.gz: szip zlib
	rm -f "$(INSTALL_PREFIX)/lib/libhdf5*";
	rm -f "$(INSTALL_PREFIX)/include/libhdf5*";
	emcmake cmake -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) -DHDF5_VERSION=$(*) -S cmake/libhdf5 -B $(BUILD_DIR)/$(*);
	cmake --build $(BUILD_DIR)/$(*) -j8;
	cmake --install $(BUILD_DIR)/$(*);
	sed -i -- 's/;.*libz\.a/;$${_IMPORT_PREFIX}\/lib\/libz.a/g' $(INSTALL_PREFIX)/cmake/hdf5-targets.cmake;
	cp CMakeLists_dist.txt $(INSTALL_PREFIX)/CMakeLists.txt;
	cd $(INSTALL_PREFIX) && tar -cvzf ../$@ *;


shasum: $(HDF5_TARBALLS)
	@for t in $(HDF5_TARBALLS); do shasum -a 256 $$t; done;

clean:
	rm -rf $(BUILD_DIR)
	rm -f *-Emscripten.tar.gz;
	rm -rf dist;
	rm -rf build;