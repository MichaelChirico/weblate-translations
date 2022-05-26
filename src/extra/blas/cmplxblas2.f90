!> \brief \b DZNRM2
!
!  =========== DOCUMENTATION ===========
!
! Online html documentation available at
!            http://www.netlib.org/lapack/explore-html/
!
!  Definition:
!  ===========
!
!       DOUBLE PRECISION FUNCTION DZNRM2(N,X,INCX)
!
!       .. Scalar Arguments ..
!       INTEGER INCX,N
!       ..
!       .. Array Arguments ..
!       DOUBLE COMPLEX X(*)
!       ..
!
!
!> \par Purpose:
!  =============
!>
!> \verbatim
!>
!> DZNRM2 returns the euclidean norm of a vector via the function
!> name, so that
!>
!>    DZNRM2 := sqrt( x**H*x )
!> \endverbatim
!
!  Arguments:
!  ==========
!
!> \param[in] N
!> \verbatim
!>          N is INTEGER
!>         number of elements in input vector(s)
!> \endverbatim
!>
!> \param[in] X
!> \verbatim
!>          X is COMPLEX*16 array, dimension (N)
!>         complex vector with N elements
!> \endverbatim
!>
!> \param[in] INCX
!> \verbatim
!>          INCX is INTEGER, storage spacing between elements of X
!>          If INCX > 0, X(1+(i-1)*INCX) = x(i) for 1 <= i <= n
!>          If INCX < 0, X(1-(n-i)*INCX) = x(i) for 1 <= i <= n
!>          If INCX = 0, x isn't a vector so there is no need to call
!>          this subroutine.  If you call it anyway, it will count x(1)
!>          in the vector norm N times.
!> \endverbatim
!
!  Authors:
!  ========
!
!> \author Edward Anderson, Lockheed Martin
!
!> \date August 2016
!
!> \ingroup single_blas_level1
!
!> \par Contributors:
!  ==================
!>
!> Weslley Pereira, University of Colorado Denver, USA
!
!> \par Further Details:
!  =====================
!>
!> \verbatim
!>
!>  Anderson E. (2017)
!>  Algorithm 978: Safe Scaling in the Level 1 BLAS
!>  ACM Trans Math Softw 44:1--28
!>  https://doi.org/10.1145/3061665
!>
!>  Blue, James L. (1978)
!>  A Portable Fortran Program to Find the Euclidean Norm of a Vector
!>  ACM Trans Math Softw 4:15--23
!>  https://doi.org/10.1145/355769.355771
!>
!> \endverbatim
!>
!  =====================================================================
function DZNRM2( n, x, incx ) 
   integer, parameter :: wp = kind(1.d0)
   real(wp) :: DZNRM2
!
!  -- Reference BLAS level1 routine (version 3.9.1) --
!  -- Reference BLAS is a software package provided by Univ. of Tennessee,    --
!  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
!     March 2021
!
!  .. Constants ..
   real(wp), parameter :: zero = 0.0_wp
   real(wp), parameter :: one  = 1.0_wp
   real(wp), parameter :: maxN = huge(0.0_wp)
!  ..
!  .. Blue's scaling constants ..
   real(wp), parameter :: tsml = real(radix(0._wp), wp)**ceiling( &
       (minexponent(0._wp) - 1) * 0.5_wp)
   real(wp), parameter :: tbig = real(radix(0._wp), wp)**floor( &
       (maxexponent(0._wp) - digits(0._wp) + 1) * 0.5_wp)
   real(wp), parameter :: ssml = real(radix(0._wp), wp)**( - floor( &
       (minexponent(0._wp) - digits(0._wp)) * 0.5_wp))
   real(wp), parameter :: sbig = real(radix(0._wp), wp)**( - ceiling( &
       (maxexponent(0._wp) + digits(0._wp) - 1) * 0.5_wp))
!  ..
!  .. Scalar Arguments ..
   integer :: incx, n
!  ..
!  .. Array Arguments ..
   complex(wp) :: x(*)
!  ..
!  .. Local Scalars ..
   integer :: i, ix
   logical :: notbig
   real(wp) :: abig, amed, asml, ax, scl, sumsq, ymax, ymin
!
!  Quick return if possible
!
   DZNRM2 = zero
   if( n <= 0 ) return
!
   scl = one
   sumsq = zero
