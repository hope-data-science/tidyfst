test_that("conversion between matrix and data.frame", {

  mm = matrix(c(1:8,NA),ncol = 3,dimnames = list(letters[1:3],LETTERS[1:3]))
  tdf = data.frame(
    row = as.factor(c("a",
                      "b","c","a","b","c","a",
                      "b","c")),
    col = as.factor(c("A",
                      "A","A","B","B","B","C",
                      "C","C")),
    value = c(1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, NA)
  )

  expect_equal(mat_df(mm),tdf)
  expect_equal(mm,df_mat(tdf,row,col,value))

})

test_that("transpose of data.frame",{
  expect_equal(
    transpose(iris),
    t_dt(iris) %>% setDT %>% setDF()
  )
})
