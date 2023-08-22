#' Set a path for retrieving MH recodes
#'
#' @description
#' Saves an environment variable containing the path to the recode list. Saved as
#' `MEMORIAL_HERMANN_RECODE_PATH`.
#'
#' @param path folder path to recode list. E.g., `"path/to/recode/list/"`.
#' @param install save the folder path to your .Renviron for future use.
#'
#' @importFrom askpass askpass
#' @importFrom cli cli_alert_info
#' @importFrom cli cli_alert_success
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   set_recode_path("made/up/path/file.csv")
#' }
set_recode_path <- function(path = NULL, install = TRUE) {
  
  if (is.null(path)) {
    path <- askpass::askpass("Please enter the path to the recode list.")
  }
  
  # writing to reusable env taken from the qualtRics package with minor modifications
  if (install) {
    
    # check for existing .Renviron & create new if need
    home <- Sys.getenv("HOME")
    renv <- file.path(home, ".Renviron")
    if (file.exists(renv)) {
      file.copy(renv, file.path(home, ".Renviron_backup"), overwrite = TRUE)
      cli::cli_alert_info("Backup of .Renviorn saved in home directory.")
    }
    if (!file.exists(renv)) {
      file.create(renv)
    }
    else {
      oldenv <- readLines(renv)
      if (any(grepl("MEMORIAL_HERMANN_RECODE_PATH", oldenv))) {
        cli::cli_alert_info("Path variable already exists. Overwriting path.")
      }
      
      # overwrite path variable
      newenv <- oldenv[-grep("MEMORIAL_HERMANN_RECODE_PATH", oldenv)]
      writeLines(newenv, renv)
      
    }
    
    # write out
    path_concat <- paste0("MEMORIAL_HERMANN_RECODE_PATH = '", path, "'")
    write(path_concat, renv, sep = "\n", append = TRUE)
    
    cli::cli_alert_success("Path saved! To use now, restart R or run `readRenviron(\"~/.Renviron\")`")
    
  }
  else {
    cli::cli_alert_info("To install the path for use in future sessions, run this function with `install = TRUE`.")
    Sys.setenv(MEMORIAL_HERMANN_RECODE_PATH = path)
  }
}

#' Read Memorial Hermann recodes from version control.
#'
#' @description
#' Reads in Memorial Hermann recodes from version control. Specify the exact
#' recode document to be used by setting the recode path with `set_recode_path()`.
#'
#' @param file recode file name to read in. Reads in from the `edit` directory.
#'
#' @importFrom cli cli_abort
#' @importFrom readr read_csv
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   read_recodes()
#' }
read_recodes <- function(file = "consolidated") {
  
  path <- Sys.getenv("MEMORIAL_HERMANN_RECODE_PATH")
  if (path == "") {
    cli::cli_abort("No path available in the environment. Please call `set_recode_path()`.")
  }
  
  file <- readr::read_csv(paste0(path, file, ".csv"))
  
  return(file)
  
}