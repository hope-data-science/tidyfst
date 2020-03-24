
#' @title Summarise columns to single values
#' @name summarise_dt
#' @description Analogous function for \code{summarise}  in \pkg{dplyr}.
#' @param .data data.frame
#' @param ... List of variables or name-value pairs of summary/modifications
#'   functions for \code{summarise_dt}.Additional parameters to be passed to
#'    parameter '.func' in \code{summarise_vars}.
#' @param by unquoted name of grouping variable of list of unquoted names of
#'   grouping variables. For details see \link[data.table]{data.table}
#' @param .cols Columns to be summarised.
#' @param .func Function to be run within each column, should return a value or vectors with same length.
#' @details \code{summarise_vars} could complete summarise on specific columns.
#' @return data.table
#' @seealso \code{\link[dplyr]{summarise}}
#' @examples
#' iris %>% summarise_dt(avg = mean(Sepal.Length))
#' iris %>% summarise_dt(avg = mean(Sepal.Length),by = Species)
#' mtcars %>% summarise_dt(avg = mean(hp),by = .(cyl,vs))
#'
#' # the data.table way
#' mtcars %>% summarise_dt(cyl_n = .N, by = .(cyl, vs)) # `.`` is short for list
#'
#' iris %>% summarise_vars(is.numeric,min)
#' iris %>% summarise_vars(-is.factor,min)
#' iris %>% summarise_vars(1:4,min)
#' iris %>% summarise_vars(.func = as.character)

#' @rdname summarise_dt
#' @export

summarise_dt = function(.data,...,by = NULL){
  dt = as_dt(.data)
  eval(substitute(dt[,.(...),by = by]))
}

#' @rdname summarise_dt
#' @export

summarize_dt = summarise_dt

#' @rdname summarise_dt
#' @export

summarise_vars = function (.data, .cols = NULL, .func, ...) {
  dt = as_dt(.data)
  deparse(substitute(.cols)) -> .cols
  if (.cols == "NULL")
    sel_name = names(dt[0])
  else{
    eval(
      parse(
        text =
          str_glue("select_dt(dt[0],{.cols}) %>% names() -> sel_name")))
  }
  dt[,lapply(.SD, .func, ...), .SDcols = sel_name]
}

#' @rdname summarise_dt
#' @export

summarize_vars = summarise_vars




