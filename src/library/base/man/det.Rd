% File src/library/base/man/det.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2007 R Core Team
% Distributed under GPL 2 or later

\name{det}
\title{Calculate the Determinant of a Matrix}
\alias{det}
\alias{determinant}
\alias{determinant.matrix}
\usage{
det(x, \dots)
determinant(x, logarithm = TRUE, \dots)
}
\description{
  \code{det} calculates the determinant of a matrix.  \code{determinant}
  is a generic function that returns separately the modulus of the determinant,
  optionally on the logarithm scale, and the sign of the determinant.
  }
\arguments{
  \item{x}{numeric matrix: logical matrices are coerced to numeric.}
  \item{logarithm}{logical; if \code{TRUE} (default) return the
    logarithm of the modulus of the determinant.}
  \item{\dots}{optional arguments, currently unused.}
}
\details{
  The \code{determinant} function uses an LU decomposition and the
  \code{det} function is simply a wrapper around a call to
  \code{determinant}.

  Often, computing the determinant is \emph{not} what you should be doing
  to solve a given problem.
}
\value{
  For \code{det}, the determinant of \code{x}.  For \code{determinant}, a
  list with components
  \item{modulus}{a numeric value.  The modulus (absolute value) of the
    determinant if \code{logarithm} is \code{FALSE}; otherwise the
    logarithm of the modulus.}
  \item{sign}{integer; either \eqn{+1} or \eqn{-1} according to whether
    the determinant is positive or negative.}
}
\examples{
(x <- matrix(1:4, ncol = 2))
unlist(determinant(x))
det(x)

det(print(cbind(1, 1:3, c(2,0,1))))
}

\keyword{array}
