
#' @title Summarise columns to single values
#' @name summarise_dt
#' @description Analogous function for \code{summarise}  in \pkg{dplyr}.
#' @param data data.frame
#' @param ... List of variables or name-value pairs of summary/modifications
#'   functions.
#' @param by unquoted name of grouping variable of list of unquoted names of
#'   grouping variables. For details see \link[data.table]{data.table}
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
#'
#'
#' @rdname summarise_dt
#' @export

summarise_dt = function(data,...,by = NULL){
  dt = as_dt(data)
  by = substitute(by)
  substitute(list(...)) %>%
    deparse() %>%
    str_c(collapse = "") %>%
    #str_squish() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2) -> dot_string
  if(deparse(by) == "NULL"){
    eval(parse(text = str_glue("dt[,.({dot_string})]")))
  } else{
    if(by %>% deparse() %>% str_detect("\\."))
      eval(parse(text = str_glue("dt[,.({dot_string}),by = by]")))
    else{
      by %>%
        deparse() %>%
        str_c(".(",.,")") -> by
      eval(parse(text = str_glue("dt[,.({dot_string}),by = {by}]")))
    }
  }
}

#' @rdname summarise_dt
#' @export

summarize_dt = summarise_dt



