% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/surveys.R
\name{fix_survey_names}
\alias{fix_survey_names}
\alias{fix_campus_names}
\title{Reformat Memorial Hermann Survey or Campus Names}
\usage{
fix_survey_names(.data)

fix_campus_names(.data)
}
\arguments{
\item{.data}{A tibble. \code{fix_survey_names()} requires the column \code{survey_name}
to be present. \code{fix_campus_names()} requires the column \code{campus} to be present.}
}
\description{
\code{fix_survey_names()} is a convenience function for reformatting MH Survey
names as they appear in the Qualtrics UI to something more legible.
\code{fix_campus_names()} is a similar convenience function that reformats full
campus names to their shorthand equivalent.
}
\examples{
# list of survey names as they appear in the qualtrics ui
surveys <-
  tibble::tibble(
    survey_name = c("Live - Adult Day Surgery",
                    "Live - Adult Emergency Department",
                    "Live - Adult Inpatient Rehab",
                    "Live - Adult Medical Practice",
                    "Live - Adult Outpatient",
                    "Live - Adult Outpatient - Oncology",
                    "Live - Adult Outpatient - Vaccine",
                    "Live - Adult Outpatient Rehab",
                    "Live - Adult Telemedicine",
                    "Live - Adult Urgent Care",
                    "Live - HCAHPS - Paper",
                    "Live - Home Medical Equipment",
                    "Live - Infusion Pharmacy",
                    "Live - Inpatient",
                    "Live - Pediatric - Emergency Department",
                    "Live - Pediatric Inpatient")
  )

# bad names!
surveys

# better names!
fix_survey_names(surveys)

# list of campus names as they appear in the qualtrics ui
campuses <-
  tibble::tibble(
    campus = c("Children's Memorial Hermann Hospital",
               "Memorial Hermann - Texas Medical Center",
               "Memorial Hermann / Rockets Orthopedic Hospital",
               "Memorial Hermann Cypress Hospital",
               "Memorial Hermann Greater Heights Hospital",
               "Memorial Hermann Katy Hospital",
               "Memorial Hermann Memorial City Medical Center",
               "Memorial Hermann Northeast Hospital",
               "Memorial Hermann Pearland Hospital",
               "Memorial Hermann Rehabilitation Hospital - Katy",
               "Memorial Hermann Southeast Hospital",
               "Memorial Hermann Southwest Hospital",
               "Memorial Hermann Sugar Land Hospital",
               "Memorial Hermann The Woodlands Medical Center",
               "TIRR Memorial Hermann")
  )

# bad names!
campuses

# better names!
fix_campus_names(campuses)
}
