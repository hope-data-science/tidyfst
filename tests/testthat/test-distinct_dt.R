test_that("distinct_dt", {

  ir = as.data.table(iris)
  mt = as.data.table(mtcars)

  expect_equal(
    iris %>% distinct_dt(),
    unique(ir)
  )

  expect_equal(
    iris %>% distinct_dt(Species),
    unique(ir[,"Species"])
  )

  expect_equal(
    iris %>% distinct_dt(Species,.keep_all = TRUE),
    unique(ir,by = "Species")
  )

  expect_equal(
    mtcars %>% distinct_dt(cyl,vs),
    unique(mt[,c("cyl","vs")])
  )

  expect_equal(
    mtcars %>% distinct_dt(cyl,vs,.keep_all = TRUE),
    unique(mt,by = c("cyl","vs"))
  )

})
