% vim:textwidth=80:expandtab:shiftwidth=2:softtabstop=2
\name{argo-class}

\docType{class}

\alias{argo-class}
\alias{[[,argo-method}

\title{Class for argo data}

\description{Class to store argo data, with standard slots \code{metadata},
  \code{data} and \code{processingLog}.}

\section{Methods}{Data may be accessed as e.g. \code{pt[["time"]]}, where the
  string could also be \code{"longitude"} or \code{"latitude"}.  The data data
  are available in \code{"salinity"}, \code{"temperature"} and
  \code{"pressure"}, each of which is a matrix with first index corresponding to
  scan number and the second to profile number.  Items in \code{metadata} must
  be specifield by full name, but those in \code{data} may be abbreviated, so
  long as the abbreviation is unique.  }

\seealso{A \code{argo} object may be read with \code{\link{read.argo}} or
  created with \code{\link{as.argo}}.  Drifter data can be gridded to constant
  pressures with \code{\link{argoGrid}}.  Plots can be made with
  \code{\link{plot.argo}}, while \code{\link{summary.argo}} produces statistical
  summaries and \code{show} produces overviews.  See
  \url{http://www.argo.ucsd.edu/Gridded_fields.html} for some argo-related
  datasets that may be useful in a wider context.}

\author{Dan Kelley}

\keyword{classes}

\keyword{oce}

