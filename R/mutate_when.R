
#' @title Conditional update of columns in data.table
#' @description \code{mutate_when} integrates \code{mutate} and \code{case_when}
#' in \pkg{dplyr} and make a new tidy verb for data.table. \code{mutate_vars} is
#'  a super function to do updates in specific columns according to conditions.
#' @param data data.frame
#' @param when An object which can be coerced to logical mode
#' @param ... Name-value pairs of expressions for \code{mutate_when}.
#' Additional parameters to be passed to parameter '.func' in \code{mutate_vars}.
#' @param .cols Any types that can be accepted by \code{\link[tidyfst]{select_dt}}.
#' @param .func Function to be run within each column, should return a value or
#' vectors with same length.
#' @return data.table
#' @seealso \code{\link[tidyfst]{select_dt}}, \code{\link[dplyr]{case_when}}
#' @examples
#' iris[3:8,]
#' iris[3:8,] %>%
#'   mutate_when(Petal.Width == .2,
#'               one = 1,Sepal.Length=2)
#'
#' iris %>% mutate_vars("Pe",scale)
#' iris %>% mutate_vars(is.numeric,scale)
#' iris %>% mutate_vars(1:2,scale)
#' iris %>% mutate_vars(.func = as.character)

#' @rdname mutate_vars
#' @export

mutate_when = function(data,when,...){
  dt = as_dt(data)
  eval(substitute(dt[when,`:=`(...)][]))
}

#' @rdname mutate_vars
#' @export
mutate_vars = function(data,.cols = NULL,.func,...){
  dt = as_dt(data)
  if(is.null(.cols)) sel_name = names(dt)
  else
    eval(substitute(
      dt[0] %>% select_dt(.cols) %>% names() -> sel_name
    ))

  dt2 = dt[,.SD, .SDcols = sel_name]
  to_update = sapply(dt2,.func,...) %>% as.data.table()
  unchanged = setdiff(names(dt),names(dt2))
  dt %>%
    select_dt(cols = unchanged) %>%
    cbind(to_update) %>%
    select_dt(cols = names(dt))
}


