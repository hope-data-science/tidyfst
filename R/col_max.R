
#' @title Get the column name of the max/min number each row
#' @description For a data.frame with numeric values, add a new column
#' specifying the column name of the first max/min value each row.
#' @param .data A data.frame with numeric column(s)
#' @param .name The column name of the new added column
#' @return A data.table
#' @references https://stackoverflow.com/questions/17735859/for-each-row-return-the-column-name-of-the-largest-value
#'
#' @examples
#' set.seed(199057)
#' DT <- data.table(matrix(sample(10, 100, TRUE), ncol=10))
#' DT
#' col_max(DT)
#' col_max(DT,.name = "max_col_name")
#' col_min(DT)
#'
#' col_max(iris)

#' @rdname col_max
#' @export
col_max = function(.data,.name = "max_col"){
  DT = as.data.table(.data)
  DT[, (.name) := colnames(.SD)[max.col(.SD, ties.method = "first")],
     .SDcols = is.numeric][]
}

#' @rdname col_max
#' @export
col_min = function(.data,.name = "min_col"){
  DT = as.data.table(.data)
  DT[, (.name) := colnames(.SD)[max.col(-.SD, ties.method = "first")],
     .SDcols = is.numeric][]
}


# col_max2 = function(.data,...,.name = "max_col"){
#   dt = as.data.table(.data)
#   dt[0] %>% select_dt(...) %>% names() -> dot_string
#   if(setequal(dot_string,names(dt))){
#     dt[, (.name) := colnames(.SD)[max.col(.SD, ties.method = "first")],
#        .SDcols = is.numeric][]
#   }else{
#     dt[, (.name) := colnames(.SD)[max.col(.SD, ties.method = "first")],
#        .SDcols = dot_string][]
#   }
# }

