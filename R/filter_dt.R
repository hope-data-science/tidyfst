
#' @title Filter entries in data.frame
#' @description Analogous function for \code{filter} in \pkg{dplyr}.
#' @param data data.frame
#' @param ... List of variables or name-value pairs of summary/modifications
#'   functions.
#' @return data.table
#' @seealso \code{\link[dplyr]{filter}}
#' @examples
#' iris %>% filter_dt(Sepal.Length > 7)
#' iris %>% filter_dt(Sepal.Length > 7,Sepal.Width > 3)
#' iris %>% filter_dt(Sepal.Length > 7 & Sepal.Width > 3)
#' iris %>% filter_dt(Sepal.Length == max(Sepal.Length))

#' @export

filter_dt = function(data,...){
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2) %>%
    str_replace_all(","," & ")-> dot_string
  eval(parse(text = str_glue("dt[{dot_string}]")))
}



