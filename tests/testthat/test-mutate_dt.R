test_that("mutate and transmute", {

   ir = as.data.table(iris)

  expect_equal(
    iris %>% mutate_dt(one = 1,Sepal.Length = Sepal.Length + 1),
    copy(ir)[,`:=`(one = 1,Sepal.Length = Sepal.Length + 1)]
  )

  expect_equal(
    iris %>% mutate_dt(id = 1:.N,grp = .GRP,by = Species),
    copy(ir)[,`:=`(id = 1:.N,grp = .GRP),by = Species]
  )

  expect_equal(
    iris %>% transmute_dt(one = 1,Sepal.Length = Sepal.Length + 1),
    ir[,.(one = 1,Sepal.Length = Sepal.Length + 1)]
  )

})
