
#' @title Pivot data from long to wide
#' @description Analogous function for \code{pivot_wider} in \pkg{tidyr}.
#' @param data data.table
#' @param ... Optional. The unchanged group in the transformation.
#' Could use integer vector, could receive what \code{select_dt} receives.
#' @param name_to_spread Chracter.One column name of class to spread
#' @param value_to_spread Chracter.One column name of value to spread.
#' If \code{NULL}, use all other variables.
#' @param fun Should the data be aggregated before casting?
#'   If the formula doesn't identify a single observation for each cell,
#'   then aggregation defaults to \code{length} with a message.
#'   To use multiple aggregation functions, pass a list.
#' @param fill Value with which to fill missing cells. Default uses \code{NA}.
#' @details The parameter of `name_to_spread` and `value_to_spread` should always
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
#'             name_to_spread = "name",
#'             value_to_spread = "value")
#'
#'  longer_stocks %>%
#'    mutate_dt(one = 1) %>%
#'    wider_dt("time",
#'             name_to_spread = "name",
#'             value_to_spread = "one")
#'
#' ## using "fun" parameter for aggregation
#' DT <- data.table(v1 = rep(1:2, each = 6),
#'                  v2 = rep(rep(1:3, 2), each = 2),
#'                  v3 = rep(1:2, 6),
#'                  v4 = rnorm(6))
#' ## for each combination of (v1, v2), add up all values of v4
#' DT %>%
#'   wider_dt(v1,v2,
#'            value_to_spread = "v4",
#'            name_to_spread = ".",
#'            fun = sum)

#' @export

wider_dt = function(data,
                    ...,
                    name_to_spread,
                    value_to_spread = NULL,
                    fun = identity,
                    fill = NA){
  dt = as_dt(data)
  group = dt[0] %>% select_dt(...) %>% names() %>% str_c(collapse = "+")
  #if(setequal(group,names(dt))) group = "..."
  if(is.null(value_to_spread)) value_to_spread = "."
  if(!is.null(fun)) substitute(fun) %>% deparse() -> fun
  call_string = str_glue("dcast(dt,{group}~{name_to_spread}, fun.aggregate = {fun},
                          value.var = value_to_spread,fill = {fill})")
  eval(parse(text = call_string))
}

# wider_dt = function(data,
#                     group_to_keep = NULL,
#                     name_to_spread,
#                     value_to_spread = NULL,
#                     fill = NA){
#   dt = as_dt(data)
#   group = group_to_keep
#   if(is.null(group)) group = "..."
#   else if(is.integer(group)) names(dt)[group] -> group
#   else if(length(group) == 1 & is.character(group))
#     str_subset(names(dt),group) -> group
#   group = str_c(group,collapse = "+")
#   if(is.null(value_to_spread)) value_to_spread = "."
#   call_string = str_glue("dcast(dt,{group}~{name_to_spread},
#                           value.var = value_to_spread,fill = {fill})")
#   eval(parse(text = call_string))
# }