!
!  Compute the sum of squares in 3 accumulators:
!     abig -- sums of squares scaled down to avoid overflow
!     asml -- sums of squares scaled up to avoid underflow
!     amed -- sums of squares that do not require scaling
!  The thresholds and multipliers are
!     tbig -- values bigger than this are scaled down by sbig
!     tsml -- values smaller than this are scaled up by ssml
!
   notbig = .true.
   asml = zero
   amed = zero
   abig = zero
   ix = 1
   if( incx < 0 ) ix = 1 - (n-1)*incx
   do i = 1, n
      ax = abs(real(x(ix)))
      if (ax > tbig) then
         abig = abig + (ax*sbig)**2
         notbig = .false.
      else if (ax < tsml) then
         if (notbig) asml = asml + (ax*ssml)**2
      else
         amed = amed + ax**2
      end if
      ax = abs(aimag(x(ix)))
      if (ax > tbig) then
         abig = abig + (ax*sbig)**2
         notbig = .false.
      else if (ax < tsml) then
         if (notbig) asml = asml + (ax*ssml)**2
      else
         amed = amed + ax**2
      end if
      ix = ix + incx
   end do
!
!  Combine abig and amed or amed and asml if more than one
!  accumulator was used.
!
   if (abig > zero) then
!
!     Combine abig and amed if abig > 0.
!
      if ( (amed > zero) .or. (amed > maxN) .or. (amed /= amed) ) then
         abig = abig + (amed*sbig)*sbig
      end if
      scl = one / sbig
      sumsq = abig
   else if (asml > zero) then
!
!     Combine amed and asml if asml > 0.
!
      if ( (amed > zero) .or. (amed > maxN) .or. (amed /= amed) ) then
         amed = sqrt(amed)
         asml = sqrt(asml) / ssml
         if (asml > amed) then
            ymin = amed
            ymax = asml
         else
            ymin = asml
            ymax = amed
         end if
         scl = one
         sumsq = ymax**2*( one + (ymin/ymax)**2 )
      else
         scl = one / ssml
         sumsq = asml
      end if
   else
!
!     Otherwise all values are mid-range
!
      scl = one
      sumsq = amed
   end if
   DZNRM2 = scl*sqrt( sumsq )
   return
end function
!> \brief \b ZROTG
!
!  =========== DOCUMENTATION ===========
!
! Online html documentation available at
!            http://www.netlib.org/lapack/explore-html/
!
!  Definition:
!  ===========
!
!  ZROTG constructs a plane rotation
!     [  c         s ] [ a ] = [ r ]
!     [ -conjg(s)  c ] [ b ]   [ 0 ]
!  where c is real, s is complex, and c**2 + conjg(s)*s = 1.
!
!> \par Purpose:
!  =============
!>
!> \verbatim
!>
!> The computation uses the formulas
!>    |x| = sqrt( Re(x)**2 + Im(x)**2 )
!>    sgn(x) = x / |x|  if x /= 0
!>           = 1        if x  = 0
!>    c = |a| / sqrt(|a|**2 + |b|**2)
!>    s = sgn(a) * conjg(b) / sqrt(|a|**2 + |b|**2)
!> When a and b are real and r /= 0, the formulas simplify to
!>    r = sgn(a)*sqrt(|a|**2 + |b|**2)
!>    c = a / r
!>    s = b / r
!> the same as in DROTG when |a| > |b|.  When |b| >= |a|, the
!> sign of c and s will be different from those computed by DROTG
!> if the signs of a and b are not the same.
!>
!> \endverbatim
!
!  Arguments:
!  ==========
!
!> \param[in,out] A
!> \verbatim
!>          A is DOUBLE COMPLEX
!>          On entry, the scalar a.
!>          On exit, the scalar r.
!> \endverbatim
!>
!> \param[in] B
!> \verbatim
!>          B is DOUBLE COMPLEX
!>          The scalar b.
!> \endverbatim
!>
!> \param[out] C
!> \verbatim
!>          C is DOUBLE PRECISION
!>          The scalar c.
!> \endverbatim
!>
!> \param[out] S
!> \verbatim
!>          S is DOUBLE COMPLEX
!>          The scalar s.
!> \endverbatim
!
!  Authors:
!  ========
!
!> \author Edward Anderson, Lockheed Martin
!
!> \par Contributors:
!  ==================
!>
!> Weslley Pereira, University of Colorado Denver, USA
!
!> \ingroup single_blas_level1
!
!> \par Further Details:
!  =====================
!>
!> \verbatim
!>
!>  Anderson E. (2017)
!>  Algorithm 978: Safe Scaling in the Level 1 BLAS
!>  ACM Trans Math Softw 44:1--28
!>  https://doi.org/10.1145/3061665
!>
!> \endverbatim
!
!  =====================================================================
subroutine ZROTG( a, b, c, s )
   integer, parameter :: wp = kind(1.d0)
