\name{adv-class}

\docType{class}

\alias{adv-class}
\alias{[[,adv-method}
\alias{[[<-,adv-method}
\alias{show,adv-method}

\title{Class to store acoustic Doppler velocimeter data}

\description{Class to store acoustic Doppler velocimeter data, with standard
    slots \code{metadata}, \code{data} and \code{processingLog}.}

\section{Methods}{

    \subsection{Extracting values}{Data may be accessed as e.g.
        \code{adv[["u1"]]}, where the string could also be \code{"u2"} or
        \code{"u3"} for the other velocity components, or \code{"heading"},
        \code{"pitch"} or \code{"roll"} for the instrument angles, or
        \code{"temperature"} for the temperature.}

    \subsection{Assigning values}{(not available yet)}

    \subsection{Overview of contents}{The \code{show} method (e.g.
        \code{show(d)}) displays information about an ADV object named
        \code{d}.}
}

\seealso{A file containing ADV data is usually recognized by Oce, and so
    \code{\link{read.oce}} will usually read the data.  If not, one may use the
    general ADV function \code{\link{read.adv}} or specialized variants
    \code{\link{read.adv.nortek}}, \code{\link{read.adv.sontek.adr}} or
    \code{\link{read.adv.sontek.text}}.

    ADV data may be plotted with \code{\link{plot.adv}} function, which is a
    generic function so it may be called simply as \code{plot}.

    Statistical summaries of ADV data are provided by the generic function
    \code{summary}, while briefer overviews are provided with \code{show}.

    Conversion from beam to xyz coordinates may be done with
    \code{\link{beamToXyzAdv}}, and from xyz to enu (east north up) may be done
    with \code{\link{xyzToEnuAdv}}.  \code{\link{toEnuAdv}} may be used to
    transfer either beam or xyz to enu.  Enu may be converted to other
    coordinates (e.g. aligned with a coastline) with
    \code{\link{enuToOtherAdv}}.
}

\author{Dan Kelley}
\keyword{classes}
\keyword{oce}
