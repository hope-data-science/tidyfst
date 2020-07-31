test_that("convert data.frame from long to wide", {

  stocks = data.table(
    time = as.Date('2009-01-01') + 0:9,
    X = rnorm(10, 0, 1),
    Y = rnorm(10, 0, 2),
    Z = rnorm(10, 0, 4)
  )

  stocks %>%
    longer_dt(time) -> longer_stocks

  expect_equal(
    longer_stocks %>%
      wider_dt("time",
               name = "name",
               value = "value"),
    stocks,check.attributes = FALSE
  )
})



