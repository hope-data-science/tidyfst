
#' @title Pivot data from long to wide
#' @description Analogous function for \code{pivot_wider} in \pkg{tidyr}.
#' @param data data.table
#' @param group_to_keep The unchanged group in the transformation.
#' Could use integer vector, character vector or regular expression(to match
#' the column names). If \code{NULL}, use all other variables.
#' @param name_to_spread Chracter.One column name of class to spread
#' @param value_to_spread Chracter.One column name of value to spread.
#' If \code{NULL}, use all other variables.
#' @param fill Value with which to fill missing cells. Default uses \code{NA}.
#' @return data.table
#' @seealso \code{\link[data.table]{dcast}}
#' @seealso \code{\link[tidyr]{pivot_wider}}
#' @examples
#'  stocks = data.frame(
#'    time = as.Date('2009-01-01') + 0:9,
#'    X = rnorm(10, 0, 1),
#'    Y = rnorm(10, 0, 2),
#'    Z = rnorm(10, 0, 4)
#'  ) %>%
#'    longer_dt(time) -> longer_stocks
#'
#'  longer_stocks
#'
#'  longer_stocks %>%
#'    wider_dt("time","variable","value")
#'
#'  longer_stocks %>%
#'    mutate_dt(one = 1) %>%
#'    wider_dt("time","variable","one")
#'

#' @export

wider_dt = function(data,
                    group_to_keep = NULL,
                    name_to_spread,
                    value_to_spread = NULL,
                    fill = NA){
  dt = as_dt(data)
  group = group_to_keep
  if(is.null(group)) group = "..."
  else if(is.integer(group)) names(dt)[group] -> group
  else if(length(group) == 1 & is.character(group))
    str_subset(names(dt),group) -> group
  group = str_c(group,collapse = "+")
  if(is.null(value_to_spread)) value_to_spread = "."
  call_string = str_glue("dcast(dt,{group}~{name_to_spread},
                         value.var = value_to_spread,fill = {fill})")
  eval(parse(text = call_string))
}



