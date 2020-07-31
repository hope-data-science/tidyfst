test_that("complete a data.frame", {
  df <- data.table(
    group = c(1:2, 1),
    item_id = c(1:2, 2),
    item_name = c("a", "b", "b"),
    value1 = 1:3,
    value2 = 4:6
  )

  attach(df)

  expect_equal(
    df %>% complete_dt(group,item_id,item_name) ,
    df %>% merge.data.table(CJ(group,item_id,item_name,unique = TRUE),
                            by = c("group","item_id","item_name"),all = TRUE)
  )

  # use regex for shortcut to select colnames
  expect_equal(
    df %>% complete_dt("item"),
    df %>% complete_dt(item_id,item_name)
  )

  # to complete with self-defined combinations
  expect_equal(
    df %>% complete_dt(group=1:3,item_id=1:3,item_name=c("a","b","c")),
    df %>% merge.data.table(CJ(item_id=1:3,
                               group=1:3,
                               item_name=c("a","b","c"),
                               unique = TRUE),
                            by = c("group","item_id","item_name"),all = TRUE)
  )

})
