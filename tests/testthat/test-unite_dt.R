test_that("unite a data.frame", {

  df <- expand.grid(x = c("a", NA), y = c("b", NA))
  expect_equal(
    df %>% unite_dt("z", x:y, remove = FALSE),
    data.table(
      x = as.factor(c("a", NA, "a", NA)),
      y = as.factor(c("b", "b", NA, NA)),
      z = c("a_b", NA, NA, NA)
    ),check.attributes = FALSE
  )

  expect_equal(
    df %>% unite_dt("z", x:y, na2char = TRUE, remove = FALSE),
    data.table(
      x = as.factor(c("a", NA, "a", NA)),
      y = as.factor(c("b", "b", NA, NA)),
      z = c("a_b", "NA_b", "a_NA", "NA_NA")
    ),check.attributes = FALSE
  )

  expect_equal(
    df %>% unite_dt("xy", x:y, remove = FALSE),
    data.table(
      x = as.factor(c("a", NA, "a", NA)),
      y = as.factor(c("b", "b", NA, NA)),
      xy = c("a_b", NA, NA, NA)
    ),check.attributes = FALSE
  )
})





