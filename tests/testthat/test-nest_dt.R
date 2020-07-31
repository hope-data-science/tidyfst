test_that("nest", {
  mt = as.data.table(mtcars)

  expect_equal(
    mtcars %>% nest_dt(cyl),
    mt[,.(ndt = list(.SD)),by = cyl]
  )

  expect_equal(
    mtcars %>% nest_dt(cyl,.name = "data"),
    mt[,.(data = list(.SD)),by = cyl]
  )

  expect_equal(
    mtcars %>% nest_dt(cyl),
    mtcars %>% nest_dt("cyl")
  )

  expect_equal(
    mtcars %>% nest_dt(cyl,vs),
    mtcars %>% nest_dt("cyl|vs")
  )

  expect_equal(
    mtcars %>% nest_dt(cyl,vs),
    mtcars %>% nest_dt(c("cyl","vs"))
  )

})

test_that("unnest",{
  mt = as.data.table(mtcars)

  expect_equal(
    mtcars %>% nest_dt("cyl") %>%
      unnest_dt(ndt),
    mt[,.(ndt = list(.SD)),by = .(cyl)][,
      unlist(ndt,recursive = FALSE),
      by = cyl
    ]
  )

  expect_equal(
    mtcars %>% nest_dt("cyl|vs") %>%
      unnest_dt(ndt),
    mtcars %>% nest_dt("cyl|vs") %>%
      unnest_dt("ndt")
  )
})

test_that("squeeze/chop/unchop",{
  expect_equal(
    iris %>% squeeze_dt(1:2),
    iris %>% squeeze_dt("Se")
  )

  df <- data.table(x = c(1, 1, 1, 2, 2, 3), y = 1:6, z = 6:1)
  expect_equal(
    df %>% chop_dt(y,z),
    df[,lapply(.SD,list),by = x]
  )

  expect_equal(
    df %>% chop_dt(y,z) %>% unchop_dt(y,z),
    df
  )

})







