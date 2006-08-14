# This file defines the Feature Logging macros.
#
# MACRO_INIT_LOG_FEATURE()
#   Call this to initialize the feature logging facility.
#
# MACRO_LOG_FEATURE(VAR FEATURE DESCRIPTION URL [REQUIRED [MIN_VERSION [COMMENTS]]])
#   Logs the information so that it can be displayed at the end
#   of the configure run
#   VAR : TRUE or FALSE, indicating whether the feature is supported
#   FEATURE: name of the feature, e.g. "libjpeg"
#   DESCRIPTION: description what this feature provides
#   URL: home page
#   REQUIRED: TRUE or FALSE, indicating whether the featue is required
#   MIN_VERSION: minimum version number. empty string if unneeded
#   COMMENTS: More info you may want to provide.  empty string if unnecessary
#
# MACRO_DISPLAY_FEATURE_LOG()
#   Call this to display the collected results.
#   Exits CMake with a FATAL error message if a required feature is missing
#
# Example:
#
# INCLUDE(MacroLogFeature)
# MACRO_INIT_LOG_FEATURE()
#
# FIND_PACKAGE(JPEG)
# MACRO_LOG_FEATURE(JPEG_FOUND "libjpeg" "Support JPEG images" "http://www.ijg.org" TRUE "3.2a" "")
# ...
# MACRO_DISPLAY_FEATURE_LOG()



MACRO(MACRO_LOG_FEATURE _var _package _description _url ) # _required _minvers _comments)

   SET(_required "${ARGV4}")
   SET(_minvers "${ARGV5}")
   SET(_comments "${ARGV6}")

   IF (${_var})
     SET(_LOGFILENAME ${CMAKE_BINARY_DIR}/EnabledFeatures.txt )
   ELSE (${_var})
     IF (${_required} MATCHES "[Tt][Rr][Uu][Ee]")
       SET(_LOGFILENAME ${CMAKE_BINARY_DIR}/MissingRequirements.txt)
     ELSE (${_required} MATCHES "[Tt][Rr][Uu][Ee]")
       SET(_LOGFILENAME ${CMAKE_BINARY_DIR}/DisabledFeatures.txt)
     ENDIF (${_required} MATCHES "[Tt][Rr][Uu][Ee]")
   ENDIF (${_var})

   IF (NOT EXISTS ${_LOGFILENAME})
     FILE(WRITE ${_LOGFILENAME} "\n")
   ENDIF (NOT EXISTS ${_LOGFILENAME})

   FILE(APPEND "${_LOGFILENAME}" "=======================================\n")
   FILE(APPEND "${_LOGFILENAME}" "PACKAGE:     ${_package}\n")
   FILE(APPEND "${_LOGFILENAME}" "DESCRIPTION: ${_description}\n")
   FILE(APPEND "${_LOGFILENAME}" "URL:         ${_url}\n")
   IF (${_minvers} MATCHES ".*")
     FILE(APPEND "${_LOGFILENAME}" "VERSION:     ${_minvers}\n")
   ENDIF (${_minvers} MATCHES ".*")
   IF (${_comments} MATCHES ".*")
     FILE(APPEND "${_LOGFILENAME}" "COMMENTS:    ${_comments}\n")
   ENDIF (${_comments} MATCHES ".*")
 
ENDMACRO(MACRO_LOG_FEATURE)


MACRO(MACRO_INIT_LOG_FEATURE)

   SET(_file ${CMAKE_BINARY_DIR}/MissingRequirements.txt )
   IF (EXISTS ${_file})
      FILE(REMOVE ${_file})
   ENDIF (EXISTS ${_file})

   SET(_file ${CMAKE_BINARY_DIR}/EnabledFeatures.txt )
   IF (EXISTS ${_file})
      FILE(REMOVE ${_file})
   ENDIF (EXISTS ${_file})

   SET(_file ${CMAKE_BINARY_DIR}/DisabledFeatures.txt )
   IF (EXISTS ${_file})
      FILE(REMOVE ${_file})
   ENDIF (EXISTS ${_file})

ENDMACRO(MACRO_INIT_LOG_FEATURE)

MACRO(MACRO_DISPLAY_FEATURE_LOG)

   SET(_file ${CMAKE_BINARY_DIR}/MissingRequirements.txt )
   IF (EXISTS ${_file})
      FILE(APPEND ${_file} "=======================================")
      FILE(READ ${_file} _requirements)
      MESSAGE(STATUS "\nMissing Requirements:${_requirements}")
      FILE(REMOVE ${_file})
      MESSAGE(FATAL_ERROR "Exiting: Missing Requirements")
   ENDIF (EXISTS ${_file})

   SET(_file ${CMAKE_BINARY_DIR}/EnabledFeatures.txt )
   IF (EXISTS ${_file})
      FILE(APPEND ${_file} "=======================================")
      FILE(READ ${_file} _enabled)
      MESSAGE(STATUS "\nEnabled Features:${_enabled}")
      FILE(REMOVE ${_file})
   ENDIF (EXISTS ${_file})

   SET(_file ${CMAKE_BINARY_DIR}/DisabledFeatures.txt )
   IF (EXISTS ${_file})
      FILE(APPEND ${_file} "=======================================")
      FILE(READ ${_file} _disabled)
      MESSAGE(STATUS "\nDisabled Features:${_disabled}")
      FILE(REMOVE ${_file})
   ENDIF (EXISTS ${_file})

ENDMACRO(MACRO_DISPLAY_FEATURE_LOG)
