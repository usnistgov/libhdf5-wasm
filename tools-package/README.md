# HDF5 WASM Tools

This package provides command-line tools for working with HDF5 files, compiled to WebAssembly (WASM).

These are redistributions of tools originally provided by [The HDF Group](https://www.hdfgroup.org/) 
as part of the [HDF5 library](https://github.com/HDFGroup/hdf5), compiled to WASM for use in JavaScript environments.

This package is part of the larger [libhdf5-wasm](https://github.com/usnistgov/libhdf5-wasm) project which provides WASM-compiled HDF5 libraries for re-use in other projects

These tools have **no system dependencies**:
- statically linked to a WASM-compiled version of the HDF5 library
- do not require a system installation of HDF5 to run.

## Requirements

- Node.js or Bun runtime
- **Note**: Deno is not currently supported

## Installation

```bash
npm install hdf5-wasm-tools
```

## Usage

After installation, the tools can be run directly from the command line, e.g.
```bash
npx h5dump myfile.h5
```

```bash
npx h5repack -f GZIP -l 5 input.h5 output.h5
```

## Compression Filters

**Built-in Support**: GZIP and SZIP compression filters are compiled in and available by default.

**Additional Filters**: To enable support for additional compression filters (such as LZF, Blosc, etc.), install the companion package [h5wasm-plugins](https://www.npmjs.com/package/h5wasm-plugins) :

```bash
npm install h5wasm-plugins
```

Once installed in the same project, the tools will automatically detect and use the available compression filters.
