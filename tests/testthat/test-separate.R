test_that("separate a column", {
  df <- data.table(x = c(NA, "a.b", "a.d", "b.c"))

  expect_equal(
    df %>% separate_dt(x, c("A", "B")),
    data.table(A=c(NA,"a","a","b"),B=c(NA,"b","d","c"))
  )

  expect_equal(
    df %>% separate_dt(x, c("A", "B")),
    df %>% separate_dt("x", c("A", "B"))
  )

  expect_equal(
    df %>% separate_dt(x,into = c(NA,"B")),
    data.table(B=c(NA,"b","d","c"))
  )
})
