test_that("group computation", {

  ir = as.data.table(iris)
  expect_equal(
    iris %>% group_dt(by = Species,slice_dt(1:2)),
    ir[,.SD[1:2],by = Species]
  )
  expect_equal(
    iris %>% group_dt(Species,filter_dt(Sepal.Length == max(Sepal.Length))),
    ir[,.SD[Sepal.Length == max(Sepal.Length)],by = Species]
  )
  expect_equal(
    iris %>% group_dt(Species,
                      mutate_dt(max= max(Sepal.Length)) %>%
                        summarise_dt(sum=sum(Sepal.Length))),
    copy(ir)[,max:=max(Sepal.Length),by = Species][
      ,.(sum=sum(Sepal.Length)),by = Species]
  )


})

test_that("rowwise computation",{
  df <- data.table(x = 1:2, y = 3:4, z = 4:5)

  expect_equal(
    df %>% rowwise_dt(
      mutate_dt(m = min(c(x, y, z)))
    ),
    copy(df)[,m:=pmin(x,y,z)]
  )

})

test_that("use group by in tidyfst",{

  # group by 1 variable
  a = as.data.table(iris)
  expect_equal(
    a %>%
      group_by_dt(Species) %>%
      group_exe_dt(head(1)),
    a[,.SD[1],by = Species],
    check.attributes = FALSE
  )
  expect_equal(
    a %>%
      group_by_dt(Species) %>%
      group_exe_dt(
        head(3) %>%
          summarise_dt(sum = sum(Sepal.Length))
      ),
    a[,.SD[1:3],by = Species][,.(sum=sum(Sepal.Length)),by = Species],
    check.attributes = FALSE
  )

  # group by more than 1 variable
  mt = as.data.table(mtcars)
  expect_equal(
    mt %>%
      group_by_dt("cyl|am") %>%
      group_exe_dt(
        summarise_dt(mpg_sum = sum(mpg))
      ),
    mt[,.(mpg_sum=sum(mpg)),keyby=c("cyl","am")],
    check.attributes = FALSE
  )
  expect_equal(
    mt %>%
      group_by_dt("cyl|am") %>%
      group_exe_dt(
        summarise_dt(mpg_sum = sum(mpg))
      ),
    mtcars %>%
      group_by_dt(cols = c("cyl","am")) %>%
      group_exe_dt(
        summarise_dt(mpg_sum = sum(mpg))
      )
  )
})





