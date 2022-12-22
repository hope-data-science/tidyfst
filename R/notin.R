
#' @title Not in operator
#'
#' @description Inverse operation of match.
#'
#' @param x vector or NULL
#' @param y vector or NULL
#'
#' @export
#'
#' @examples
#'
#' "a" %in% letters[1:3]
#' "a" %notin% letters[1:3]
#'
#' 1 %in% 1:3
#' 1 %notin% 1:3


'%notin%' <- function(x, y) {
  if(is.character(x)) ! x %chin%y
  else ! x %in% y
}

