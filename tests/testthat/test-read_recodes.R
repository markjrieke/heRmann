test_that("read_recodes returns the consolidated recode file in the expected format", {
  
  skip_on_ci()
  
  x <- read_recodes()
  
  expect_s3_class(x, c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))
  
  # only checking the highly important cols
  cols <- names(x)
  expect_true("unit_code" %in% cols)
  expect_true("unit" %in% cols)
  expect_true("campus" %in% cols)
  expect_type(x$unit_code, "character")
  expect_type(x$unit, "character")
  expect_type(x$campus, "character")
  
})

test_that("read_recodes returns other recode files in the expected format", {
  
  skip_on_ci()
  
  x <- read_recodes("race")
  
  expect_s3_class(x, c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))
  expect_type(x$Source, "character")
  expect_type(x$Recode, "character")
  
})





