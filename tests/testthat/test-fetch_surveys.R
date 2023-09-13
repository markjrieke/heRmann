test_that("fetch_surveys returns a single survey in the expected format", {

  skip_on_ci()
  
  vcr::use_cassette("fetch_single_survey", {

    x <-
      fetch_surveys(
        "survey_example_1",
        force_request = TRUE
      )

  })

  expect_s3_class(x, c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))
  expect_named(x, c("StartDate", "EndDate", "Status", "IPAddress", "Progress",
                    "Duration (in seconds)", "Finished", "RecordedDate",
                    "ResponseId", "RecipientLastName", "RecipientFirstName",
                    "RecipientEmail", "ExternalReference", "LocationLatitude",
                    "LocationLongitude", "DistributionChannel", "UserLanguage",
                    "Q1_1", "Q2", "Q3", "Q4", "Q5_1"))

  expect_type(x$StartDate, "double")
  expect_type(x$EndDate, "double")
  expect_type(x$Status, "character")
  # not checking IP, test responses so all na -> lgl
  expect_type(x$Progress, "double")
  expect_type(x$`Duration (in seconds)`, "double")
  expect_type(x$Finished, "logical")
  expect_type(x$RecordedDate, "double")
  expect_type(x$ResponseId, "character")
  # not checking external reference, test responses so all na -> lgl
  expect_type(x$LocationLatitude, "double")
  expect_type(x$LocationLongitude, "double")
  expect_type(x$DistributionChannel, "character")
  # not checking userlanguage, test responses so all na -> lgl
  expect_type(x$Q1_1, "double")
  expect_type(x$Q2, "integer")
  expect_type(x$Q3, "integer")
  expect_type(x$Q4, "integer")
  expect_type(x$Q5_1, "double")

  expect_equal(nrow(x), 500)

})

test_that("fetch_surveys returns multiple surveys in the expected format", {

  skip_on_ci()
  
  vcr::use_cassette("fetch_survey_multiple", {

    x <-
      fetch_surveys(
        c("survey_example_1", "survey_example_2"),
        force_request = TRUE
      )

  })

  expect_s3_class(x, c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))
  expect_named(x, c("survey_name", "survey_id", "responses"))
  expect_s3_class(x$responses[[1]], c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))
  expect_equal(nrow(x$responses[[1]]), 750)
  expect_equal(nrow(x$responses[[2]]), 500)

})

test_that("fetch_surveys returns an error when no survey names match", {

  skip_on_ci()
  
  vcr::use_cassette("fetch_surveys_error", {

    expect_error(
      fetch_surveys("this wont work"),
      "No surveys match values supplied to `survey_names`"
    )

  })

})

test_that("fetch_surveys returns a warning when some survey names match", {

  skip_on_ci()
  
  vcr::use_cassette("fetch_surveys_warning", {

    # generate a warning snapshot
    expect_snapshot(
      x <- fetch_surveys(c("survey_example_1", "survey_example_2", "this wont work"),
                         force_request = TRUE)
    )

  })

})


