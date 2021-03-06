% vim:textwidth=100:expandtab:shiftwidth=2:softtabstop=2
\name{read.index}
\alias{read.index}

\title{Read a NOAA ocean index file}

\description{Read an ocean index file, in the format used by NOAA.}

\usage{read.index(file, tz=getOption("oceTz"), debug=getOption("oceDebug"))}

\arguments{

  \item{file}{a connection or a character string giving the name of the file to load.  May be a
    URL.}
  
  \item{tz}{character string indicating time zone to be assumed in the data.}
  
  \item{debug}{a flag that turns on debugging, ignored in the present version of the function.}
  
}

\details{Reads a text-format index file, in a format used by NOAA.  The first line holds two
  numbers, for start year and end year.  Then there are several lines containing 13 numbers, the
  first being the year, and the others being the data.  Then there is a line with a single number,
  the missing value.  Then there are some headers lines (which are ignored in the present version of
  \code{read.index}.}

\value{A data frame containing \code{t}, a POSIX time, and \code{index}, the numerical index.  The
  times are set to the 15th day of each month, which is a guess that may need to be changed if so
  indicated by documentation (yet to be located).}

\examples{
\dontrun{
library(oce)
# Arctic oscillation
ao <- read.index("http://www.esrl.noaa.gov/psd/data/correlation/ao.data")
recent <- subset(ao, t > as.POSIXct("2000-01-01"))
oce.plot.ts(recent$t, recent$index)
}
}

\references{See \url{http://www.esrl.noaa.gov/psd/data/climateindices/list/} for a list of indices.}

\author{Dan Kelley}

\keyword{misc}
