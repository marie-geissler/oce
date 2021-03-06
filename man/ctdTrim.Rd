% vim:textwidth=100:expandtab:shiftwidth=2:softtabstop=2
\name{ctdTrim}

\alias{ctdTrim}

\title{Trim start/end portions of a CTD cast}

\description{Trim start/end portions of a CTD cast.}

\usage{ctdTrim(x, method, removeDepthInversions=FALSE, parameters,
        debug=getOption("oceDebug"))}


\arguments{
  \item{x}{A \code{ctd} object, e.g. as read by \code{\link{read.ctd}}.}

  \item{method}{A string (or a vector of two strings) specifying the trimming method, or a function
    to be used to determine data indices to keep.  If \code{method} is not provided,
    \code{"downcast"} is assumed. See \dQuote{Details}.}

  \item{removeDepthInversions}{Logical value indicating whether to remove any levels at which depth
    is less than, or equal to, a depth above.  (This is needed if the object is to be assembled into
    a section, unless \code{\link{ctdDecimate}} will be used, which will remove the inversions.}

  \item{parameters}{A list whose elements depend on the method; see \dQuote{Details}.}

  \item{debug}{a flag that turns on debugging.  Set to 1 to get a moderate amount of debugging
    information, or to 2 to get more.} 

}

\details{Often in CTD profiling, the goal is to isolate only the downcast, discarding measurements
  made in the air, in an equilibration phase in which the device is held below the water surface,
  and then the upcast phase that follows the downcast.  This is handled reasonably well by
  \code{ctdTrim} with \code{method="downcast"}, although it is almost always best to use
  \code{\link{plotScan}} to investigate the data, and then use the \code{method="index"} or
  \code{method="scan"} method based on visual inspection of the data.  The details methods are as
  follows.

  \itemize{
  \item{If \code{method[1]} is \code{"downcast"} then an attempt is made to only data for
  which the CTD is descending.  This is done in stages, with variants based on \code{method[1]}, if
  supplied.  \emph{Step 1.} The pressure data are despiked with a smooth() filter with method "3R".
  This removes wild spikes that arise from poor instrument connections, etc.  \emph{Step 2.} If no
  \code{parameters} are given, then any data with negative pressures are deleted.  If there is a
  parameter named \code{pmin}, then that pressure (in decibars) is used instead as the lower limit.
  This is a commonly-used setup, e.g.  \code{ctdTrim(ctd, parameters=list(pmin=1))} removes the top
  decibar (roughly 1m) from the data.  Specifying \code{pmin} is a simple way to remove near-surface
  data, such as a shallow equilibration phase, and if specified will cause \code{ctdTrim} to skip
  step 4 below.  \emph{Step 3.} The maximum pressure is determined, and data acquired subsequent to
  that point are deleted.  This removes the upcast and any subsequent data.  \emph{Step 4.} If the
  \code{pmin} parameter is not specified, an attempt is made to remove an initial equilibrium phase
  by a regression of pressure on scan number.  There are three variants to this, depending on the
  value of the second \code{method} element. If it is \code{"A"} (or not given), the procedure is to
  call \code{\link{optim}} to minimize the mismatch between observed pressure and a linear model
  with respect to \code{scan} that is set to \code{NA} above a fitted value of \code{scan}. The
  value of pressure at the cutoff \code{scan} is taken as the top of the downcast. If the submethod
  is \code{"B"}, a similar procedure is used in a model that retains the pressures in the upper
  portion, but that takes the pressure to be (a fitted) constant there. Case \code{"C"} is the same,
  except that the pressure in the surface region is taken to be zero.} 
  
  \item{If \code{method="index"} or \code{"scan"}, then each column of data is subsetted according to the
  value of \code{parameters}. If the latter is a logical vector of length matching data column
  length, then it is used directly for subsetting. If \code{parameters} is a numerical vector with
  two elements, then the index or scan values that lie between \code{parameters[1]}
  and \code{parameters[2]} (inclusive) are used for subsetting.  The
  two-element method is probably the most useful, with the values being determined by visual
  inspection of the results of \code{\link{plotScan}}. While this may take a minute or two, the
  analyst should bear in mind that a deep-water CTD profile might take 6 hours, corresponding to
  ship-time costs exceeding a week of salary.}
  
  \item{If \code{method="range"} then data are selected based on the value of the column named
    \code{parameters$item}.  This may be by range or by critical value.  By range: select values
    between \code{parameters$from} (the lower limit) and \code{parameters$to} (the upper limit) By
    critical value: select if the named column exceeds the value.  For example, \code{ctd2 <-
      ctdTrim(ctd, "range", parameters=list(item="scan", from=5))} starts at scan number 5 and
    continues to the end, while
    \code{ctdTrim(ctd,"range",parameters=list(item="scan",from=5,to=100))} also starts at scan 5,
    but extends only to scan 100.}

  \item{If \code{method} is a function, then it must return a vector of \code{\link{logical}}
    values, computed based on two arguments: \code{data}, which is set to \code{x@data} (a
    \code{\link{list}}), and \code{parameters} as supplied to \code{ctdTrim}.  Both
    \code{inferWaterDepth} and \code{removeInversions} are ignored in the function case. See
    \dQuote{Examples}.}

  }
}

\value{An object of \code{\link[base]{class}} \code{"ctd"}, with data having been trimmed in some way.}

\seealso{The documentation for \code{\link{ctd-class}} explains the structure
    of CTD objects, and also outlines the other functions dealing with them.}

\examples{
library(oce)
data(ctdRaw) 
plot(ctdRaw) # barely recognizable, due to pre- and post-cast junk
plot(ctdTrim(ctdRaw)) # looks like a real profile ...
plot(ctdDecimate(ctdTrim(ctdRaw),method="boxcar")) # ... smoothed
# Demonstrate use of a function. The scan limits were chosen
# by using locator(2) on a graph made by plotScan(ctdRaw).
trimByIndex <- function(data, parameters) {
  parameters[1] < data$scan & data$scan < parameters[2]
}
trimmed <- ctdTrim(ctdRaw, trimByIndex, parameters=c(130, 380))
plot(trimmed)
}

\references{The Seabird CTD instrument is described at
  \url{http://www.seabird.com/products/spec_sheets/19plusdata.htm}.
}

\author{Dan Kelley}
\keyword{misc}
