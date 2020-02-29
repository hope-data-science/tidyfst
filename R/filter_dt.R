
#' @title Filter entries in data.frame
#' @description Analogous function for \code{filter} in \pkg{dplyr}.
#' @param data data.frame
#' @param ... List of variables or name-value pairs of summary/modifications
#'   functions.
#' @return data.table
#' @seealso \code{\link[dplyr]{filter}}
#' @examples
#' iris %>% filter_dt(Sepal.Length > 7)
#' \dontrun{
#' # tidyfst do not support comma anymore, following codes would return error
#' # please use `&` instead of `,`
#' iris %>% filter_dt(Sepal.Length > 7,Sepal.Width > 3)
#' }
#' iris %>% filter_dt(Sepal.Length > 7 & Sepal.Width > 3)
#' iris %>% filter_dt(Sepal.Length == max(Sepal.Length))

#' @export

filter_dt = function(data,...){
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_c(collapse = "") %>%
    str_squish() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2) -> dot_string
  eval(parse(text = str_glue("dt[{dot_string}]")))
}


