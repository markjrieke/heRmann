library(vcr) # *Required* as vcr is set up on loading

# load in credentials
readRenviron("~/.Renviron")

invisible(vcr::vcr_configure(
  filter_sensitive_data = list("<<<my_api_key>>>" = Sys.getenv("QUALTRICS_API_KEY")),
  dir = vcr::vcr_test_path("fixtures")
))
vcr::check_cassette_names()
