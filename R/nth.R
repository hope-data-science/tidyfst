
#' @title Extract the nth value from a vector
#' @description Get the value from a vector with its position.
#' @param v A vector
#' @param n A single integer specifying the position. Default uses \code{1}.
#' Negative integers index from the end
#'  (i.e. -1L will return the last value in the vector).
#'  If a double is supplied, it will be silently truncated.
#' @return A single value.
#' @examples
#'
#' x = 1:10
#' nth(x, 1)
#' nth(x, 5)
#' nth(x, -2)
#'
#' @export

nth = function(v,n = 1){
  n <- trunc(n)
  ifelse(
    n >= 0,
    v[[n]],
    v[[length(v)+n+1]]
  )
}


