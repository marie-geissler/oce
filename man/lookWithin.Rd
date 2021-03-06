% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/sw.R
\name{lookWithin}
\alias{lookWithin}
\title{Look within the first element of a list, replacing other elements from its contents.}
\usage{
lookWithin(list)
}
\arguments{
\item{list}{A list of elements, typically arguments that will be used in sw functions.}
}
\value{
A list with elements of the same names but possibly filled in from the first element.
}
\description{
Look within the first element of a list, replacing other elements from its contents.
}
\details{
This is a helper function used by various seawater functions. It is used for a
call like \code{\link{swRho}(ctd)}, in which the first argument, which is
normally \code{salinity} may be an object that contains salinity plus
the other items that \code{\link{swRho}} expects to see as arguments. This
shorthand is very helpful in calls to the suite of \code{sw} functions.  If
this first argument is an object of this sort, then the other arguments
are ignored \emph{except} for one named \code{eos}, which is copied if
it is present.
}

