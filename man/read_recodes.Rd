% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/recodes.R
\name{read_recodes}
\alias{read_recodes}
\title{Read Memorial Hermann recodes from version control.}
\usage{
read_recodes(file = "consolidated")
}
\arguments{
\item{file}{recode file name to read in. Reads in from the \code{edit} directory.}
}
\description{
Reads in Memorial Hermann recodes from version control. Specify the exact
recode document to be used by setting the recode path with \code{set_recode_path()}.
}
\examples{
\dontrun{
  read_recodes()
}
}
