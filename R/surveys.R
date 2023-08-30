#' Fetch a list of Qualtrics surveys by name via the Qualtrics API
#'
#' @return
#' For a single value supplied to `survey_names`: a tibble of the survey
#' responses from `qualtRics::fetch_survey()`. For multiple `survey_names`, a
#' tibble with colums `survey_name`, `survey_id`, and `responses`. The `responses`
#' contains the responses for each survey as returned by
#' `qualtRics::fetch_survey()`.
#'
#' @param survey_names A vector of survey names as they appear in the Qualtrics UI.
#' @param ... Additional arguments to be passed to `qualtRics::fetch_survey()`.
#' @param time_zone Timezone adjustment to be passed to `qualtRics::fetch_survey()`.
#'   A list of acceptable names for `time_zone` can be found in the
#'   [Qualtrics API documentation](https://api.qualtrics.com/7367ea545f562-dates-and-times).
#'
#' @export
#'
#' @importFrom dplyr enquos
#' @importFrom qualtRics all_surveys
#' @importFrom dplyr filter
#' @importFrom cli cli_abort
#' @importFrom cli cli_warn
#' @importFrom stats setNames
#' @importFrom dplyr pull
#' @importFrom qualtRics fetch_survey
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom purrr map
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' # fetch a single survey by name
#' my_survey <- fetch_surveys("my cool survey")
#'
#' # fetch multiple surveys by name
#' my_surveys <- fetch_surveys(c("my cool survey", "my lame survey"))
#' }
fetch_surveys <- function(survey_names, ..., time_zone = "America/Chicago") {
  
  # define survey_names internally
  ui_names <- survey_names
  
  # get args passed on to `fetch_survey()`
  dots <- dplyr::enquos(...)
  
  # get a list of survey ids
  surveys <- qualtRics::all_surveys()
  surveys <- dplyr::filter(surveys, .data$name %in% ui_names)
  
  # get list of survey_names that don't appear in ui
  not_fetched <- survey_names[which(!survey_names %in% surveys$name)]
  
  # stop if all surveys are missing or spelled incorrectly
  if (nrow(surveys) == 0) cli::cli_abort("No surveys match values supplied to `survey_names`")
  
  # warn if some are missing or spelled incorrectly
  if (length(not_fetched) > 0) {
    
    cli::cli_warn(
      c("The following `survey_names` were not found in the Qualtrics UI and were skipped:",
        stats::setNames(not_fetched, rep("x", length(not_fetched))))
    )
    
  }
  
  # if only one survey name provided, just return the responses, else return a nested tibble
  if (nrow(surveys) == 1) {
    
    id <- dplyr::pull(surveys, id)
    surveys <- qualtRics::fetch_survey(id, ..., time_zone = time_zone)
    
  } else {
    
    surveys <- dplyr::select(surveys, survey_name = .data$name, survey_id = id)
    surveys <- dplyr::mutate(surveys, responses = purrr::map(.data$survey_id, ~qualtRics::fetch_survey(.x, !!!dots, time_zone = time_zone)))
    
  }
  
  return(surveys)
  
}

#' Reformat Memorial Hermann Survey or Campus Names
#'
#' @description
#' `fix_survey_names()` is a convenience function for reformatting MH Survey
#' names as they appear in the Qualtrics UI to something more legible.
#' `fix_campus_names()` is a similar convenience function that reformats full
#' campus names to their shorthand equivalent.
#'
#' @param .data A tibble. `fix_survey_names()` requires the column `survey_name`
#'   to be present. `fix_campus_names()` requires the column `campus` to be present.
#'
#' @export
#'
#' @importFrom cli cli_abort
#' @importFrom stringr str_remove
#' @importFrom rlang .data
#' @importFrom dplyr case_match
#'
#' @examples
#' # list of survey names as they appear in the qualtrics ui
#' surveys <-
#'   tibble::tibble(
#'     survey_name = c("Live - Adult Day Surgery",
#'                     "Live - Adult Emergency Department",
#'                     "Live - Adult Inpatient Rehab",
#'                     "Live - Adult Medical Practice",
#'                     "Live - Adult Outpatient",
#'                     "Live - Adult Outpatient - Oncology",
#'                     "Live - Adult Outpatient - Vaccine",
#'                     "Live - Adult Outpatient Rehab",
#'                     "Live - Adult Telemedicine",
#'                     "Live - Adult Urgent Care",
#'                     "Live - HCAHPS - Paper",
#'                     "Live - Home Medical Equipment",
#'                     "Live - Infusion Pharmacy",
#'                     "Live - Inpatient",
#'                     "Live - Pediatric - Emergency Department",
#'                     "Live - Pediatric Inpatient")
#'   )
#'
#' # bad names!
#' surveys
#'
#' # better names!
#' fix_survey_names(surveys)
#'
#' # list of campus names as they appear in the qualtrics ui
#' campuses <-
#'   tibble::tibble(
#'     campus = c("Children's Memorial Hermann Hospital",
#'                "Memorial Hermann - Texas Medical Center",
#'                "Memorial Hermann / Rockets Orthopedic Hospital",
#'                "Memorial Hermann Cypress Hospital",
#'                "Memorial Hermann Greater Heights Hospital",
#'                "Memorial Hermann Katy Hospital",
#'                "Memorial Hermann Memorial City Medical Center",
#'                "Memorial Hermann Northeast Hospital",
#'                "Memorial Hermann Pearland Hospital",
#'                "Memorial Hermann Rehabilitation Hospital - Katy",
#'                "Memorial Hermann Southeast Hospital",
#'                "Memorial Hermann Southwest Hospital",
#'                "Memorial Hermann Sugar Land Hospital",
#'                "Memorial Hermann The Woodlands Medical Center",
#'                "TIRR Memorial Hermann")
#'   )
#'
#' # bad names!
#' campuses
#'
#' # better names!
#' fix_campus_names(campuses)
fix_survey_names <- function(.data) {
  
  # check for correct col
  if (!"survey_name" %in% names(.data)) {
    
    cli::cli_abort("Missing needed col: `survey_name`")
    
  }
  
  dplyr::mutate(
    .data,
    survey_name = stringr::str_remove(.data$survey_name, "Live - "),
    survey_name = stringr::str_remove(.data$survey_name, "Adult "),
    survey_name = stringr::str_remove(.data$survey_name, "- "),
    survey_name = stringr::str_remove(.data$survey_name, " Department"),
    survey_name = stringr::str_remove(.data$survey_name, " Paper"),
    survey_name = stringr::str_remove(.data$survey_name, "atric")
  )
  
}

