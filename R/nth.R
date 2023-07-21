
#' @title Extract the nth value from a vector
#' @description \code{nth} get the value from a vector with its position,
#'  while \code{maxth} and \code{minth} get the nth highest or lowest value
#'  from the vector.
#' @param v A vector
#' @param n For\code{nth}, a single integer specifying the position. Default uses \code{1}.
#' Negative integers index from the end
#'  (i.e. -1L will return the last value in the vector).
#'  If a double is supplied, it will be silently truncated.
#'  For \code{maxth} and \code{minth}, a single integer indicating the nth
#'  highest or lowest value.
#' @return A single value.
#' @references https://stackoverflow.com/questions/2453326/fastest-way-to-find-second-third-highest-lowest-value-in-vector-or-column/66367996#66367996
#' @examples
#'
#' x = 1:10
#' nth(x, 1)
#' nth(x, 5)
#' nth(x, -2)
#'
#' y = c(10,3,4,5,2,1,6,9,7,8)
#' maxth(y,3)
#' minth(y,3)
#'

#' @rdname nth
#' @export

nth = function(v,n = 1){
  n <- trunc(n)
  ifelse(
    n >= 0,
    v[[n]],
    v[[length(v)+n+1]]
  )
}

#' @rdname nth
#' @export
maxth = function(v,n = 1){
  v = na.omit(v)
  no = length(v)
  if(n > no){
    warning("N greater than length(v). Setting n = length(v)")
    n = no
  }
  sort(v,partial = no - n + 1)[no - n + 1]
}

#' @rdname nth
#' @export
minth = function(v,n = 1){
  v = na.omit(v)
  no = length(v)
  if(n > no){
    warning("N greater than length(v). Setting n = length(v)")
    n = no
  }
  -sort(-v, partial=no - n + 1)[no - n + 1]
}




