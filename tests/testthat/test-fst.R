test_that("import and export fst", {

  path <- paste0(tempfile(), ".fst")
  write_fst(iris, path)

  path2 <- paste0(tempfile(), ".fst")
  export_fst(iris,path2)

  expect_equal(read_fst(path,as.data.table = TRUE),import_fst(path2))
})

test_that("use fst workflow in tidyfst",{

  path <- paste0(tempfile(), ".fst")
  export_fst(iris, path)

  ft = parse_fst(path)
  ir = as.data.table(iris)

  # slice
  expect_equal(
    ft %>% slice_fst(1:3),
    ir[1:3]
  )
  expect_equal(
    ft %>% slice_fst(c(1,3)),
    ir[c(1,3)]
  )

  # select
  expect_equal(ft %>% select_fst(Sepal.Length),ir[,"Sepal.Length"])
  expect_equal(ft %>% select_fst("Sepal.Length"),ir[,"Sepal.Length"])
  expect_equal(
    ft %>% select_fst("Se"),
    ir[,.SD,.SDcols = patterns("Se")]
  )
  expect_equal(
    ft %>% select_fst(cols = names(ft)[2:3]),
    ir[,.SD,.SDcols = names(ir)[2:3]]
  )
  expect_warning(ft %>% select_fst("nothing"))

  #filter
  expect_equal(
    ft %>% filter_fst(Sepal.Width > 3),
    ir[Sepal.Width > 3]
  )
  expect_equal(
    ft %>% filter_fst(Sepal.Length > 6 & Species == "virginica" & Sepal.Width < 3),
    ir[Sepal.Length > 6 & Species == "virginica" & Sepal.Width < 3]
  )

})



