
test_that("make dummy variables", {
  ir = as.data.table(iris)[,`:=`(one=1,id=1:.N)]
  expect_equal(
    iris %>% dummy_dt(Species,longname = FALSE),
    dcast(ir,...~Species,value.var = "one",fill = 0)[,id:=NULL]
  )

  # use long name
  ir = as.data.table(iris)[,`:=`(one=1,id=1:.N)]
  ir[["Species"]] %>% as.character() %>% unique() -> short_name
  long_name = str_c("Species_",short_name)

  expect_equal(
    iris %>% dummy_dt(Species,longname = TRUE),
    dcast(ir,...~Species,value.var = "one",fill = 0)[,id:=NULL] %>%
      setnames(old = short_name,new = long_name)
  )
})