#' @export
#' @rdname fix_survey_names
fix_campus_names <- function(.data) {
  
  # check for correct col
  if (!"campus" %in% names(.data)) {
    
    cli::cli_abort("Missing needed col: `campus`")
    
  }
  
  dplyr::mutate(
    .data,
    campus = dplyr::case_match(.data$campus,
                               "Children's Memorial Hermann Hospital" ~ "CMHH",
                               "Memorial Hermann - Texas Medical Center" ~ "TMC",
                               "Memorial Hermann / Rockets Orthopedic Hospital" ~ "MHROH",
                               "Memorial Hermann Cypress Hospital" ~ "Cypress",
                               "Memorial Hermann Greater Heights Hospital" ~ "Greater Heights",
                               "Memorial Hermann Katy Hospital" ~ "Katy",
                               "Memorial Hermann Memorial City Medical Center" ~ "Memorial City",
                               "Memorial Hermann Northeast Hospital" ~ "Northeast",
                               "Memorial Hermann Pearland Hospital" ~ "Pearland",
                               "Memorial Hermann Rehabilitation Hospital - Katy" ~ "Katy Rehab",
                               "Memorial Hermann Southeast Hospital" ~ "Southeast",
                               "Memorial Hermann Southwest Hospital" ~ "Southwest",
                               "Memorial Hermann Sugar Land Hospital" ~ "Sugar Land",
                               "Memorial Hermann The Woodlands Medical Center" ~ "Woodlands",
                               "TIRR Memorial Hermann" ~ "TIRR",
                               .default = .data$campus)
  )
  
}

#' Remove duplicate responses from the Inpatient survey
#'
#' @description
#' Due to Qualtrics' HCAHPs sampling engine, Memorial Hermann's Inpatient survey
#' is a master file containing responses for Inpatient, Pedi Inpatient, and
#' Inpatient Rehab (Inpatient Rehab was separated out to its own standing survey
#' in early 2022, but historical responses are duplicated across both the
#' Inpatient and Inpatient Rehab survey files). `deduplicate_ip()` takes in a
#' tibble from `fetch_surveys()` and removes duplicated responses from the
#' Inpatient file, using the encounter ID (`"UNIQUE_ID"`) as the key.
#'
#' @param .data a tibble. The column `survey_name` must be present and include 
#'        responses from the Inpatient, Pedaitric Inpatient, and Inpatient Rehab
#'        surveys.
#'
#' @export
#'
#' @importFrom cli cli_abort
#' @importFrom stringr str_detect
#' @importFrom cli cli_alert_info
#' @importFrom dplyr filter
#' @importFrom tidyr unnest
#' @importFrom nplyr nest_anti_join
#' @importFrom dplyr bind_rows
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' # pull in surveys from Qualtrics
#' surveys <-
#'   c("Live - Inpatient",
#'     "Live - Pediatric Inpatient",
#'     "Live - Inpatient Rehab")
#'
#' surveys <- fetch_surveys(surveys)
#'
#' # deduplicate records
#' deduplicate_ip(surveys)
#' }
deduplicate_ip <- function(.data) {
  
  # check format
  df_names <- names(.data)
  if (!"survey_name" %in% df_names | !"responses" %in% df_names) {
    
    cli::cli_abort("Missing one of needed cols: `survey_name` or `responses`")
    
  }
  
  # check if fix_survey_names() has been called already
  if (stringr::str_detect(.data$survey_name[1], "Live")) {
    
    cli::cli_alert_info("Calling `fix_survey_names()`")
    surveys <- fix_survey_names(.data)
    
  } else {
    
    surveys <- .data
    
  }
  
  # check that all three surveys are present
  ip_names <- dplyr::filter(surveys, stringr::str_detect(.data$survey_name, "Inpatient"))$survey_name
  if (length(ip_names) != 3) {
    
    cli::cli_abort("Missing one of needed surveys: Inpatient, Pedi Inpatient, or Inpatient Rehab")
    
  }
  
  # separate out surveys
  ip <- dplyr::filter(surveys, .data$survey_name == "Inpatient")
  pip <- dplyr::filter(surveys, .data$survey_name == "Pedi Inpatient")
  ipr <- dplyr::filter(surveys, .data$survey_name == "Inpatient Rehab")
  
  # unnest pip/ipr to be able to anti join later
  pip <- tidyr::unnest(pip, .data$responses)
  ipr <- tidyr::unnest(ipr, .data$responses)
  
  # remove pip/ipr records from ip
  ip <- nplyr::nest_anti_join(ip, .data$responses, pip, by = "UNIQUE_ID")
  ip <- nplyr::nest_anti_join(ip, .data$responses, ipr, by = "UNIQUE_ID")
  
  # rejoin ip back to the survey frame
  surveys <- dplyr::filter(surveys, .data$survey_name != "Inpatient")
  surveys <- dplyr::bind_rows(surveys, ip)
  
  return(surveys)
  
}