!
!  -- Reference BLAS level1 routine --
!  -- Reference BLAS is a software package provided by Univ. of Tennessee,    --
!  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
!
!  .. Constants ..
   real(wp), parameter :: zero = 0.0_wp
   real(wp), parameter :: one  = 1.0_wp
   complex(wp), parameter :: czero  = 0.0_wp
!  ..
!  .. Scaling constants ..
   real(wp), parameter :: safmin = real(radix(0._wp),wp)**max( &
      minexponent(0._wp)-1, &
      1-maxexponent(0._wp) &
   )
   real(wp), parameter :: safmax = real(radix(0._wp),wp)**max( &
      1-minexponent(0._wp), &
      maxexponent(0._wp)-1 &
   )
   real(wp), parameter :: rtmin = sqrt( real(radix(0._wp),wp)**max( &
      minexponent(0._wp)-1, &
      1-maxexponent(0._wp) &
   ) / epsilon(0._wp) )
   real(wp), parameter :: rtmax = sqrt( real(radix(0._wp),wp)**max( &
      1-minexponent(0._wp), &
      maxexponent(0._wp)-1 &
   ) * epsilon(0._wp) )
!  ..
!  .. Scalar Arguments ..
   real(wp) :: c
   complex(wp) :: a, b, s
!  ..
!  .. Local Scalars ..
   real(wp) :: d, f1, f2, g1, g2, h2, p, u, uu, v, vv, w
   complex(wp) :: f, fs, g, gs, r, t
!  ..
!  .. Intrinsic Functions ..
   intrinsic :: abs, aimag, conjg, max, min, real, sqrt
!  ..
!  .. Statement Functions ..
   real(wp) :: ABSSQ
!  ..
!  .. Statement Function definitions ..
   ABSSQ( t ) = real( t )**2 + aimag( t )**2
!  ..
!  .. Executable Statements ..
!
   f = a
   g = b
   if( g == czero ) then
      c = one
      s = czero
      r = f
   else if( f == czero ) then
      c = zero
      g1 = max( abs(real(g)), abs(aimag(g)) )
      if( g1 > rtmin .and. g1 < rtmax ) then
!
!        Use unscaled algorithm
!
         g2 = ABSSQ( g )
         d = sqrt( g2 )
         s = conjg( g ) / d
         r = d
      else
!
!        Use scaled algorithm
!
         u = min( safmax, max( safmin, g1 ) )
         uu = one / u
         gs = g*uu
         g2 = ABSSQ( gs )
         d = sqrt( g2 )
         s = conjg( gs ) / d
         r = d*u
      end if
   else
      f1 = max( abs(real(f)), abs(aimag(f)) )
      g1 = max( abs(real(g)), abs(aimag(g)) )
      if( f1 > rtmin .and. f1 < rtmax .and. &
          g1 > rtmin .and. g1 < rtmax ) then
!
!        Use unscaled algorithm
!
         f2 = ABSSQ( f )
         g2 = ABSSQ( g )
         h2 = f2 + g2
         if( f2 > rtmin .and. h2 < rtmax ) then
            d = sqrt( f2*h2 )
         else
            d = sqrt( f2 )*sqrt( h2 )
         end if
         p = 1 / d
         c = f2*p
         s = conjg( g )*( f*p )
         r = f*( h2*p )
      else
!
!        Use scaled algorithm
!
         u = min( safmax, max( safmin, f1, g1 ) )
         uu = one / u
         gs = g*uu
         g2 = ABSSQ( gs )
         if( f1*uu < rtmin ) then
!
!           f is not well-scaled when scaled by g1.
!           Use a different scaling for f.
!
            v = min( safmax, max( safmin, f1 ) )
            vv = one / v
            w = v * uu
            fs = f*vv
            f2 = ABSSQ( fs )
            h2 = f2*w**2 + g2
         else
!
!           Otherwise use the same scaling for f and g.
!
            w = one
            fs = f*uu
            f2 = ABSSQ( fs )
            h2 = f2 + g2
         end if
         if( f2 > rtmin .and. h2 < rtmax ) then
            d = sqrt( f2*h2 )
         else
            d = sqrt( f2 )*sqrt( h2 )
         end if
         p = 1 / d
         c = ( f2*p )*w
         s = conjg( gs )*( fs*p )
         r = ( fs*( h2*p ) )*u
      end if
   end if
   a = r
   return
end subroutine
