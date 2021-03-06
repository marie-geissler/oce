% vim:textwidth=80:expandtab:shiftwidth=2:softtabstop=2
\name{landsatTrim}

\alias{landsatTrim}

\title{Trim a landsat image to a lat-lon box}

\description{Trim a landsat image to a lat-lon box.}

\usage{landsatTrim(x, ll, ur, box, debug=getOption("oceDebug"))}

\arguments{
  \item{x}{A \code{landsat} object, e.g. as read by \code{\link{read.landsat}}.}

  \item{ll}{A list containing \code{longitude} and \code{latitude}, for the
    lower-left corner of the portion of the image to retain.}

  \item{ur}{A list containing \code{longitude} and \code{latitude}, for the
    upper-right corner of the portion of the image to retain.}

  \item{box}{A list containing \code{x} and \code{y} (each of length 2),
  corresponding to the values for \code{ll} and \code{ur}, such as would
  be produced by a call to \code{locator(2)}.}
  
  \item{debug}{a flag that turns on debugging.  Set to 1 to get a moderate
    amount of debugging information, or a higher value for more debugging.}

}

\details{As of June 25, 2015, the matrices storing the image data are trimmed to
  indices determined by linear interpolation based on the location of the
  \code{ll} and \code{ur} corners within the lon-lat corners specified in the
  image data. (A previous version trimmed in UTM space, and in fact this may be
  done in future also, if a problem in lonlat/utm conversion is resolved.) An
  error results if there is no intersection between the trimming box and the
  image box.
}
 
\value{An object of \code{\link[base]{class}} \code{"landsat"}, with data having
  been trimmed as specified.}

\seealso{The documentation for \code{\link{landsat-class}} explains the
  structure of landsat objects, and also outlines the other functions dealing
  with them.}

\author{Dan Kelley and Clark Richards}

\keyword{misc}

