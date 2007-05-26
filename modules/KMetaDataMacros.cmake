# This file contains the following macros:
#
# KMETADATA_GENERATE_FROM_ONTOLOGY
#


#
# KMETADATA_GENERATE_FROM_ONTOLOGY
# (C) 2007 Sebastian Trueg <trueg@kde.org>
#
# Parameters:
#   ontofile     - Path to the NRL ontology defining the resources to be generated.
#   targetdir    - Folder to which the generated sources should be written.
#   out_headers  - Variable which will be filled with the names of all generated headers.
#   out_sources  - Variable which will be filled with the names of all generated sources.
#   out_includes - Variable which will be filled with complete include statements of all 
#                  generated resource classes.
#
# In addition to the parameters an arbitrary number of template filenames can be set as arguments
#
macro(KMETADATA_GENERATE_FROM_ONTOLOGY ontofile targetdir out_headers out_sources out_includes)

  FIND_PROGRAM(RCGEN kmetadata_rcgen PATHS ${BIN_INSTALL_DIR})
  if(RCGEN-NOTFOUND)
    message( FATAL_ERROR "Failed to find the KMetaData source generator" )
  endif(RCGEN-NOTFOUND)

  FILE(TO_NATIVE_PATH ${RCGEN} RCGEN)

  execute_process(
    COMMAND ${RCGEN} --listheaders --prefix ${targetdir}/ --ontologies ${ontofile}
    OUTPUT_VARIABLE ${out_headers}
    )
  
  execute_process(
    COMMAND ${RCGEN} --listsources --prefix ${targetdir}/ --ontologies ${ontofile}
    OUTPUT_VARIABLE ${out_sources}
    )
  
  execute_process(
    COMMAND ${RCGEN} --listincludes --ontologies ${ontofile}
    OUTPUT_VARIABLE ${out_includes}
    )

  execute_process(
    COMMAND ${RCGEN} --writeall --templates ${ARGN} --target ${targetdir}/ --ontologies ${ontofile}
    )
  
endmacro(KMETADATA_GENERATE_FROM_ONTOLOGY)
