\name{julianCenturyAnomaly}

\alias{julianCenturyAnomaly}

\title{Julian-Day number to Julian century}

\description{Convert a Julian-Day number to a time in julian centuries since
    noon on January 1, 1900.}

\usage{julianCenturyAnomaly(jd)}

\arguments{
    \item{jd}{a julian day number, e.g. as given by \code{\link{julianDay}}.}
}

\details{The method follows Meese (1982 equation 15.1).  The example reproduces
    the example provided by Meeuse (1982 example 15.a), with fractional error
    3e-8.}

\value{Julian century since noon on January 1, 1900.}

\examples{
t <- ISOdatetime(1978, 11, 13, 4, 35, 0, tz="UTC")
jca <- julianCenturyAnomaly(julianDay(t))
cat(format(t), "is Julian Century anomaly", format(jca, digits=8), "\n")
}

\author{Dan Kelley}

\references{Meeus, Jean, 1982.  Astronomical formuae for Calculators.
    Willmann-Bell. Richmond VA, USA. 201 pages}

\keyword{misc}

