test_that("fix_survey_names returns a tibble in the expected format", {
  
  x <- generate_fake_data()
  x <- fix_survey_names(x)
  
  expect_s3_class(x, c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))
  expect_named(x, c("survey_name", "responses"))
  expect_type(x$survey_name, "character")
  expect_type(x$responses, "list")
  expect_equal(nrow(x), 3)
  
})

test_that("fix_survey_names updates names correctly", {
  
  x <- generate_fake_data()
  x <- fix_survey_names(x)
  
  expect_equal(x$survey_name, c("Inpatient", "Pedi Inpatient", "Inpatient Rehab"))
  
})

test_that("fix_survey_names correctly throws an error when `survey_name` is missing", {
  
  x <- generate_fake_data()
  
  expect_error(
    fix_survey_names(x[,2]),
    "Missing needed col: `survey_name`"
  )
  
})