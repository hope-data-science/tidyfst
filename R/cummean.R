
#' @title Cumulative mean
#' @description Returns a vector whose elements are the cumulative mean of the elements of the argument.
#' @param x a numeric or complex object,
#'  or an object that can be coerced to one of these.
#' @examples
#' cummean(1:10)
#'
#' @export

cummean = function(x) cumsum(x)/seq_along(x)
