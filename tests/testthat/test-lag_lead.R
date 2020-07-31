test_that("lag and lead", {
  expect_equal(
    lead_dt(1:5),
    shift(1:5,type = "lead")
  )
  expect_equal(
    lag_dt(1:5),
    shift(1:5,type = "lag")
  )
  expect_equal(
    lag_dt(1:5,n = 2),
    shift(1:5,n = 2,type = "lag")
  )
  expect_equal(
    lead_dt(1:5,n = 2,fill = 0),
    shift(1:5,n = 2,type = "lead",fill = 0)
  )
})
