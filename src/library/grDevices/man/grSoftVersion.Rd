% File src/library/grDevices/man/grSoftVersion.Rd
% Part of the R package, https://www.R-project.org
% Copyright 2014-2021 R Core Team
% Distributed under GPL 2 or later

\name{grSoftVersion}
\alias{grSoftVersion}
\title{Report Versions of Graphics Software}
\description{
  Report versions of third-party graphics software available on the
  current platform for \R's graphics.
}
\usage{
grSoftVersion()
}
\value{
  A named character vector containing at least the elements

  \item{cairo}{the version of \I{cairographics} in use, or \code{""} if
    \I{cairographics} is not available.}
  \item{cairoFT}{the \I{FreeType}/\I{FontConfig} versions if \I{cairographics} is
    using those libraries directly (not \emph{via} \I{pango}); otherwise,
    \code{""}.  Earlier versions of \R returned \code{"yes"} rather than
    the versions.  The \I{FontConfig} version is determined when \R is built.}
  \item{pango}{the version of \I{pango} in use, or \code{""} if
    \I{pango} is not available.}

  It may also contain the versions of third-party software used by the
  standard (on Windows), or X11-based (on Unix-alikes)
  bitmap devices:
  \item{libpng}{the version of \code{libpng} in use, or \code{""} if
    not available.}
  \item{jpeg}{the version of the JPEG headers used for compilation,
    or \code{""} if JPEG support was not compiled in.}
  \item{libtiff}{the version of \code{libtiff} in use, or \code{""} if
    not available.}

  It is conceivable but unlikely that the \I{cairo}-based bitmap devices
  will use different versions linked \emph{via} \I{cairographics},
  especially \code{png(type = "cairo-png")}.

  On macOS, if available, the Quartz-based devices will use the system
  versions of these libraries rather than those reported here.

  Unless otherwise stated the reported version is that of the (possibly
  dynamically-linked) library in use at runtime.

  Note that \code{libjpeg-turbo} as used on some Linux distributions
  reports its version as \code{"6.2"}, the \I{IJG} version from which it forked.
}

\seealso{
  \code{\link{extSoftVersion}} for versions of non-graphics software.
}
%% output is variable
\examples{
\donttest{grSoftVersion()}
}
