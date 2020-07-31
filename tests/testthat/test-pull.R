test_that("pull", {
  expect_equal(
    mtcars %>% pull_dt(2),
    mtcars[,2]
  )

  expect_equal(
    mtcars %>% pull_dt(cyl),
    mtcars[["cyl"]]
  )

  expect_equal(
    mtcars %>% pull_dt(cyl),
    mtcars %>% pull_dt("cyl")
  )
})
