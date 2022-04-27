
#' @title Conversion between tidy table and named matrix
#' @description Convenient fucntions to implement conversion between
#'  tidy table and named matrix.
#' @param m A matrix
#' @param df A data.frame with at least 3 columns, one for row name,
#'  one for column name, and one for values. The names for column and
#'  row should be unique.
#' @param row Unquoted expression of column name for row
#' @param col Unquoted expression of column name for column
#' @param value Unquoted expression of column name for values
#' @return For \code{mat_df}, a data.frame.
#' For \code{df_mat}, a named matrix.
#' @examples
#'
#' mm = matrix(c(1:8,NA),ncol = 3,dimnames = list(letters[1:3],LETTERS[1:3]))
#' mm
#' tdf = mat_df(mm)
#' tdf
#' mat = df_mat(tdf,row,col,value)
#' setequal(mm,mat)
#'
#' tdf %>%
#'   setNames(c("A","B","C")) %>%
#'   df_mat(A,B,C)
#'

#' @rdname tidymat
#' @export
mat_df = function(m){
  stopifnot(is.matrix(m))
  res = as.data.frame.table(m)
  setnames(res,old = names(res),new = c("row","col","value"))
  res
}

#' @rdname tidymat
#' @export
df_mat = function(df,row,col,value){
  stopifnot(is.data.frame(df))
  eval.parent(substitute(with(df, tapply(value, list(row, col), identity))),1)
  # df = df
  # eval(substitute(with(df, tapply(value, list(row, col), identity))))
}




