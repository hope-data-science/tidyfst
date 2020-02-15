

#' @title Sample n rows from a table
#' @description Analogous function for \code{sample_n} and \code{sample_frac} in \pkg{dplyr}.
#' @param data data.frame
#' @param size 	\code{sample_n_dt()}, the number of rows to select.
#' For \code{sample_frac_dt}, the fraction of rows to select.
#' @param replace Sample with or without replacement? Default uses \code{FALSE}.
#' @return data.table
#' @seealso \code{\link[dplyr]{sample_n}},\code{\link[dplyr]{sample_frac}}
#' @examples
#' sample_n_dt(mtcars, 10)
#' sample_n_dt(mtcars, 50, replace = TRUE)
#' sample_frac_dt(mtcars, 0.1)
#' sample_frac_dt(mtcars, 1.5, replace = TRUE)
#'
#'
#' @rdname sample
#' @export
#'
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
