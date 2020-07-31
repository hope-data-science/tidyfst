test_that("slice", {
  ir = as.data.table(iris)

  expect_equal(
    ir %>% slice_dt(1,3),
    ir[c(1,3)]
  )
  expect_equal(
    ir %>% slice_dt(1:3),
    ir[1:3]
  )

  expect_equal(
    ir %>% slice_head_dt(3),
    ir %>% head(3)
  )
  expect_equal(
    ir %>% slice_tail_dt(3),
    ir %>% tail(3)
  )

  expect_equal(
    ir %>% slice_max_dt(Sepal.Length,3),
    ir[order(-Sepal.Length)][1:5]
  )
  expect_equal(
    ir %>% slice_min_dt(Sepal.Length,3),
    ir[order(Sepal.Length)][1:4]
  )

  expect_equal(
    ir %>% slice_max_dt(Sepal.Length,3,with_ties = FALSE),
    ir[order(-Sepal.Length)][1:3]
  )
  expect_equal(
    ir %>% slice_min_dt(Sepal.Length,3,with_ties = FALSE),
    ir[order(Sepal.Length)][1:3]
  )

})

test_that("slice by group",{
  a = as.data.table(iris)

  expect_equal(
    slice_dt(a,1:3,by = Species),
    a[,.SD[1:3],by = Species]
  )
  expect_equal(
    slice_dt(a,1:3,by = Species),
    slice_dt(a,1:3,by = "Species")
  )
  expect_equal(
    slice_dt(a,1:3,by = Species),
    slice_dt(a,1:3,by = .(Species))
  )

  expect_equal(
    slice_head_dt(a,2,by = Species),
    a[,head(.SD,2),by = Species]
  )
  expect_equal(
    slice_tail_dt(a,2,by = Species),
    a[,tail(.SD,2),by = Species]
  )

  expect_equal(
    slice_max_dt(a,Sepal.Length,3,by = Species),
    a[,.SD[Sepal.Length %in% sort(Sepal.Length,TRUE)[1:3]],by = Species]
  )
  expect_equal(
    slice_min_dt(a,Sepal.Length,3,by = Species),
    a[,.SD[Sepal.Length %in% sort(Sepal.Length)[1:3]],by = Species]
  )
})




