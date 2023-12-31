function(swift_get_linker_search_paths var)
  if(APPLE)
    set(SDK_FLAGS "-sdk" "${CMAKE_OSX_SYSROOT}")
  endif()

  execute_process(
    COMMAND ${CMAKE_Swift_COMPILER} ${SDK_FLAGS} -print-target-info
    OUTPUT_VARIABLE SWIFT_TARGET_INFO
  )

  string(JSON SWIFT_TARGET_PATHS GET ${SWIFT_TARGET_INFO} "paths")

  string(JSON SWIFT_TARGET_LIBRARY_PATHS GET ${SWIFT_TARGET_PATHS} "runtimeLibraryPaths")
  string(JSON SWIFT_TARGET_LIBRARY_PATHS_LENGTH LENGTH ${SWIFT_TARGET_LIBRARY_PATHS})
  math(EXPR SWIFT_TARGET_LIBRARY_PATHS_LENGTH "${SWIFT_TARGET_LIBRARY_PATHS_LENGTH} - 1 ")

  string(JSON SWIFT_TARGET_LIBRARY_IMPORT_PATHS GET ${SWIFT_TARGET_PATHS} "runtimeLibraryImportPaths")
  string(JSON SWIFT_TARGET_LIBRARY_IMPORT_PATHS_LENGTH LENGTH ${SWIFT_TARGET_LIBRARY_IMPORT_PATHS})
  math(EXPR SWIFT_TARGET_LIBRARY_IMPORT_PATHS_LENGTH "${SWIFT_TARGET_LIBRARY_IMPORT_PATHS_LENGTH} - 1 ")

  string(JSON SWIFT_SDK_IMPORT_PATH ERROR_VARIABLE errno GET ${SWIFT_TARGET_PATHS} "sdkPath")

  foreach(JSON_ARG_IDX RANGE ${SWIFT_TARGET_LIBRARY_PATHS_LENGTH})
    string(JSON SWIFT_LIB GET ${SWIFT_TARGET_LIBRARY_PATHS} ${JSON_ARG_IDX})
    list(APPEND SWIFT_LIBRARY_SEARCH_PATHS ${SWIFT_LIB})
  endforeach()

  foreach(JSON_ARG_IDX RANGE ${SWIFT_TARGET_LIBRARY_IMPORT_PATHS_LENGTH})
    string(JSON SWIFT_LIB GET ${SWIFT_TARGET_LIBRARY_IMPORT_PATHS} ${JSON_ARG_IDX})
    list(APPEND SWIFT_LIBRARY_SEARCH_PATHS ${SWIFT_LIB})
  endforeach()

  if(SWIFT_SDK_IMPORT_PATH)
    list(APPEND SWIFT_LIBRARY_SEARCH_PATHS ${SWIFT_SDK_IMPORT_PATH})
  endif()

  set(${var} ${SWIFT_LIBRARY_SEARCH_PATHS} PARENT_SCOPE)
endfunction()

# FIXME: share code with the function above
function(swift_get_resource_path var)
  if(APPLE)
    set(SDK_FLAGS "-sdk" "${CMAKE_OSX_SYSROOT}")
  endif()

  execute_process(
    COMMAND ${CMAKE_Swift_COMPILER} ${SDK_FLAGS} -print-target-info
    OUTPUT_VARIABLE SWIFT_TARGET_INFO
  )

  string(JSON SWIFT_TARGET_PATHS GET ${SWIFT_TARGET_INFO} "paths")
  string(JSON SWIFT_RUNTIME_RESOURCE_PATH GET ${SWIFT_TARGET_PATHS} "runtimeResourcePath")
  set(${var} ${SWIFT_RUNTIME_RESOURCE_PATH} PARENT_SCOPE)
endfunction()
