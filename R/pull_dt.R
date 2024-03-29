
#' @title Pull out a single variable
#' @description Extract vector from data.frame, works likt `[[`. Analogous function for \code{pull} in \pkg{dplyr}
#' @param .data data.frame
#' @param col A name of column or index (should be positive).
#' @return vector
#' @seealso \code{\link[dplyr]{pull}}
#' @examples
#' mtcars %>% pull_dt(2)
#' mtcars %>% pull_dt(cyl)
#' mtcars %>% pull_dt("cyl")
#' @export

pull_dt = function(.data,col) .data[[substitute(col)]]

# pull_dt = function(.data,col) eval.parent(substitute(.data[[col]]))
