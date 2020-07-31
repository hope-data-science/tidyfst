test_that("as_dt", {
  ir = as_dt(iris)
  expect_equal(ir,as.data.table(iris))
})

test_that("in_dt",{
  ir = as_dt(iris)
  expect_equal(
    iris %>% in_dt(order(-Sepal.Length),.SD[.N],by=Species),
    ir[order(-Sepal.Length),.SD[.N],by=Species]
  )
})
