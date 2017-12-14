project (com.github.heiko-m.elememory)

cmake_minimum_required (VERSION 2.6)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

set (EXEC_NAME "com.github.heiko-m.elememory")
set (RELEASE_NAME "eleMemory 0.2")
set (VERSION "0.2")
set (VERSION_INFO "Alpha")

find_package (PkgConfig)

pkg_check_modules (DEPS REQUIRED
                   gtk+-3.0
                   granite
                   gio-2.0
                   json-glib-1.0
                  )

add_definitions (${DEPS_CFLAGS})
link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version("0.16" MINIMUM)

include (ValaPrecompile)
vala_precompile (VALA_C ${EXEC_NAME}
                 src/App.vala
                 src/Window.vala
                 src/Elememory.vala
                 src/Models/Game.vala
                 src/Models/Tile.vala
                 src/Models/Highscore.vala
                 src/Widgets/Header.vala
                 src/Widgets/StatsIndicator.vala
                 src/Widgets/Board.vala
                 src/Widgets/TileView.vala
                 src/Widgets/ToggleSwitch.vala
                 src/Widgets/ResultsDialog.vala
                 src/Widgets/HighscoreView.vala
                 src/Utils/FileUtils.vala

                 PACKAGES
                 gtk+-3.0
                 granite
                 gio-2.0
                 json-glib-1.0
                )

include (gresource)
glib_compile_resources (GLIB_RESOURCES_SCHEMES SOURCE data/tile-schemes.gresource.xml)

add_executable (${EXEC_NAME} ${VALA_C} ${GLIB_RESOURCES_SCHEMES})

add_subdirectory (icons)

install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.heiko-m.elememory.desktop DESTINATION ${DATADIR}/applications/)
