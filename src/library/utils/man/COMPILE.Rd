% File src/library/utils/man/COMPILE.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2018 R Core Team
% Distributed under GPL 2 or later

\name{COMPILE}
\alias{COMPILE}
\title{Compile Files for Use with R on Unix-alikes}
\description{
  Compile given source files so that they can subsequently be collected
  into a shared object using \command{R CMD SHLIB} or an executable
  program using \command{R CMD LINK}.   Not available on Windows.
}
\usage{
\special{R CMD COMPILE [options] srcfiles}
}
\arguments{
  \item{srcfiles}{A list of the names of source files to be compiled.
    Currently, C, C++, Objective C, Objective C++ and Fortran are
    supported; the corresponding files should have the extensions
    \file{.c}, \file{.cc} (or \file{.cpp}), \file{.m},
    \file{.mm} (or \file{.M}), \file{.f} and \file{.f90} or \file{.f95},
    respectively.}
  \item{options}{A list of compile-relevant settings, or for obtaining
    information about usage and version of the utility.}
}
\details{
  \command{R CMD SHLIB} can both compile and link files into a
  shared object: since it knows what run-time libraries are needed
  when passed C++, Fortran and Objective C(++) sources, passing source
  files to \command{R CMD SHLIB} is more reliable.

  Objective C and Objective C++ support is optional and will work only
  if the corresponding compilers were available at \R configure time:
  their main usage is on macOS.

  Compilation arranges to include the paths to the \R public C/C++ headers.

  As this compiles code suitable for incorporation into a shared object,
  it generates PIC code: that might occasionally be undesirable for the
  main code of an executable program.

  This is a \command{make}-based facility, so will not compile a source file
  if a newer corresponding \file{.o} file is present.
}
\note{
  Some binary distributions of \R have \code{COMPILE} in a separate
  bundle, e.g.\sspace{}an \code{R-devel} RPM.

  This is not available on Windows.
}
\seealso{
  \code{\link{LINK}}, \code{\link{SHLIB}}, \code{\link{dyn.load}}
  
  The section on \dQuote{Customizing package compilation} in
  the \sQuote{R Administration and Installation} manual:
  \code{\link{RShowDoc}("R-admin")}.
}
\keyword{utilities}
