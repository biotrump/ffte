cmake_minimum_required(VERSION 2.8.10)
project(FFTE Fortran)

set(FFTE_VERSION 6.0.0)

# Configure the warning and code coverage suppression file
configure_file(
  "${FFTE_SOURCE_DIR}/CTestCustom.cmake.in"
  "${FFTE_BINARY_DIR}/CTestConfig.cmake"
  COPYONLY
)

# Add the CMake directory for custon CMake modules
set(CMAKE_MODULE_PATH "${FFTE_SOURCE_DIR}/CMAKE" ${CMAKE_MODULE_PATH})

#F95, F90, F77
#option(FFTE_F90 "Build FFTE by fortran F90" ON)
option(BUILD_FFTE_GENERIC "Build Generic MACHINE FFTE" ON)
option(BUILD_FFTE_VEC "Build VECTOR MACHINE FFTE" OFF)
option(BUILD_FFTE_NEON "Build ARM NEON MACHINE FFTE" OFF)
option(BUILD_FFTE_CUDA "Build CUDA MACHINE FFTE" OFF)

if(ANDROID_NDK)
	# export FC=/path/to/android-ndk-r9/toolchains/arm-linux-androideabi-4.8.0/prebuilt/linux-x86/bin/arm-linux-androideabi-gfortran
	message ("**** CMAKE_Fortran_COMPILER full path: " ${CMAKE_Fortran_COMPILER})
	get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)
	if (Fortran_COMPILER_NAME MATCHES "gfortran.*")
		# gfortran
		message ("*** Fortran compiler: " ${Fortran_COMPILER_NAME})
		set (CMAKE_Fortran_FLAGS_RELEASE "-funroll-all-loops -fPIE -pie -fPIC -fno-f2c -O3")
		set (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -fPIE -pie -fPIC -g")
	else (Fortran_COMPILER_NAME MATCHES "gfortran.*")
		message ("CMAKE_Fortran_COMPILER full path: " ${CMAKE_Fortran_COMPILER})
		message ("Fortran compiler: " ${Fortran_COMPILER_NAME})
		message ("No optimized Fortran compiler flags are known, we just try -O2...")
		set (CMAKE_Fortran_FLAGS_RELEASE "-O2")
		set (CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g")
	endif (Fortran_COMPILER_NAME MATCHES "gfortran.*")
else(ANDROID_NDK)
	message ("*** Fortran compiler: " ${Fortran_COMPILER_NAME})
	if (UNIX)
	#unix, linux
		if ( "${CMAKE_Fortran_COMPILER}" MATCHES "ifort" )
			set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fltconsistency -fp_port" )
		endif ()
		if ( "${CMAKE_Fortran_COMPILER}" MATCHES "xlf" )
			set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qnosave -qstrict=none" )
		endif ()
		# Delete libmtsk in linking sequence for Sun/Oracle Fortran Compiler.
		# This library is not present in the Sun package SolarisStudio12.3-linux-x86-bin
		STRING(REPLACE \;mtsk\; \; CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES "${CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES}")

		if(BUILD_FFTE_GENERIC)
			set( CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS} -O3 -fomit-frame-pointer -fopenmp" )
			set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS} -O0 -g -fopenmp" )
		endif()
		if(BUILD_FFTE_VEC)
			set( CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS} -O3 -xAVX" )
			set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS} -O0 -g" )
		endif()
		if(BUILD_FFTE_CUDA)
			set( CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS} -fast -mp -Mcuda=cc3x,cuda5.5 -Minfo" )
			set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS} -O0 -g" )
		endif()
	endif ()
	message ("*** Fortran compiler RELEASE FLAGS: " ${CMAKE_Fortran_FLAGS_RELEASE})
	message ("*** Fortran compiler DEBUG FLAGS: " ${CMAKE_Fortran_FLAGS_DEBUG})
endif(ANDROID_NDK)

# Get Python
IF(WIN32 AND NOT UNIX)
find_package(PythonInterp)
message(STATUS "Looking for Python found - ${PYTHONINTERP_FOUND}")
if (PYTHONINTERP_FOUND)
   message(STATUS "Using Python version ${PYTHON_VERSION_STRING}")
endif()
ENDIF(WIN32 AND NOT UNIX)

# --------------------------------------------------
#install all .a, .so to ffte/lib
set(FFTE_INSTALL_EXPORT_NAME ffte-targets)

macro(ffte_install_library lib)
  install(TARGETS ${lib}
    EXPORT ${FFTE_INSTALL_EXPORT_NAME}
    ARCHIVE DESTINATION lib${LIB_SUFFIX}
    LIBRARY DESTINATION lib${LIB_SUFFIX}
    RUNTIME DESTINATION bin
  )
endmacro()

# --------------------------------------------------
# Testing

enable_testing()
#BUILD_TESTING is turned ON by enable_testing()
include(CTest)
enable_testing()
# --------------------------------------------------

# Organize output files.  On Windows this also keeps .dll files next
# to the .exe files that need them, making tests easy to run.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${FFTE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${FFTE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${FFTE_BINARY_DIR}/lib)

# --------------------------------------------------
# Check for any necessary platform specific compiler flags
include( CheckFFTECompilerFlags )
CheckFFTECompilerFlags()

# --------------------------------------------------
# Precision to build
# By default all precisions are generated

# --------------------------------------------------
# Subdirectories that need to be processed

