INSTALL_PREFIX = $(realpath .)/dist
BUILD_DIR = build
HDF5_VERSIONS = 1.12.2 1.14.2 1.10.10
HDF5_TARBALLS = $(patsubst %, HDF5-%-Emscripten.tar.gz, $(HDF5_VERSIONS))

all: $(HDF5_TARBALLS)

HDF5-%-Emscripten.tar.gz:
	emcmake cmake -DCMAKE_INSTALL_PREFIX="$(INSTALL_PREFIX)/$(*)" -DHDF5_VERSION=$(*) -S . -B $(BUILD_DIR)/$(*);
	cmake --build $(BUILD_DIR)/$(*) --target zlibstatic;
	cmake --build $(BUILD_DIR)/$(*) --target sz_static;
	cmake --build $(BUILD_DIR)/$(*) -j8;
	cmake --install $(BUILD_DIR)/$(*);
	sed -i -- 's/;[^;]*libz\.a/;$${_IMPORT_PREFIX}\/lib\/libz.a/g' $(INSTALL_PREFIX)/$(*)/cmake/hdf5-targets.cmake;
	sed -i -- 's/;[^;]*libsz\.a/;$${_IMPORT_PREFIX}\/lib\/libsz.a/g' $(INSTALL_PREFIX)/$(*)/cmake/hdf5-targets.cmake;
	cp CMakeLists_dist.txt $(INSTALL_PREFIX)/CMakeLists.txt;
	cd $(INSTALL_PREFIX)/$(*) && tar -cvzf ../../$@ *;


shasum: $(HDF5_TARBALLS)
	@for t in $(HDF5_TARBALLS); do shasum -a 256 $$t; done;

clean:
	rm -rf $(BUILD_DIR)
	rm -f *-Emscripten.tar.gz;
	rm -rf dist;
	rm -rf build;