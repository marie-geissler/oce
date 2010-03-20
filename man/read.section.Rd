\name{read.section}
\alias{read.section}
\title{Read a section containing multiple CTD profiles}
\description{Read a file that contains a series of \code{ctd} profiles that make up an oceanographic section.}
\usage{read.section(file, section.id="", debug=getOption("oce.debug"), log.action)}
\arguments{
  \item{file}{a file containing a set of CTD observations.  At present, only the \emph{exchange BOT} format is accepted (see Details).}
  \item{section.id}{optional string indicating the name for the section.  If not provided, the section ID is determined by examination of the file header.}
  \item{debug}{logical. If \code{TRUE}, print some information that might be helpful during debugging.}
  \item{log.action}{if provided, the action item to be stored in the
    log.  (Typically only provided for internal calls; the default that
    it provides is better for normal calls by a user.)}
}

\details{Only \emph{exchange BOT} comma-separated value format is
permitted at this time, but other formats may be added later.  It
should also be noted that the parsing scheme was developed after
inspection of the A03 data set (see Examples). This may cause problems
if the format is not universal. For example, the header must name the
salinity column "\code{CTDSAL}"; if not, salinity values will not be
read from the file.}

\value{An object of \code{\link[base]{class}} \code{"section"}, which is a \code{\link[base]{list}}
containing
\item{data}{a list containing just one item, 
\code{station}, which is a list of \code{ctd} objects, one per station.}
\item{metadata}{a list containing:
\code{header}, the header from the data file;
\code{section.id}, a name for the section;
\code{station.id}, a vector of station IDs, one per station;
\code{latitude}, a vector of station latitudes, decimal and positive in northern hemisphere;
and
\code{longitude}, a vector of station latitudes, decimal and positive in eastern hemisphere.
}
\item{processing.log}{A processing log, in the standard \code{oce} format.}
}

\seealso{\code{\link{make.section}} can be used to bind together \code{ctd} objects into a section.}
\examples{
library(oce)
data(a03)
Gulf.Stream <- subset(a03, indices=124:102)
Gulf.Stream.gridded <- section.grid(Gulf.Stream, p=seq(0, 5000, 100))
data(coastline.world)
plot(Gulf.Stream.gridded, coastline=coastline.world, map.xlim=c(-80,-60))
}

\references{Several repository sites provide section data. An example
  that is perhaps likely to exist for years is
  \url{http://cchdo.ucsd.edu}, but a search on \code{"WOCE bottle data"}
  should turn up other sites, if this one ceases to exist. Only the
  so-called \emph{exchange BOT} data format can be processed by
  read.section() at this time.}

\author{Dan Kelley}

\keyword{misc}