# --------------------------------------------------
# CFFTE
option(CFFTE "Build CFFTE" OFF)

if(CFFTE)
  add_subdirectory(CFFTE)
endif(CFFTE)

#FFTE
set( FFTE_LIBRARIES ffte )
option(BUILD_SINGLE "Build FFTE Single Precision" OFF)
option(BUILD_DOUBLE "Build FFTE Double Precision" OFF)
option(BUILD_COMPLEX "Build FFTE Complex Precision" OFF)
option(BUILD_COMPLEX16 "Build FFTE Double Complex Precision" ON)
add_subdirectory(src)

message(STATUS "BUILD TESTING : ${BUILD_TESTING}" )
if(BUILD_TESTING)
	add_subdirectory(tests)
endif(BUILD_TESTING)

# --------------------------------------------------
# CPACK Packaging

SET(CPACK_PACKAGE_NAME "FFTE")
SET(CPACK_PACKAGE_VENDOR "The Courant Mathematics and Computing Laboratory (CMCL) is a research center \
						at the Courant Institute of New York University.")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "FFTE- Linear Algebra Package")
set(CPACK_PACKAGE_VERSION_MAJOR 1)
set(CPACK_PACKAGE_VERSION_MINOR 3)
set(CPACK_PACKAGE_VERSION_PATCH 2)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/readme.txt")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "FFTE")
IF(WIN32 AND NOT UNIX)
  # There is a bug in NSI that does not handle full unix paths properly. Make
  # sure there is at least one set of four (4) backlasshes.
  SET(CPACK_NSIS_HELP_LINK "http:\\\\\\\\http://www.cims.nyu.edu/cmcl/ffte/ffte.html")
  SET(CPACK_NSIS_URL_INFO_ABOUT "http:\\\\\\\\www.cims.nyu.edu/cmcl/ffte/ffte.html")
  SET(CPACK_NSIS_CONTACT "thomas@biotrump.com")
  SET(CPACK_NSIS_MODIFY_PATH ON)
  SET(CPACK_NSIS_DISPLAY_NAME "FFTE-${FFTE_VERSION}")
  set(CPACK_PACKAGE_RELOCATABLE "true")
ELSE(WIN32 AND NOT UNIX)
  SET(CPACK_GENERATOR "TGZ")
  SET(CPACK_SOURCE_GENERATOR TGZ)
  SET(CPACK_SOURCE_PACKAGE_FILE_NAME "ffte-${FFTE_VERSION}" )
  SET(CPACK_SOURCE_IGNORE_FILES ~$ .gitignore ${CPACK_SOURCE_IGNORE_FILES} )
ENDIF(WIN32 AND NOT UNIX)
INCLUDE(CPack)

# --------------------------------------------------
# By default static library
OPTION(BUILD_SHARED_LIBS "Build shared libraries" OFF )
OPTION(BUILD_STATIC_LIBS "Build static libraries" ON )
#OPTION(BUILD_SHARED_LIBS "Build shared libraries" ON )

if(NOT LATESTFFTE_FOUND)
  set(ALL_TARGETS ${ALL_TARGETS} ffte)
endif(NOT LATESTFFTE_FOUND)

# Export ffte targets, not including fftee, from the
# install tree, if any.
set(_ffte_config_install_guard_target "")
if(ALL_TARGETS)
  install(EXPORT ffte-targets
    DESTINATION lib/cmake/ffte-${FFTE_VERSION})

  # Choose one of the ffte targets to use as a guard for
  # ffte-config.cmake to load targets from the install tree.
  list(GET ALL_TARGETS 0 _ffte_config_install_guard_target)
endif()

# Include cffte in targets exported from the build tree.
if(CFFTE)
  set(ALL_TARGETS ${ALL_TARGETS} cffte)
endif(CFFTE)

# Export ffte and fftee targets from the build tree, if any.
set(_ffte_config_build_guard_target "")
if(ALL_TARGETS)
  export(TARGETS ${ALL_TARGETS} FILE ffte-targets.cmake)

  # Choose one of the ffte or fftee targets to use as a guard
  # for ffte-config.cmake to load targets from the build tree.
  list(GET ALL_TARGETS 0 _ffte_config_build_guard_target)
endif()

configure_file(${FFTE_SOURCE_DIR}/CMAKE/ffte-config-version.cmake.in
  ${FFTE_BINARY_DIR}/ffte-config-version.cmake @ONLY)
configure_file(${FFTE_SOURCE_DIR}/CMAKE/ffte-config-build.cmake.in
  ${FFTE_BINARY_DIR}/ffte-config.cmake @ONLY)


#configure_file(${CMAKE_CURRENT_SOURCE_DIR}/ffte.pc.in ${CMAKE_CURRENT_BINARY_DIR}/ffte.pc)
#  install(FILES
#  ${CMAKE_CURRENT_BINARY_DIR}/ffte.pc
#  DESTINATION ${PKG_CONFIG_DIR}
#   )

configure_file(${FFTE_SOURCE_DIR}/CMAKE/ffte-config-install.cmake.in
  ${FFTE_BINARY_DIR}/CMakeFiles/ffte-config.cmake @ONLY)
install(FILES
  ${FFTE_BINARY_DIR}/CMakeFiles/ffte-config.cmake
  ${FFTE_BINARY_DIR}/ffte-config-version.cmake
  DESTINATION lib/cmake/ffte-${FFTE_VERSION}
  )
