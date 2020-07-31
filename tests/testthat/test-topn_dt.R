test_that("topn, considered deprecated but still supported here", {
  expect_equal(
    iris %>% top_n_dt(10,Sepal.Length) %>% arrange_dt(-Sepal.Length),
    iris %>% slice_max_dt(Sepal.Length,10)
  )
  expect_equal(
    iris %>% top_n_dt(-10,Sepal.Length) %>% arrange_dt(Sepal.Length),
    iris %>% slice_min_dt(Sepal.Length,10)
  )

  expect_equal(
    iris %>% top_frac_dt(.1,Sepal.Length) %>% arrange_dt(-Sepal.Length),
    iris %>% slice_max_dt(Sepal.Length,.1)
  )
  expect_equal(
    iris %>% top_frac_dt(-.1,Sepal.Length) %>% arrange_dt(Sepal.Length),
    iris %>% slice_min_dt(Sepal.Length,.1)
  )

  expect_equal(
    iris %>% top_dt(Sepal.Length,n = 10),
    iris %>% top_n_dt(10,Sepal.Length)
  )
  expect_equal(
    iris %>% top_dt(Sepal.Length,prop = .1),
    iris %>% top_frac_dt(.1,Sepal.Length)
  )
})
