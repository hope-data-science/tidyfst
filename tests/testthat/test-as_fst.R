test_that("save as temp fst table", {

  iris %>% as_fst() -> iris_fst

  expect_named(iris_fst)
  expect_named(iris_fst,names(iris))

  expect_equal(iris_fst[],iris)

})
