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
C     PDZFFT3D AND PZDFFT3D TEST PROGRAM
C
C     FORTRAN77 + MPI SOURCE PROGRAM
C
C     WRITTEN BY DAISUKE TAKAHASHI
C
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'mpif.h'
      PARAMETER (NDA=16777216)
      DIMENSION A(NDA),B(NDA)
      SAVE A,B
C
      CALL MPI_INIT(IERR)
      CALL MPI_COMM_RANK(MPI_COMM_WORLD,ME,IERR)
      CALL MPI_COMM_SIZE(MPI_COMM_WORLD,NPU,IERR)
C
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
      CALL PDZFFT3D(A,B,NX,NY,NZ,MPI_COMM_WORLD,ME,NPU,0)
      CALL PDZFFT3D(A,B,NX,NY,NZ,MPI_COMM_WORLD,ME,NPU,-1)
      CALL DUMP(A,NX,NY,NZ,ME,NPU)
C
      CALL PZDFFT3D(A,B,NX,NY,NZ,MPI_COMM_WORLD,ME,NPU,0)
      CALL PZDFFT3D(A,B,NX,NY,NZ,MPI_COMM_WORLD,ME,NPU,1)
      CALL RDUMP(A,NN,ME,NPU)
C
      CALL MPI_FINALIZE(IERR)
      STOP
      END
      SUBROUTINE INIT(A,NN,ME,NPU)
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION A(*)
      INTEGER*8 N
C
      N=NN
      N=N*NPU
!$OMP PARALLEL DO
      DO 10 I=1,NN
        A(I)=DBLE(I)+DBLE(NN)*DBLE(ME)
   10 CONTINUE
      RETURN
      END
      SUBROUTINE DUMP(A,NX,NY,NZ,ME,NPU)
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'mpif.h'
      COMPLEX*16 A(*)
C
      DO 20 J=0,NPU-1
        CALL MPI_BARRIER(MPI_COMM_WORLD,IERR)
        IF (J .EQ. ME) THEN
          DO 10 I=1,(NX/2+1)*NY*(NZ/NPU)
            WRITE(6,*) ' ME=',ME,A(I)
   10     CONTINUE
        END IF
   20 CONTINUE
      RETURN
      END
      SUBROUTINE RDUMP(A,NN,ME,NPU)
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'mpif.h'
      DIMENSION A(*)
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
