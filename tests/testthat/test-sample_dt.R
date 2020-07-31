test_that("sample", {

  expect_is(
    sample_n_dt(mtcars, 1),
    "data.table"
  )

  expect_is(
    sample_n_dt(mtcars, 1),
    "data.frame"
  )

  expect_is(
    sample_frac_dt(mtcars, .1),
    "data.table"
  )

  expect_is(
    sample_frac_dt(mtcars, .1),
    "data.frame"
  )

})
