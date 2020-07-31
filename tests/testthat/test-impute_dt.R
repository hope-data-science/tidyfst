test_that("impute values", {
  data = data.table(a = c(1,2,NA,2,4),b = c(T,F,T,NA,T))

  expect_equal(
    data %>% impute_dt(),
    data.table(a = c(1,2,2,2,4),b = c(T,F,T,T,T))
  )
  expect_equal(
    data %>% impute_dt(is.numeric,.func = "mean"),
    data.table(a = c(1,2,2.25,2,4),b = c(T,F,T,NA,T))
  )
  expect_equal(
    data %>% impute_dt(is.numeric,.func = "median"),
    data.table(a = c(1,2,2,2,4),b = c(T,F,T,NA,T))
  )
})





