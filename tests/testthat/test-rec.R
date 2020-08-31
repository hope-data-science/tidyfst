test_that("recode variables", {
  x = 1:10
  expect_equal(
    rec_num(x, rec = "1:3=1; 4:6=2"),
    c(rep(1,3),rep(2,3),7:10)
  )
  expect_equal(
    rec_num(x, rec = "1:3=1; 4:6=2",keep = FALSE),
    c(rep(1,3),rep(2,3),rep(NA,4))
  )

  y = letters[1:5]
  expect_equal(
    rec_char(y,rec = "a=A;b=B"),
    c("A","B","c","d","e")
  )
  expect_equal(
    rec_char(y,rec = "a,b=A;c,d=B"),
    c("A","A","B","B","e")
  )
  expect_equal(
    rec_char(y,rec = "a,b=A;c,d=B",keep = FALSE),
    c("A","A","B","B",NA)
  )
})
