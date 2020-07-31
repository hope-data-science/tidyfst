

test_that("count", {
  ir = as.data.table(iris)
  mt = as.data.table(mtcars)

  expect_equal(iris %>% count_dt(Species),
               ir[,.(n = .N),by = Species])

  expect_equal(
    iris %>% count_dt(Species,.name = "count"),
    ir[,.(count = .N),by = Species]
  )

  expect_equal(
    mtcars %>% count_dt(cyl,vs),
    mt[,.(n = .N),by = "cyl,vs"][order(-n)]
  )

  expect_equal(
    mtcars %>% count_dt(cyl,vs),
    mtcars %>% count_dt("cyl|vs")
  )

})

test_that("add_count", {
  ir = as.data.table(iris)
  mt = as.data.table(mtcars)

  expect_equal(
    iris %>% add_count_dt(Species),
    copy(ir)[,n:=.N,by=Species]
  )

  expect_equal(
    iris %>% add_count_dt(Species,.name = "N"),
    copy(ir)[,N:=.N,by=Species][]
  )

  expect_equal(
    mtcars %>% add_count_dt(cyl,vs),
    copy(mt)[,n:=.N,by=.(cyl,vs)][]
  )

  expect_equal(
    mtcars %>% add_count_dt(cyl,vs),
    mtcars %>% add_count_dt("cyl|vs")
  )

})

