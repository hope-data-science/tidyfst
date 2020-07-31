test_that("cummean", {
  expect_equal(
    cummean(1:10),
    cumsum(1:10)/seq_along(1:10)
  )
})
