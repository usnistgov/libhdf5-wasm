# Function to convert a list of symbol names to Emscripten EXPORTED_FUNCTIONS format
# Usage: format_exported_functions(<input_list> <output_variable>)
# Example: format_exported_functions(MY_SYMBOLS MY_SYMBOLS_STRING)
function(format_exported_functions input_list output_var)
    # Make a copy of the input list to work with
    set(symbols ${${input_list}})
    
    # Add '_' prefix and wrap each symbol in single quotes
    list(TRANSFORM symbols PREPEND "'_")
    list(TRANSFORM symbols APPEND "'")
    
    # Join with comma and space, then wrap in brackets
    list(JOIN symbols ", " symbols_string)
    set(symbols_string "[${symbols_string}]")
    
    # Set the output variable in parent scope
    set(${output_var} "${symbols_string}" PARENT_SCOPE)
endfunction()

set (HDF5_PLUGIN_SYMBOLS)
list (APPEND HDF5_PLUGIN_SYMBOLS
    H5Fopen H5Fclose H5Fcreate H5open
    malloc calloc free memset memcpy memmove realloc
    htonl htons ntohl ntohs
    H5allocate_memory H5free_memory
    pthread_mutex_init posix_memalign strcmp strcpy sscanf getenv
    stdin stdout stderr clock_gettime
    strlen strdup snprintf iprintf
    pthread_create pthread_mutex_lock pthread_mutex_unlock pthread_atfork pthread_once
    pthread_cond_init pthread_barrier_init pthread_attr_init pthread_attr_setdetachstate
    H5Pget_chunk H5Tget_class H5Sget_simple_extent_dims
    H5Pget_filter_by_id2 H5Pmodify_filter H5Pexist
    H5Tget_size H5Tget_native_type H5Tget_order
    H5Epush2 siprintf getTempRet0 __wasm_setjmp
    H5E_ERR_CLS_g H5E_PLINE_g H5E_CANTINIT_g H5E_CANTGET_g H5E_CANTFILTER_g
    H5E_BADTYPE_g H5E_BADVALUE_g H5E_ARGS_g H5E_CALLBACK_g H5E_CANTREGISTER_g
    H5E_RESOURCE_g H5E_NOSPACE_g H5E_OVERFLOW_g H5E_READERROR_g
    H5Sis_simple H5Pfill_value_defined
    H5T_NATIVE_UINT_g H5T_STD_U32BE_g H5T_STD_U32LE_g H5T_NATIVE_UINT32_g
    H5T_STD_U64BE_g H5T_NATIVE_UINT64_g H5T_STD_U64LE_g H5P_CLS_DATASET_CREATE_ID_g
    frexp frexpf log10 ldexpf __THREW__ __threwValue
)

# Convert the symbol list to Emscripten format
format_exported_functions(HDF5_PLUGIN_SYMBOLS HDF5_PLUGIN_SYMBOLS_STRING)

# Results in variable HDF5_PLUGIN_SYMBOLS_STRING containing the symbols to export
# Use as: -s EXPORTED_FUNCTIONS="${HDF5_PLUGIN_SYMBOLS_STRING}"
# Or, to test adding new symbols:
# list(APPEND HDF5_PLUGIN_SYMBOLS foo bar baz)
# format_exported_functions(HDF5_PLUGIN_SYMBOLS HDF5_PLUGIN_SYMBOLS_STRING)