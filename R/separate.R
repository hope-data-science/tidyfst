
#' @title Separate a character column into two columns using
#' a regular expression separator
#' @description Given either regular expression,
#' \code{separate_dt()} turns a single character column into two columns.
#' Analogous to \code{tidyr::separate}, but only split into two columns only.
#' @param data A data frame.
#' @param separated_colname Column name, string only.
#' @param into Character vector of length 2.
#' @param sep Separator between columns.
#' @param remove If \code{TRUE}, remove input column from output data frame.
#' @seealso \code{\link[tidyr]{separate}}, \code{\link[tidyfst]{unite_dt}}
#' @examples
#' df <- data.frame(x = c(NA, "a.b", "a.d", "b.c"))
#' df %>% separate_dt("x", c("A", "B"))

#' @export
separate_dt = function(data,separated_colname,into,
                       sep = "[^[:alnum:]]+",
                       remove = TRUE){
  dt = as_dt(data)
  dt[[separated_colname]] %>%
    tstrsplit(split = sep) %>%
    setNames(into) %>%
    as.data.table() -> split_columns
  if(remove) rbind(dt[,.SD,.SDcols = -separated_colname],split_columns)
  else rbind(dt,split_columns)

}




