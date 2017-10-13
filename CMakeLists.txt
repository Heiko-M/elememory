project (elememory)

cmake_minimum_required (VERSION 2.6)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

set (PKGDATADIR "${DATADIR}/elememory")

set (EXEC_NAME "elememory")
set (RELEASE_NAME "eleMemory 0.1a")
set (VERSION "0.1a")
set (VERSION_INFO "Alpha version")

find_package (PkgConfig)

pkg_check_modules (DEPS REQUIRED
                   gtk+-3.0
                   granite
                  )

add_definitions (${DEPS_CFLAGS})
link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version("0.16" MINIMUM)

include (ValaPrecompile)
vala_precompile (VALA_C ${EXEC_NAME}
                 src/main.vala
                 src/elememory.vala
                 src/Window.vala
                 src/Widgets/Header.vala
                 src/Model.vala
                 src/tilefield.vala
                 src/tile.vala
                 src/fileutils.vala
                 src/Widgets/ToggleSwitch.vala

                 PACKAGES
                 gtk+-3.0
                 granite
                )

add_executable (${EXEC_NAME} ${VALA_C})

add_subdirectory (images)
add_subdirectory (icons)

install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/elememory.desktop DESTINATION ${DATADIR}/applications/)
