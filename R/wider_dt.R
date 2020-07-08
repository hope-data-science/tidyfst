
#' @title Pivot data from long to wide
#' @description Transform a data frame from long format to wide by increasing the number of columns and decreasing the number of rows.
#' @param .data A data.frame
#' @param ... Optional. The unchanged group in the transformation.
#' Could use integer vector, could receive what \code{select_dt} receives.
#' @param name Chracter.One column name of class to spread
#' @param value Chracter.One column name of value to spread.
#' If \code{NULL}, use all other variables.
#' @param fun Should the data be aggregated before casting?
#' Defaults to \code{NULL}, which uses \code{length} for aggregation.
#' If a function is provided, with aggregated by this function.
#' @param fill Value with which to fill missing cells. Default uses \code{NA}.
#' @details The parameter of `name` and `value` should always
#' be provided and should be explicit called (with the parameter names attached).
#' @return data.table
#' @seealso \code{\link[tidyfst]{longer_dt}},
#'  \code{\link[data.table]{dcast}},
#'  \code{\link[tidyr]{pivot_wider}}
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
#'    wider_dt("time",
#'             name = "name",
#'             value = "value")
#'
#'  longer_stocks %>%
#'    mutate_dt(one = 1) %>%
#'    wider_dt("time",
#'             name = "name",
#'             value = "one")
#'
#' ## using "fun" parameter for aggregation
#' DT <- data.table(v1 = rep(1:2, each = 6),
#'                  v2 = rep(rep(1:3, 2), each = 2),
#'                  v3 = rep(1:2, 6),
#'                  v4 = rnorm(6))
#' ## for each combination of (v1, v2), add up all values of v4
#' DT %>%
#'   wider_dt(v1,v2,
#'            value = "v4",
#'            name = ".",
#'            fun = sum)

#' @export

wider_dt = function(.data,
                    ...,
                    name,
                    value = NULL,
                    fun = NULL,
                    fill = NA){
  dt = as_dt(.data)
  group = dt[0] %>% select_mix(...) %>% names() %>% str_c(collapse = "+")
  if(group == "") group = "..."
  if(is.null(value)) value = "."

  substitute(fun) %>% deparse() -> fun
  if(fun == "list"){
    call_string = str_glue("dcast(dt,{group}~{name}, fun.aggregate = list,
                          value.var = value,fill = {fill}) %>%
                           unchop_dt(is.list)")
  }else{
    call_string = str_glue("dcast(dt,{group}~{name}, fun.aggregate = {fun},
                          value.var = value,fill = {fill})")
  }
  eval(parse(text = call_string))
}







