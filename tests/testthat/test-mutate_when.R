

test_that("mutate_when", {
  ir = as.data.table(iris)
  expect_equal(
    iris[3:8,] %>%
      mutate_when(Petal.Width == .2,
                  one = 1,Sepal.Length=2),
    ir[3:8][Petal.Width == .2,`:=`(one = 1,Sepal.Length=2)]
  )
})

test_that("mutate_vars",{
  ir = as.data.table(iris)

  sel_names = stringr::str_subset(names(ir),"Pe")
  expect_equal(
    iris %>% mutate_vars("Pe",scale),
    copy(ir)[,(sel_names):=lapply(.SD,scale),.SDcols = patterns("Pe")]
  )

  expect_equal(
    iris %>% mutate_vars(is.numeric,scale),
    iris %>% mutate_vars(-is.factor,scale)
  )

  expect_equal(
    iris %>% mutate_vars(1:2,scale),
    copy(ir)[,names(ir)[1:2]:=lapply(.SD,scale),.SDcols = 1:2]
  )

  expect_equal(
    iris %>% mutate_vars(.func = as.character),
    copy(ir)[,names(ir):=lapply(.SD,as.character)]
  )

})
