
#' @title Arrange entries in data.frame
#' @description Analogous function for \code{arrange} in \pkg{dplyr}.
#' @param .data data.frame
#' @param ... Arrange by what group? Minus symbol means arrange by
#' descending order.
#' @return data.table
#' @seealso \code{\link[dplyr]{arrange}}
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

arrange_dt = function(.data,...){
  dt = as_dt(.data)
  dt[order(...)]
}


