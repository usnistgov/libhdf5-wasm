// Set up environment variables from process.env for Emscripten
var Module = typeof Module !== 'undefined' ? Module : {};

// Hook into Module initialization to set up environment
Module['preRun'] = Module['preRun'] || [];
Module['preRun'].push(function() {
  if (typeof process !== 'undefined') {
    // Use HDF5_PLUGIN_PATH from environment if set
    if (process.env && process.env.HDF5_PLUGIN_PATH) {
      ENV['HDF5_PLUGIN_PATH'] = process.env.HDF5_PLUGIN_PATH;
    }
    // Otherwise, set a default path relative to the script location
    else if (typeof __dirname !== 'undefined') {
      // When installed: __dirname is node_modules/hdf5-wasm-tools/bin
      // We want to look for plugins at: node_modules/h5wasm-plugins/plugins
      var path = require('path');
      var defaultPluginPath = path.join(__dirname, '..', '..', 'h5wasm-plugins', 'plugins');
      ENV['HDF5_PLUGIN_PATH'] = defaultPluginPath;
    }
  }
});
