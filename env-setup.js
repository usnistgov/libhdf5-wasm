// Set up environment variables from process.env for Emscripten
var Module = typeof Module !== 'undefined' ? Module : {};

// Hook into Module initialization to set up environment
Module['preRun'] = Module['preRun'] || [];
Module['preRun'].push(function() {
  if (typeof process !== 'undefined') {
    // Determine the default plugin path relative to the script location
    var defaultPluginPath = null;
    if (typeof __dirname !== 'undefined') {
      // When installed: __dirname is node_modules/hdf5-wasm-tools/bin
      // We want to look for plugins at: node_modules/h5wasm-plugins/plugins
      var path = require('path');
      defaultPluginPath = path.join(__dirname, '..', '..', 'h5wasm-plugins', 'plugins');
    }

    // Get the plugin path from environment or use default
    var pluginPath = (process.env && process.env.HDF5_PLUGIN_PATH) || defaultPluginPath;

    if (pluginPath) {
      // Set in ENV object (for Node.js/Emscripten)
      if (typeof ENV !== 'undefined') {
        ENV['HDF5_PLUGIN_PATH'] = pluginPath;
      }

      // Also set in process.env for Bun and other runtimes
      if (process.env) {
        process.env.HDF5_PLUGIN_PATH = pluginPath;
      }
    }
  }
});

