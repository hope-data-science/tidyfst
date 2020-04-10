
#' @title Fast value replacement in data frame
#' @description While \code{replace_na_dt} could replace all NAs to another
#' value, \code{replace_dt} could replace any value(s) to another specific
#' value.
#' @param .data A data.frame
#' @param ... Colunms to be replaced. If not specified, use all columns.
#' @param from A value, a vector of values or a function returns a logical value.
#' Defaults to \code{is.nan}.
#' @param to A value. Defaults to \code{NA}.
#' @return A data.table.
#' @seealso \code{\link[tidyfst]{replace_na_dt}}
#' @examples
#' iris %>% mutate_vars(is.factor,as.character) -> new_iris
#'
#' new_iris %>%
#'   replace_dt(Species, from = "setosa",to = "SS")
#' new_iris %>%
#'   replace_dt(Species,from = c("setosa","virginica"),to = "sv")
#' new_iris %>%
#'   replace_dt(Petal.Width, from = .2,to = 2)
#' new_iris %>%
#'   replace_dt(from = .2,to = NA)
#' new_iris %>%
#'   replace_dt(is.numeric, from = function(x) x > 3, to = 9999 )


#' @export
replace_dt = function (.data, ..., from = is.nan,to = NA) {
  dt = as.data.table(.data)
  #dt = as_dt(.data)
  if(!is.function(from)) {
    if (setequal(from,to)) return(.data)
    if(length(from) == 1) .func = function(x) x == from
    else if(is.character(from)) .func = function(x) x %chin% from
    else .func = function(x) x %in% from
  } else .func = from


  if (substitute(list(...)) %>% deparse() == "list()")
    dot_string <- NULL
  else dot_string <- dt[0] %>% select_dt(...) %>% names()
  if (is.null(dot_string)) {
    for (j in seq_len(ncol(dt))) set(dt, which(.func(dt[[j]])),
                                     j, to)
  }
  else {
    for (j in dot_string) set(dt, which(.func(dt[[j]])),
                              j, to)
  }
  dt
}
