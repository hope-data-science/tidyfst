

#' @title Bind multiple data frames by row
#' @description
#' Bind any number of data frames by row, making a longer result.
#' Similar to `dplyr::bind_rows`, however, columns with same names but different data types
#' would be coerced to a single proper data type.
#' @param ... Data frames to combine. Each argument can either be a data frame,
#' a list that could be a data frame, or a list of data frames.
#' Columns are matched by name, and any missing columns will be filled with `NA`.
#' @return data.table
#' @seealso \code{\link[dplyr]{bind_rows}},\code{\link[data.table]{rbindlist}}
#'
#' @examples
#'
#' bind_rows_dt(iris[1:3,],iris[6:8,])
#'
#' # data frames with same name but different type
#' # numeric data would be coerced to character data in this case
#' df1 <- data.frame(x = 1:2, y = letters[1:2])
#' df2 <- data.frame(x = 4:5, y = 1:2)
#' bind_rows_dt(df1, df2)
#'

#' @export

bind_rows_dt = function(...){
  rbindlist(lapply(list(...),as.data.table))
}

