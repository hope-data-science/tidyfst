test_that("drop na", {
  df <- data.table(x = c(1, 2, NA), y = c("a", NA, "b"))

  expect_equal(
    df %>% drop_na_dt(),
    na.omit(df)
  )

  expect_equal(
    df %>% drop_na_dt(x),
    df[!is.na(x)]
  )

  expect_equal(
    df %>% drop_na_dt(x,y),
    df[!is.na(x) & !is.na(y)]
  )

})

test_that("replace na or anything",{
  df <- data.table(x = c(1, 2, NA), y = c("a", NA, "b"))

  expect_equal(
    df %>% replace_na_dt(to = 0),
    df %>% replace_na_dt(x,y,to = 0)
  )

  expect_equal(
    df %>% replace_na_dt(to = 0),
    data.table(x = c(1, 2, 0), y = c("a", "0", "b"))
  )

  expect_equal(
    df %>% replace_na_dt(x,to = 0),
    setnafill(copy(df),fill = 0,cols = "x")
  )

  expect_equal(
    df %>% replace_dt(x,from = 1,to = 3),
    data.table(x = c(3, 2, NA), y = c("a", NA, "b"))
  )

})

test_that("fill na",{
  df <- data.table(x = c(1, 2, NA), y = c("a", NA, "b"))

  expect_equal(
    df %>% fill_na_dt(x),
    setnafill(copy(df),type = "locf",cols = "x")
  )

  expect_equal(
    df %>% fill_na_dt(y,direction = "up"),
    data.table(x = c(1, 2, NA), y = c("a", "b", "b"))
  )

  expect_equal(
    df %>% fill_na_dt(),
    data.table(x = c(1, 2, 2), y = c("a", "a", "b"))
  )

})

test_that("delete na cols",{
  x = data.table(x = c(1, 2, NA, 3), y = c(NA, NA, 4, 5),z = rep(NA,4))

  expect_equal(
    x %>% delete_na_cols(),
    x[,1:2]
  )

  expect_equal(
    x %>% delete_na_cols(prop = 0.5),
    x[,1]
  )

  expect_equal(
    x %>% delete_na_cols(n = 2),
    x[,1]
  )

})

test_that("delete na rows",{
  x = data.table(x = c(1, 2, NA, 3), y = c(NA, NA, 4, 5),z = rep(NA,4))

  expect_equal(
    x %>% delete_na_rows(prop = 0.6),
    x[4]
  )

  expect_equal(
    x %>% delete_na_rows(prop = 0.6),
    x %>% delete_na_rows(n = 2)
  )
})




