
#' @title Filter entries in data.frame
#' @description Choose rows where conditions are true.
#' @param .data data.frame
#' @param ... List of variables or name-value pairs of summary/modifications
#'   functions.
#' @return data.table
#' @seealso \code{\link[dplyr]{filter}}
#' @examples
#' iris %>% filter_dt(Sepal.Length > 7)
#' iris %>% filter_dt(Sepal.Length == max(Sepal.Length))
#'
#' # comma is not supported in tidyfst after v0.9.8
#' # which means you can't use:
#' \dontrun{
#'  iris %>% filter_dt(Sepal.Length > 7, Sepal.Width > 3)
#' }
#' # use following code instead
#' iris %>% filter_dt(Sepal.Length > 7 & Sepal.Width > 3)
#'

#' @export
filter_dt = function(.data,...){
  dt = as_dt(.data)
  dt[...]
}

