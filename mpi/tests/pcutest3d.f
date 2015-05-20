C
C     (C) COPYRIGHT SOFTWARE, 2000-2004, 2008-2014, ALL RIGHTS RESERVED
C                BY
C         DAISUKE TAKAHASHI
C         FACULTY OF ENGINEERING, INFORMATION AND SYSTEMS
C         UNIVERSITY OF TSUKUBA
C         1-1-1 TENNODAI, TSUKUBA, IBARAKI 305-8573, JAPAN
C         E-MAIL: daisuke@cs.tsukuba.ac.jp
C
C
C     PZFFT3D TEST PROGRAM (FOR NVIDIA GPUS)
C
C     CUDA FORTRAN + MPI SOURCE PROGRAM
C
C     WRITTEN BY DAISUKE TAKAHASHI
C
      use cudafor
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'mpif.h'
      PARAMETER (NDA=33554432)
      complex(8),pinned,allocatable :: A(:),B(:)
C
      CALL MPI_INIT(IERR)
      CALL MPI_COMM_RANK(MPI_COMM_WORLD,ME,IERR)
      CALL MPI_COMM_SIZE(MPI_COMM_WORLD,NPU,IERR)
C
      ALLOCATE(A(NDA),B(NDA))
      IF (ME .EQ. 0) THEN
        WRITE(6,*) ' NX,NY,NZ ='
        READ(5,*) NX,NY,NZ
      END IF
      CALL MPI_BCAST(NX,1,MPI_INTEGER,0,MPI_COMM_WORLD,IERR)
      CALL MPI_BCAST(NY,1,MPI_INTEGER,0,MPI_COMM_WORLD,IERR)
      CALL MPI_BCAST(NZ,1,MPI_INTEGER,0,MPI_COMM_WORLD,IERR)
C
      NN=NX*NY*(NZ/NPU)
      CALL INIT(A,NN,ME,NPU)
      CALL PZFFT3D(A,B,NX,NY,NZ,MPI_COMM_WORLD,NPU,0)
C
      CALL PZFFT3D(A,B,NX,NY,NZ,MPI_COMM_WORLD,NPU,-1)
      CALL DUMP(B,NN,ME,NPU)
C
      CALL PZFFT3D(B,A,NX,NY,NZ,MPI_COMM_WORLD,NPU,1)
      CALL DUMP(A,NN,ME,NPU)
C
      CALL PZFFT3D(A,B,NX,NY,NZ,MPI_COMM_WORLD,NPU,3)
      DEALLOCATE(A,B)
C
      CALL MPI_FINALIZE(IERR)
      STOP
      END
      SUBROUTINE INIT(A,NN,ME,NPU)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A(*)
      INTEGER*8 N
C
      N=NN
      N=N*NPU
!DIR$ VECTOR ALIGNED
      DO 10 I=1,NN
        A(I)=DCMPLX(DBLE(I)+DBLE(NN)*DBLE(ME),
     1              DBLE(N)-(DBLE(I)+DBLE(NN)*DBLE(ME))+1.0D0)
   10 CONTINUE
      RETURN
      END
      SUBROUTINE DUMP(A,NN,ME,NPU)
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'mpif.h'
      COMPLEX*16 A(*)
C
      DO 20 J=0,NPU-1
        CALL MPI_BARRIER(MPI_COMM_WORLD,IERR)
        IF (J .EQ. ME) THEN
          DO 10 I=1,NN
            WRITE(6,*) ' ME=',ME,A(I)
   10     CONTINUE
        END IF
   20 CONTINUE
      RETURN
      END
