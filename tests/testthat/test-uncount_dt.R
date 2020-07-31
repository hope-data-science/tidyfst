test_that("uncount", {
  df <- data.table(x = c("a", "b"), n = c(1, 2))

  expect_equal(
    uncount_dt(df, n),
    data.table(x = c("a","b","b"))
  )

  expect_equal(
    uncount_dt(df,n,FALSE),
    data.table(x = c("a","b","b"),n = c(1,2,2))
  )

})
