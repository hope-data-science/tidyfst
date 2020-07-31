test_that("from wide to long", {
  stocks = data.table(
    time = as.Date('2009-01-01') + 0:9,
    X = rnorm(10, 0, 1),
    Y = rnorm(10, 0, 2),
    Z = rnorm(10, 0, 4)
  )

  expect_equal(
    stocks %>% longer_dt(time),
    melt(stocks,id = "time",variable.name = "name")
  )
  # use regex to select grouping column(s)
  expect_equal(
    stocks %>% longer_dt(time),
    stocks %>% longer_dt("ti")
  )

})
