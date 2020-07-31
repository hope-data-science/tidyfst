test_that("select columns", {
  ir = as.data.table(iris)

  expect_equal(
    iris %>% select_dt(Species),
    ir[,"Species"]
  )

  expect_equal(
    iris %>% select_dt(5),
    iris %>% select_dt(Species)
  )

  expect_equal(
    iris %>% select_dt(-(1:4)),
    iris %>% select_dt(Species)
  )

  expect_equal(
    iris %>% select_dt("Species"),
    iris %>% select_dt(Species)
  )

  expect_equal(
    iris %>% select_dt("Spe"),
    iris %>% select_dt(Species)
  )

  expect_equal(
    iris %>% select_dt("Pe|Se",negate = TRUE),
    iris %>% select_dt(Species)
  )

  expect_equal(
    iris %>% select_dt(is.factor),
    iris %>% select_dt(Species)
  )

  expect_equal(
    iris %>% select_dt(-is.numeric),
    iris %>% select_dt(Species)
  )

  expect_equal(
    iris %>% select_dt(cols = 5),
    iris %>% select_dt(Species)
  )

  expect_equal(
    iris %>% select_dt(cols = names(iris)[5]),
    iris %>% select_dt(Species)
  )

  expect_equal(
    iris %>% select_dt(cols = "Species"),
    iris %>% select_dt(Species)
  )

  expect_equal(
    iris %>% select_mix(1:2,is.factor),
    ir[,c(1,2,5)]
  )

})







