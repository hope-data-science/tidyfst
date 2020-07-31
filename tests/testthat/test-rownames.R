

test_that("trun rownames to column or column to rownames", {

  expect_equal(
    mtcars %>% rn_col(),
    as.data.table(mtcars)[,rowname := rownames(mtcars)] %>%
      relocate_dt(rowname)
  )

  expect_equal(
    mtcars %>% rn_col("rn"),
    as.data.table(mtcars)[,rn := rownames(mtcars)] %>%
      relocate_dt(rn)
  )

  expect_equal(
    mtcars %>% rn_col() %>% col_rn(),
    mtcars
  )
})
