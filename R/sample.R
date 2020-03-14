

#' @title Sample n rows from a table
#' @description Analogous function for \code{sample_n} and \code{sample_frac} in \pkg{dplyr}.
#' @param data A data.frame
#' @param n Number of rows to select
#' @param prop Fraction of rows to select
#' @param size 	For \code{sample_n_dt}, the number of rows to select.
#' For \code{sample_frac_dt}, the fraction of rows to select.
#' @param replace Sample with or without replacement? Default uses \code{FALSE}.
#' @description \code{sample_dt} is a merged version of \code{sample_n_dt} and
#' \code{sample_frac_dt}, this could be convenient.
#' @return data.table
#' @seealso \code{\link[dplyr]{sample_n}},\code{\link[dplyr]{sample_frac}}
#' @examples
#' sample_n_dt(mtcars, 10)
#' sample_n_dt(mtcars, 50, replace = TRUE)
#' sample_frac_dt(mtcars, 0.1)
#' sample_frac_dt(mtcars, 1.5, replace = TRUE)
#'
#' sample_dt(mtcars,n=10)
#' sample_dt(mtcars,prop = 0.1)
#'
#' @rdname sample
#' @export
sample_dt = function(data,n = NULL,prop = NULL,replace = FALSE){
  dt = as_dt(data)
  if(is.null(n) & !is.null(prop))
    sample_frac_dt(dt,size = prop,replace = replace)
  else if(!is.null(n) & is.null(prop))
    sample_n_dt(dt,size = n,replace = replace)
  else stop("Both or none of `n` and `prop` are provided!")
}

#' @rdname sample
#' @export
#'
sample_n_dt = function(data,size,replace = FALSE){
  dt = as_dt(data)
  if(size > nrow(data) & replace == FALSE) stop("Sample size is too large.")
  index = sample(nrow(dt),size = size,replace = replace)
  dt[index]
}

#' @rdname sample
#' @export
sample_frac_dt = function(data,size,replace = FALSE){
  dt = as_dt(data)
  if(!between(size,0,1) & replace == FALSE) stop("The fraction is invalid.")
  size = as.integer(nrow(dt) * size)
  index = sample(nrow(dt),size = size,replace = replace)
  dt[index]
}
