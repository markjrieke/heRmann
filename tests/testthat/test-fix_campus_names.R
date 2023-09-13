test_that("fix_campus_names returns a tibble in the expected format", {
  
  x <- 
    generate_fake_data() |>
    tidyr::unnest(responses) |>
    fix_campus_names()
  
  expect_s3_class(x, c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))
  expect_named(x, c("survey_name", "UNIQUE_ID", "campus", "response"))
  expect_type(x$survey_name, "character")
  expect_type(x$UNIQUE_ID, "character")
  expect_type(x$campus, "character")
  expect_type(x$response, "character")
  expect_equal(nrow(x), 9)
  
})

test_that("fix_campus_names updates names correctly", {
  
  x <- 
    generate_fake_data() |>
    tidyr::unnest(responses) |>
    fix_campus_names()

  expect_equal(x$campus, c("CMHH", rep("TMC", 5), "CMHH", rep("TMC", 2)))
  
})

test_that("fix_campus_names correctly throws an error when `campus` is missing", {
  
  expect_error(
    generate_fake_data() |>
      tidyr::unnest(responses) |>
      dplyr::select(-campus) |>
      fix_campus_names(), 
    "Missing needed col: `campus`"
  )
  
})