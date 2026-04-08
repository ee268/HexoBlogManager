cmake_minimum_required(VERSION 3.16)

project(BlogManager VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Core5Compat QuickControls2 WebEngineQuick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appBlogManager
    main.cpp
    include/carouselloader.h
    src/carouselloader.cpp
    include/systemThemeHelper.h
    src/systemThemeHelper.cpp
    qml.qrc
    res.qrc
)

qt_add_resources(
    RES
    qml.qrc
    res.qrc
)

qt_add_qml_module(appBlogManager
    URI BlogManager
    VERSION 1.0
    SOURCES ${RES}
    QML_FILES
        Main.qml
        SOURCES include/processImport.h
        SOURCES src/processImport.cpp
        SOURCES include/blogMgr.h
        SOURCES src/blogMgr.cpp
        SOURCES include/frontMatterMgr.h
        SOURCES src/frontMatterMgr.cpp
        SOURCES include/global.h
        SOURCES src/global.cpp
        SOURCES include/processUpload.h
        SOURCES src/processUpload.cpp
        SOURCES src/ymlConfig.cpp
        SOURCES include/ymlConfig.h
        SOURCES
        SOURCES src/dateListModel.cpp
        SOURCES include/dateListModel.h
        SOURCES include/ymlTreeModel.h
        SOURCES src/ymlTreeModel.cpp
        SOURCES include/imgDownloader.h
        SOURCES src/imgDownloader.cpp
        SOURCES include/systemThemeHelper.h
        SOURCES src/systemThemeHelper.cpp
        SOURCES include/singleton.h
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.

set_target_properties(appBlogManager PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appBlogManager
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# 链接yaml-cpp
target_include_directories(appBlogManager PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_link_directories(appBlogManager PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib)

target_link_libraries(appBlogManager PRIVATE
    Qt6::Quick
    Qt6::Core5Compat
    Qt6::QuickControls2
    Qt6::WebEngineQuick
    yaml-cpp
)
target_link_libraries(appBlogManager PRIVATE Qt6::Core)

include(GNUInstallDirs)
install(TARGETS appBlogManager
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
