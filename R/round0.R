
#' @title Round a number and make it show zeros
#' @description
#'  Rounds values in its first argument to the specified number of decimal places,
#'  returning character, ensuring first decimal digits are showed even when they are zeros.
#'
#' @param x A numeric vector.
#' @param digits Integer indicating the number of decimal places. Defaults to 0.
#'
#' @return A character vector.
#' @seealso \code{\link[base]{round}}
#' @references https://stackoverflow.com/questions/42105336/how-to-round-a-number-and-make-it-show-zeros
#' @examples
#' a = 14.0034
#' round0(a,2)
#'
#' b = 10
#' round0(b,1)
#'
#' @export

round0 = \(x,digits = 0){
  format(round(x,digits = digits),nsmall = digits)
}
