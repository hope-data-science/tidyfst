test_that("nth", {
  x = 1:10

  expect_equal(nth(x,1),1)
  expect_equal(nth(x,5),5)
  expect_equal(nth(x,-1),10)
  expect_equal(nth(x,-2),9)
})
