test_that("deduplicate_ip returns a tibble in the expected format", {
  
  x <- 
    generate_fake_data() |>
    deduplicate_ip()
  
  expect_s3_class(x, c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))
  expect_named(x, c("survey_name", "responses"))
  expect_type(x$survey_name, "character")
  expect_type(x$responses, "list")
  expect_equal(nrow(x), 3)
  
})

test_that("deduplicate_ip correctly calls fix_survey_names", {
  
  x <- 
    generate_fake_data() |>
    deduplicate_ip()

  expect_equal(x$survey_name, c("Pedi Inpatient", "Inpatient Rehab", "Inpatient"))
  
})

test_that("deduplicate_ip correctly removes duplicate responses", {
  
  x <- 
    generate_fake_data() |>
    deduplicate_ip() |>
    tidyr::unnest(responses)
  
  expect_equal(nrow(x), 6)
  expect_equal(nrow(dplyr::distinct(x, UNIQUE_ID)), 6)
  
})

test_that("deduplicate_ip throws warnings and errors as expected", {
  
  # check that all expected columns are present
  error_message <- "Missing one of needed cols: `survey_name` or `responses`"
  
  expect_error(
    generate_fake_data() |>
      dplyr::select(-survey_name) |>
      deduplicate_ip(),
    error_message
  )
  
  expect_error(
    generate_fake_data() |>
      dplyr::select(-responses) |>
      deduplicate_ip(),
    error_message
  )
  
  # check that all expected surveys are present
  error_message <- "Missing one of needed surveys: Inpatient, Pedi Inpatient, or Inpatient Rehab"
  
  expect_error(
    generate_fake_data() |>
      dplyr::filter(survey_name != "Live - Pediatric Inpatient") |>
      deduplicate_ip(),
    error_message
  )
  
  expect_error(
    generate_fake_data() |>
      dplyr::filter(survey_name != "Live - Inpatient") |>
      deduplicate_ip(),
    error_message
  )
  
  expect_error(
    generate_fake_data() |>
      dplyr::filter(survey_name != "Live - Adult Inpatient Rehab") |>
      deduplicate_ip(),
    error_message
  )
  
})

