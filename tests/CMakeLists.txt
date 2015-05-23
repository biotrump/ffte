#######################################################################
#  This is the makefile to create a library for the NUFFT.
#  The files are grouped as follows:
#
#       SNUFFT1 -- Single precision real NUFFT routines
#       CNUFFT1 -- Single precision complex NUFFT routines
#       DNUFFT1 -- Double precision real NUFFT routines
#       ZNUFFT1 -- Double precision complex NUFFT routines
#
#       CB1AUX -- Real NUFFT routines called by complex routines
#       ZB1AUX -- D.P. real NUFFT routines called by d.p. complex
#                 routines
#
#      ALLNUFFT -- Auxiliary routines for Level 2 and 3 NUFFT
#
#
#  The library can be set up to include routines for any combination
#  of the four precisions.  To create or add to the library, enter make
#  followed by one or more of the precisions desired.  Some examples:
#       make single
#       make single complex
#       make single double complex complex16
#  Note that these commands are not safe for parallel builds.
#
#  Alternatively, the commands
#       make all
#  or
#       make
#  without any arguments creates a library of all four precisions.
#  The name of the library is held in NUFFTLIB, which is set in the
#  top-level make.inc
#
#  To remove the object files after the library is created, enter
#       make clean
#  To force the source files to be recompiled, enter, for example,
#       make single FRC=FRC
#
#---------------------------------------------------------------------
#
#  Edward Anderson, University of Tennessee
#  March 26, 1990
#  Susan Ostrouchov, Last updated September 30, 1994
#  ejr, May 2006.
#
#######################################################################
#libffte.a : ffte
macro(add_ffte_test name src lib)
#  get_filename_component(baseNAME ${src} NAME_WE)
#  set(baseNAME "demo")
#  set(TEST_INPUT "${NUFFT_SOURCE_DIR}/${baseNAME}.in")
  add_executable(${name} ${src})
  target_link_libraries(${name} ${lib})
#  if(EXISTS "${TEST_INPUT}")
#    add_test(NAME NUFFT-${name} COMMAND "${CMAKE_COMMAND}"
#      -DTEST=$<TARGET_FILE:${name}>
#      -DINPUT=${TEST_INPUT}
#      -DINTDIR=${CMAKE_CFG_INTDIR}
#      -P "${NUFFT_SOURCE_DIR}/TESTING/runtest.cmake")
#    else()
#      add_test(NAME NUFFT-${name} COMMAND "${CMAKE_COMMAND}"
#        -DTEST=$<TARGET_FILE:${name}>
#        -DINTDIR=${CMAKE_CFG_INTDIR}
#        -P "${NUFFT_SOURCE_DIR}/TESTING/runtest.cmake")
#    endif()
endmacro(add_ffte_test)

#option(BUILD_SINGLE "Build NUFFT SINGLE" ON)
#option(BUILD_DOUBLE "Build NUFFT DOUBLE" ON)
#option(BUILD_COMPLEX "Build NUFFT COMPLEX" ON)
#option(BUILD_COMPLEX16 "Build NUFFT COMPLEX16" ON)


if(BUILD_SINGLE)
if(BUILD_FFTE_GENERIC)
  add_ffte_test(test1d test1d.f ffte)
  add_ffte_test(test2d test2d.f ffte)
  add_ffte_test(test3d test3d.f ffte)
  add_ffte_test(rtest2d rtest2d.f ffte)
  add_ffte_test(rtest3d rtest3d.f ffte)
  add_ffte_test(speed1d speed1d.f ffte)
  add_ffte_test(speed2d speed2d.f ffte)
  add_ffte_test(speed3d speed3d.f ffte)
  add_ffte_test(rspeed2d rspeed2d.f ffte)
  add_ffte_test(rspeed3d rspeed3d.f ffte)
