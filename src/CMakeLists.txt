#######################################################################
#  This is the makefile to create a library for the FFTE.
#  The files are grouped as follows:
#
#       SFFTE1 -- Single precision real FFTE routines
#       CFFTE1 -- Single precision complex FFTE routines
#       DFFTE1 -- Double precision real FFTE routines
#       ZFFTE1 -- Double precision complex FFTE routines
#
#       CB1AUX -- Real FFTE routines called by complex routines
#       ZB1AUX -- D.P. real FFTE routines called by d.p. complex
#                 routines
#
#      ALLFFTE -- Auxiliary routines for Level 2 and 3 FFTE
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
#  The name of the library is held in FFTELIB, which is set in the
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

#---------------------------------------------------------
#  Comment out the next 6 definitions if you already have
#  the Level 1 FFTE.
#---------------------------------------------------------
#    cuzfft1d.f : 1-D complex FFT routine (for NVIDIA GPUs)
#    cuzfft2d.f : 2-D complex FFT routine (for NVIDIA GPUs)
#    cuzfft3d.f : 3-D complex FFT routine (for NVIDIA GPUs)
#    cuztrans.f : Transposition routine (for NVIDIA GPUs)
#    dzfft2d.f  : 2-D real-to-complex FFT routine
#    dzfft3d.f  : 3-D real-to-complex FFT routine
#    factor.f   : Factorization routine
#    fft235.f   : Radix-2,3,4,5 and 8 FFT routine
#    kernel.f   : Radix-2,3,4,5 and 8 FFT kernel routine
#    mfft235.f  : Radix-2,3,4,5 and 8 multiple FFT routine
#    param.h    : Header file for parameters
#    readme.txt : Readme file
#    vzfft1d.f  : 1-D complex FFT routine (for vector machines)
#    vzfft2d.f  : 2-D complex FFT routine (for vector machines)
#    vzfft3d.f  : 3-D complex FFT routine (for vector machines)
#    zdfft2d.f  : 2-D complex-to-real FFT routine
#    zdfft3d.f  : 3-D complex-to-real FFT routine
#    zfft1d.f   : 1-D complex FFT routine
#    zfft2d.f   : 2-D complex FFT routine
#    zfft3d.f   : 3-D complex FFT routine


#test1d.o vzfft1d.o mfft235.o fft235.o kernel.o factor.o
set(ZFFTE_VEC vzfft1d.f vzfft2d.f vzfft3d.f mfft235.f fft235.f kernel.f factor.f)
#cutest1d.o cuzfft1d.o factor.o cuztrans.o
set(ZFFTE_CUDA cuzfft1d.f cuzfft2d.f cuzfft3d.f factor.f cuztrans.f)
#zfft1d.o fft235.o kernel.o factor.o
set(ZFFTE zfft1d.f zfft2d.f zfft3d.f dzfft2d.f dzfft3d.f
	zdfft2d.f zdfft3d.f fft235.f kernel.f factor.f)

#---------------------------------------------------------------------
#  The following line defines auxiliary routines needed by both the
#  Level 2 and Level 3 BLAS.  Comment it out only if you already have
#  both the Level 2 and 3 BLAS.
#---------------------------------------------------------------------
#set(ALLBLAS  lsame.f xerbla.f xerbla_array.f)

# default build all of it
set(ALLOBJS ${ZFFTE})
set(ALLOBJS_VEC ${ZFFTE_VEC})
set(ALLOBJS_CUDA ${ZFFTE_CUDA})

#option(FFTE_SINGLE "Build FFTE SINGLE" ON)
#option(FFTE_DOUBLE "Build FFTE DOUBLE" ON)
#option(FFTE_COMPLEX "Build FFTE COMPLEX" ON)
#option(FFTE_COMPLEX16 "Build FFTE COMPLEX16" ON)

if(FFTE_SINGLE)
  set(ALLOBJS ${SFFTE})
  set(ALLOBJS_VEC ${SFFTE_VEC})
  set(ALLOBJS_CUDA ${SFFTE_CUDA})
endif()
if(FFTE_DOUBLE)
  set(ALLOBJS ${DFFTE})
  set(ALLOBJS_VEC ${DFFTE_VEC})
  set(ALLOBJS_CUDA ${DFFTE_CUDA})
endif()
if(FFTE_COMPLEX)
  set(ALLOBJS ${CFFTE})
  set(ALLOBJS_VEC ${CFFTE_VEC})
  set(ALLOBJS_CUDA ${CFFTE_CUDA})
endif()
if(FFTE_COMPLEX16)
  set(ALLOBJS ${ZFFTE})
  set(ALLOBJS_VEC ${ZFFTE_VEC})
  set(ALLOBJS_CUDA ${ZFFTE_CUDA})
endif()

if(BUILD_FFTE_GENERIC)
add_library(ffte ${ALLOBJS})
endif()
if(BUILD_FFTE_VEC)
add_library(ffte_vec ${ALLOBJS_VEC})
endif()
if(BUILD_FFTE_CUDA)
add_library(ffte_cuda ${ALLOBJS_CUDA})
endif()

if(UNIX)
	if(BUILD_FFTE_GENERIC)
		target_link_libraries(ffte m)
	endif()
	if(BUILD_FFTE_VEC)
		target_link_libraries(ffte_vec m)
	endif()
	if(BUILD_FFTE_CUDA)
		target_link_libraries(ffte_cuda m)
	endif()
endif()

if(ANDROID_NDK)
  target_link_libraries(ffte m)
  target_link_libraries(ffte_vec m)
  target_link_libraries(ffte_cuda m)
endif(ANDROID_NDK)

#target_link_libraries(ffte)
if(BUILD_FFTE_GENERIC)
ffte_install_library(ffte)
endif()
if(BUILD_FFTE_VEC)
ffte_install_library(ffte_vec)
endif()
if(BUILD_FFTE_CUDA)
ffte_install_library(ffte_cuda)
endif()