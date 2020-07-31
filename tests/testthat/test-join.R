test_that("join", {

  workers = fread("
    name company
    Nick Acme
    John Ajax
    Daniela Ajax
")

  positions = fread("
    name position
    John designer
    Daniela engineer
    Cathie manager
")


  expect_equal(
    workers %>% inner_join_dt(positions),
    workers %>% merge.data.table(positions)
  )
  expect_equal(
    workers %>% left_join_dt(positions),
    workers %>% merge.data.table(positions,all.x = TRUE)
  )
  expect_equal(
    workers %>% right_join_dt(positions),
    workers %>% merge.data.table(positions,all.y = TRUE)
  )
  expect_equal(
    workers %>% full_join_dt(positions),
    workers %>% merge.data.table(positions,all = TRUE)
  )
  expect_equal(
    workers %>% anti_join_dt(positions),
    workers[!positions,on = "name"]
  )
  expect_equal(
    workers %>% semi_join_dt(positions),
    fsetdiff(workers,workers[!positions,on = "name"])
  )
})
