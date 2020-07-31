test_that("summarise", {
  ir = as.data.table(iris)

  expect_equal(
    iris %>% summarise_dt(avg = mean(Sepal.Length)),
    ir[,.(avg = mean(Sepal.Length))]
  )
  expect_equal(
    iris %>% summarise_dt(avg = mean(Sepal.Length),by = Species),
    ir[,.(avg = mean(Sepal.Length)),by = Species]
  )

  expect_equal(
    iris %>% summarise_vars(is.numeric,mean) %>% as.numeric(),
    ir[,1:4] %>% colMeans() %>% as.numeric()
  )
  expect_equal(
    iris %>% summarise_vars(is.numeric,min),
    iris %>% summarise_vars(-is.factor,min)
  )
  expect_equal(
    iris %>% summarise_vars(is.numeric,min),
    iris %>% summarise_vars(1:4,min)
  )
  expect_equal(
    iris %>% summarise_vars(is.numeric,min,by ="Species"),
    ir[,lapply(.SD,min), by = "Species"]
  )
})
