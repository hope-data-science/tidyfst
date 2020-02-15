
#' @title Arrange entries in data.frame
#' @description Analogous function for \code{arrange} in \pkg{dplyr}.
#' @param data data.frame
#' @param ... List of variables or name-value pairs of summary/modifications
#'   functions.
#' @return data.table
#' @seealso \code{\link[dplyr]{arrange}},\code{\link[maditr]{dt_arrange}}
#' @examples
#'
#' iris %>% arrange_dt(Sepal.Length)
#'
#' # minus for decreasing order
#' iris %>% arrange_dt(-Sepal.Length)
#'
#' # arrange by multiple variables
#' iris %>% arrange_dt(Sepal.Length,Petal.Length)
#'

#' @export

arrange_dt = function(data,...){
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2)-> dot_string
  eval(parse(text = str_glue("dt[order({dot_string})]")))
}
