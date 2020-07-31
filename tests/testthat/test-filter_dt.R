test_that("filter a data.frame", {
  ir = as.data.table(iris)

  expect_equal(
    iris %>% filter_dt(Sepal.Length > 7),
    ir[Sepal.Length > 7]
  )

  expect_equal(
    iris %>% filter_dt(Sepal.Length > 7 & Sepal.Width > 3),
    ir[Sepal.Length > 7 & Sepal.Width > 3]
  )

  expect_equal(
    iris %>% filter_dt(Sepal.Length > 7 | Sepal.Width > 3),
    ir[Sepal.Length > 7 | Sepal.Width > 3]
  )

  expect_equal(
    iris %>% filter_dt(Sepal.Length == max(Sepal.Length)),
    ir[Sepal.Length == max(Sepal.Length)]
  )

})
