test_that("able to set and retrieve recode path", {
  
  fake_path <- "path/to/recode/list/"
  set_recode_path(fake_path)
  readRenviron("~/.Renviron")
  
  expect_match(
    Sys.getenv("MEMORIAL_HERMANN_RECODE_PATH"),
    fake_path
  )
  
})

# restore the original path
set_recode_path(path = holder_PATH)
readRenviron("~/.Renviron")



