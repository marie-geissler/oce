\name{read.section}
\alias{read.section}
\title{Read a section containing multiple CTD profiles}
\description{Read a file that contains a series of \code{ctd} profiles that make up an oceanographic section.}

\usage{read.section(file, sectionId="", flags, 
             ship="", scientist="", institute="",
             debug=getOption("oceDebug"),
  processingLog)}

\arguments{
  \item{file}{a file containing a set of CTD observations.  At present, only 
    the \emph{exchange BOT} format is accepted (see Details).}
  \item{sectionId}{optional string indicating the name for the section.  
    If not provided, the section ID is determined by examination of 
    the file header.}
  \item{ship}{name of the ship carrying out the sampling}
  \item{scientist}{name of chief scientist aboard ship}
  \item{institute}{name of chief scientist's institute}
  \item{flags}{optional list of salinity-quality flags that will be 
    demanded of the salinity data.  If not given, an appropriate flag will be
    chosen based on the data type.  For example, for WOCE data, any 
    data with salinity flag not equal to 2 will be rejected.
    \code{read.section} tries to use the salinity from the CTD (with WOCE
    header name \code{CTDSAL}), but if its flag is unacceptable, the
    function tries \code{SALNTY} (yes, that is the spelling!) instead.
    But if neither has an acceptable flag, the datum will not be
    read.}
  \item{debug}{logical. If \code{TRUE}, print some information that 
    might be helpful during debugging.}
  \item{processingLog}{if provided, the action item to be stored in the
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
\code{sectionId}, a name for the section;
\code{stationId}, a vector of station IDs, one per station;
\code{latitude}, a vector of station latitudes, decimal and positive in northern hemisphere;
and
\code{longitude}, a vector of station latitudes, decimal and positive in eastern hemisphere.
}
\item{processingLog}{a processingLog of processing, in the standard \code{oce} format.}
}

\seealso{\code{\link{makeSection}} can be used to bind together \code{ctd} objects into a section.}
\examples{
library(oce)
data(a03)
GS <- subset(a03, indices=124:102)
GSg <- sectionGrid(GS, p=seq(0, 5000, 100))
data(coastlineWorld)
plot(GSg, coastline=coastlineWorld, map.xlim=c(-80,-60))
\dontrun{
# Plot stations individually (good for quality-control)
pdf("a03_stations.pdf")
for (s in seq_along(na03$data$station)) {
    plot(na03$data$station[[s]])
}
dev.off()
}
}

\references{Several repository sites provide section data. An example
  that is perhaps likely to exist for years is
  \url{http://cchdo.ucsd.edu}, but a search on \code{"WOCE bottle data"}
  should turn up other sites, if this one ceases to exist. Only the
  so-called \emph{exchange BOT} data format can be processed by
  read.section() at this time.}

\author{Dan Kelley}

\keyword{misc}