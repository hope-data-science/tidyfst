
#' @title Conditional update of columns in data.table
#' @description Update or add columns when the given condition is met.
#' @description \code{mutate_when} integrates \code{mutate} and \code{case_when}
#' in \pkg{dplyr} and make a new tidy verb for data.table. \code{mutate_vars} is
#'  a super function to do updates in specific columns according to conditions.
#' @param .data data.frame
#' @param when An object which can be coerced to logical mode
#' @param ... Name-value pairs of expressions for \code{mutate_when}.
#' Additional parameters to be passed to parameter '.func' in \code{mutate_vars}.
#' @param .cols Any types that can be accepted by \code{\link[tidyfst]{select_dt}}.
#' @param .func Function to be run within each column, should return a value or
#' vectors with same length.
#' @param by (Optional) Mutate by what group?
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
#' iris %>% mutate_vars(-is.factor,scale)
#' iris %>% mutate_vars(1:2,scale)
#' iris %>% mutate_vars(.func = as.character)

#' @rdname mutate_vars
#' @export

mutate_when = function(.data,when,...,by){
  #dt = as_dt(.data)
  dt = as.data.table(.data)
  eval(substitute(dt[when,`:=`(...),by][]))
}

#' @rdname mutate_vars
#' @export
mutate_vars = function(.data,.cols = NULL,.func,...,by){
  #dt = as_dt(.data)
  dt = as.data.table(.data)
  deparse(substitute(.cols)) -> .cols
  deparse(substitute(by)) -> .by
  if (.cols == "NULL")
    sel_name = names(dt[0])
  else{
    eval(
      parse(
        text =
          str_glue("select_dt(dt[0],{.cols}) %>% names() -> sel_name")))
  }
  eval(parse(text = str_glue(
  "dt[,(sel_name) := lapply(.SD,.func,...), by = {.by},.SDcols = sel_name][]")))

}


