test_that("set operations", {
  ir = as.data.table(iris)

  x = ir[c(2,3,3,4),]
  x2 = ir[2:4,]
  y = ir[c(3:5),]

  expect_equal(
    intersect_dt(x, y),
    fintersect(x,y)
  )
  expect_equal(
    intersect_dt(x, y, all=TRUE),
    fintersect(x,y, all=TRUE)
  )

  expect_equal(
    setdiff_dt(x, y),
    fsetdiff(x,y)
  )
  expect_equal(
    setdiff_dt(x, y, all=TRUE),
    fsetdiff(x,y, all=TRUE)
  )

  expect_equal(
    union_dt(x, y),
    funion(x,y)
  )
  expect_equal(
    union_dt(x, y, all=TRUE),
    funion(x,y, all=TRUE)
  )

  expect_true(setequal_dt(x, x2, all=FALSE))
  expect_false(setequal_dt(x, x2))
})
