
#' @title Slice rows in data.frame
#' @description Analogous function for \code{slice} in \pkg{dplyr}
#' @param .data data.frame
#' @param ... Integer row values.
#' @return data.table
#' @seealso \code{\link[dplyr]{slice}}
#' @examples
#' iris %>% slice_dt(1:3)
#' iris %>% slice_dt(1,3)
#' iris %>% slice_dt(c(1,3))
#' @export

slice_dt = function(.data,...){
  dt = as_dt(.data)
  eval(substitute(dt[c(...)]))
}




