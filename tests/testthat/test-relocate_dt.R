test_that("relocate columns", {
  df <- data.table(a = 1, b = 1, c = 1, d = "a", e = "a", f = "a")

  expect_equal(
    df %>% relocate_dt(f),
    data.table(f = "a",a = 1, b = 1, c = 1, d = "a", e = "a")
  )

  expect_equal(
    df %>% relocate_dt(a,how = "last"),
    data.table(b = 1, c = 1, d = "a", e = "a", f = "a",a = 1)
  )

  expect_equal(
    df %>% relocate_dt(is.character),
    data.table(d = "a", e = "a", f = "a",a = 1, b = 1, c = 1)
  )

  expect_equal(
    df %>% relocate_dt(is.numeric, how = "last"),
    data.table(d = "a", e = "a", f = "a",a = 1, b = 1, c = 1)
  )

})
