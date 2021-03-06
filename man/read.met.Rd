\name{read.met}

\alias{read.met}

\title{Read a meteorological data file}

\description{Read a meteorological data file}

\usage{read.met(file, type=NULL, skip, tz=getOption("oceTz"),
         debug=getOption("oceDebug"), processingLog, \dots)}

\arguments{
  \item{file}{a connection or a character string giving the name of the
    file to load.}
  \item{type}{if \code{NULL}, then the first line is studied, in order to determine the
    file type.  If \code{type="msc"}, then a file as formatted by the Meteorological
    Service of Canada is assumed.}
  \item{skip}{optional number of lines of header that occur before the actual
      data.  If this is not supplied, \code{read.met} scans the file until it
      finds a line starting with \code{"Date/Time"}, and considers all lines
      above that to be header.}
  \item{tz}{timezone assumed for time data}
  \item{debug}{a flag that turns on debugging.  Set to 1 to get a
    moderate amount of debugging information, or to 2 to get more.} 
  \item{processingLog}{if provided, the action item to be stored in the
    log.  (Typically only provided for internal calls; the default that
    it provides is better for normal calls by a user.)}
  \item{\dots}{additional arguments, passed to called routines.}
}

\details{Reads a comma-separated value file in the format used by the
    Meteorological Service of Canada (MSC).  The agency does not publish a
    format for these files, so this function was based on a study of a few
    sample files, and it may fail for other files, if MSC changes the format.}
    
\value{An object of \code{\link[base]{class}} \code{"met"}, of which the
    \code{data} slot contains vectors \code{time}, \code{temperature},
    \code{pressure}, \code{u}, and \code{v}.  The velocity components have
    units m/s and are the components of the vector of wind direction.  In other
    words, the oceanographic convention on velocity is employed, not the
    meteorological one; the weather forecaster's "North wind" has positive
    \code{v} and zero \code{u}.  In addition to these things, \code{data} also
    contains items called \code{wind} (in km/h) and \code{direction} (in tenths
    of a degree), taken straight from the data file.}

\seealso{The documentation for \code{\link{met-class}} explains the structure
     of meteorological objects, and also outlines the other functions dealing
     with them.}

\section{Note}{There seem to be several similar formats in use, so this
    function may not work in all cases.}

\examples{
\dontrun{
library(oce)
met <- read.met("ile-rouge-eng-hourly-06012008-06302008.csv")
plot(met, which=3:4)
}
}

\author{Dan Kelley}

\keyword{misc}

