test_that("rename columns", {
  ir = as.data.table(iris)
  expect_equal(
    iris %>%
      rename_dt(sl = Sepal.Length,sw = Sepal.Width) ,
    setnames(copy(ir),old = 1:2,new = c("sl","sw"))
  )

  expect_equal(
    iris %>% rename_with_dt(toupper),
    copy(ir) %>% setnames(old = names(ir),new = names(ir) %>% toupper())
  )

  expect_equal(
    iris %>% rename_with_dt(toupper,"^Pe"),
    copy(ir) %>% setnames(old = 3:4,new = names(iris)[3:4] %>% toupper())
  )

})
