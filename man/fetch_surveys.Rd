% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/surveys.R
\name{fetch_surveys}
\alias{fetch_surveys}
\title{Fetch a list of Qualtrics surveys by name via the Qualtrics API}
\usage{
fetch_surveys(survey_names, ..., time_zone = "America/Chicago")
}
\arguments{
\item{survey_names}{A vector of survey names as they appear in the Qualtrics UI.}

\item{...}{Additional arguments to be passed to \code{qualtRics::fetch_survey()}.}

\item{time_zone}{Timezone adjustment to be passed to \code{qualtRics::fetch_survey()}.
A list of acceptable names for \code{time_zone} can be found in the
\href{https://api.qualtrics.com/7367ea545f562-dates-and-times}{Qualtrics API documentation}.}
}
\value{
For a single value supplied to \code{survey_names}: a tibble of the survey
responses from \code{qualtRics::fetch_survey()}. For multiple \code{survey_names}, a
tibble with colums \code{survey_name}, \code{survey_id}, and \code{responses}. The \code{responses}
contains the responses for each survey as returned by
\code{qualtRics::fetch_survey()}.
}
\description{
Fetch a list of Qualtrics surveys by name via the Qualtrics API
}
\examples{
\dontrun{
# fetch a single survey by name
my_survey <- fetch_surveys("my cool survey")

# fetch multiple surveys by name
my_surveys <- fetch_surveys(c("my cool survey", "my lame survey"))
}
}
