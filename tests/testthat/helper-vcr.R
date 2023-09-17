library(vcr) # *Required* as vcr is set up on loading

# load in credentials
readRenviron("~/.Renviron")

# store recode path for resetting later when needed
holder_PATH <- Sys.getenv("MEMORIAL_HERMANN_RECODE_PATH")

invisible(vcr::vcr_configure(
  filter_sensitive_data = list("<<<my_api_key>>>" = Sys.getenv("QUALTRICS_API_KEY")),
  dir = vcr::vcr_test_path("fixtures")
))
vcr::check_cassette_names()
