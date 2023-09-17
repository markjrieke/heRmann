test_that("rnps returns random draws in the expected format", {
  
  x <- rnps(100, 70, 10, 20)
  
  expect_type(x, "double")
  expect_length(x, 100)
  
})

test_that("qnps returns vector in the expected format", {
  
  x <- qnps(c(0.025, 0.5, 0.975), 70, 10, 20)
  
  expect_type(x, "double")
  expect_length(x, 3)
  
})

test_that("qnps returns named vector when specified", {
  
  x <- 
    qnps(
      c(0.025, 0.5, 0.975),
      promoters = 70,
      passives = 10,
      detractors = 20,
      names = TRUE
    )
  
  expect_named(x, c("2.5%", "50%", "97.5%"))
  
})



