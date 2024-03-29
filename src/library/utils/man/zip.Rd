% File src/library/utils/man/zip.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2020 R Core Team
% Distributed under GPL 2 or later

\name{zip}
\alias{zip}
\title{Create Zip Archives}
\description{
  A wrapper for an external \command{zip} command to create zip archives.
}
\usage{
zip(zipfile, files, flags = "-r9X", extras = "",
    zip = Sys.getenv("R_ZIPCMD", "zip"))
}
\arguments{
  \item{zipfile}{The pathname of the zip file: tilde expansion (see
    \code{\link{path.expand}}) will be performed.}
  \item{files}{A character vector of recorded filepaths to be included.}
  \item{flags}{A character string of flags to be passed to the command:
    see \sQuote{Details}.}
  \item{extras}{An optional character vector: see \sQuote{Details}.}
  \item{zip}{A character string specifying the external command to be used.}
}
\details{
  On a Unix-alike, the default for \code{zip} will use the
  value of \env{R_ZIPCMD}, whose default is set in \file{etc/Renviron}
  to the \code{zip} command found during configuration.  On Windows, the
  default relies on a \command{zip} program (for example that from
  \I{Rtools}) being in the path.

  The default for \code{flags} is that appropriate for zipping up a
  directory tree in a portable way: see the system-specific help for the
  \command{zip} command for other possibilities.

  Argument \code{extras} can be used to specify \code{-x} or \code{-i}
  followed by a list of filepaths to exclude or include. Since
  \code{extras} will be treated as if passed to \code{\link{system}}, if
  the filepaths contain spaces they must be quoted e.g. by
  \code{\link{shQuote}}.
}
\value{
  The status value returned by the external command, invisibly.
}
\seealso{
  \code{\link{unzip}}, \code{\link{unz}}; further, \code{\link{tar}} and
  \code{\link{untar}} for (un)packing tar archives.
}

\keyword{file}
\keyword{utilities}

