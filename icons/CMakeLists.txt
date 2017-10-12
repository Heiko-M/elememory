# App icons

install (FILES 48x48/elememory.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/48x48/apps)
install (FILES 16x16/tile-field-small.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/16x16/actions)
install (FILES 16x16/tile-field-medium.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/16x16/actions)
install (FILES 16x16/tile-field-large.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/16x16/actions)
install (FILES 16x16/elememory-highscore-symbolic.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/16x16/actions)
install (FILES 16x16/elememory-board-symbolic.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/16x16/actions)

install(
    CODE
        "execute_process (COMMAND gtk-update-icon-cache -t -f ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor)"
    CODE
        "message (STATUS \"Updated icon cache in ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor\")"
)