endif()
if(BUILD_FFTE_VEC)
  add_ffte_test(test1d_vec test1d.f ffte_vec)
  add_ffte_test(test2d_vec test2d.f ffte_vec)
  add_ffte_test(test3d_vec test3d.f ffte_vec)
  add_ffte_test(rtest2d_vec rtest2d.f ffte_vec)
  add_ffte_test(rtest3d_vec rtest3d.f ffte_vec)
  add_ffte_test(speed1d_vec speed1d.f ffte_vec)
  add_ffte_test(speed2d_vec speed2d.f ffte_vec)
  add_ffte_test(speed3d_vec speed3d.f ffte_vec)
  add_ffte_test(rspeed2d_vec rspeed2d.f ffte_vec)
  add_ffte_test(rspeed3d_vec rspeed3d.f ffte_vec)
endif()
if(BUILD_FFTE_CUDA)
  add_ffte_test(test1d_cuda test1d.f ffte_cuda)
  add_ffte_test(test2d_cuda test2d.f ffte_cuda)
  add_ffte_test(test3d_cuda test3d.f ffte_cuda)
  add_ffte_test(rtest2d_cuda rtest2d.f ffte_cuda)
  add_ffte_test(rtest3d_cuda rtest3d.f ffte_cuda)
  add_ffte_test(speed1d_cuda speed1d.f ffte_cuda)
  add_ffte_test(speed2d_cuda speed2d.f ffte_cuda)
  add_ffte_test(speed3d_cuda speed3d.f ffte_cuda)
  add_ffte_test(rspeed2d_cuda rspeed2d.f ffte_cuda)
  add_ffte_test(rspeed3d_cuda rspeed3d.f ffte_cuda)
endif()

endif()

#if(BUILD_DOUBLE)
#endif()

#if(BUILD_COMPLEX)
#endif()

if(BUILD_COMPLEX16)
if(BUILD_FFTE_GENERIC)
  add_ffte_test(test1d test1d.f ffte)
  add_ffte_test(test2d test2d.f ffte)
  add_ffte_test(test3d test3d.f ffte)
  add_ffte_test(rtest2d rtest2d.f ffte)
  add_ffte_test(rtest3d rtest3d.f ffte)
  add_ffte_test(speed1d speed1d.f ffte)
  add_ffte_test(speed2d speed2d.f ffte)
  add_ffte_test(speed3d speed3d.f ffte)
  add_ffte_test(rspeed2d rspeed2d.f ffte)
  add_ffte_test(rspeed3d rspeed3d.f ffte)
endif()
if(BUILD_FFTE_VEC)
  add_ffte_test(test1d_vec test1d.f ffte_vec)
  add_ffte_test(test2d_vec test2d.f ffte_vec)
  add_ffte_test(test3d_vec test3d.f ffte_vec)
  add_ffte_test(rtest2d_vec rtest2d.f ffte_vec)
  add_ffte_test(rtest3d_vec rtest3d.f ffte_vec)
  add_ffte_test(speed1d_vec speed1d.f ffte_vec)
  add_ffte_test(speed2d_vec speed2d.f ffte_vec)
  add_ffte_test(speed3d_vec speed3d.f ffte_vec)
  add_ffte_test(rspeed2d_vec rspeed2d.f ffte_vec)
  add_ffte_test(rspeed3d_vec rspeed3d.f ffte_vec)
endif()
if(BUILD_FFTE_CUDA)
  add_ffte_test(test1d_cuda test1d.f ffte_cuda)
  add_ffte_test(test2d_cuda test2d.f ffte_cuda)
  add_ffte_test(test3d_cuda test3d.f ffte_cuda)
  add_ffte_test(rtest2d_cuda rtest2d.f ffte_cuda)
  add_ffte_test(rtest3d_cuda rtest3d.f ffte_cuda)
  add_ffte_test(speed1d_cuda speed1d.f ffte_cuda)
  add_ffte_test(speed2d_cuda speed2d.f ffte_cuda)
  add_ffte_test(speed3d_cuda speed3d.f ffte_cuda)
  add_ffte_test(rspeed2d_cuda rspeed2d.f ffte_cuda)
  add_ffte_test(rspeed3d_cuda rspeed3d.f ffte_cuda)
endif()

endif()
