


test_that("arrange a data.frame", {

  ir = as.data.table(iris)

  expect_equal(iris %>% arrange_dt(Sepal.Length),ir[order(Sepal.Length)])

  expect_equal(iris %>% arrange_dt(-Sepal.Length),ir[order(-Sepal.Length)])

  expect_equal(iris %>% arrange_dt(Sepal.Length,Petal.Length),
               ir[order(Sepal.Length,Petal.Length)])

  expect_equal(iris %>% arrange_dt(Sepal.Length,-Petal.Length),
               ir[order(Sepal.Length,-Petal.Length)])
})
