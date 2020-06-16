
#' @title Subset rows using their positions
#' @description
#' `slice_dt()` lets you index rows by their (integer) locations. It allows you
#' to select, remove, and duplicate rows. It is accompanied by a number of
#' helpers for common use cases:
#'
#' * `slice_head_dt()` and `slice_tail_dt()` select the first or last rows.
#' * `slice_sample_dt()` randomly selects rows.
#' * `slice_min_dt()` and `slice_max_dt()` select rows with highest or lowest values
#'   of a variable.
#' @param .data A data.table
#' @param ... Provide either positive values to keep, or negative values to drop.
#'   The values provided must be either all positive or all negative.
#'
#' @param n When larger than or equal to 1, the number of rows.
#'   When between 0 and 1, the proportion of rows to select.
#'
#' @param order_by Variable or function of variables to order by.
#'
#' @param with_ties Should ties be kept together? The default, `TRUE`,
#'   may return more rows than you request. Use `FALSE` to ignore ties,
#'   and return the first `n` rows.
#'
#' @param replace Should sampling be performed with (`TRUE`) or without
#'   (`FALSE`, the default) replacement.
#'
#' @return A data.table
#' @seealso \code{\link[dplyr]{slice}}
#' @examples
#'
#' a = iris
#' slice_dt(a,1,2)
#' slice_dt(a,2:3)
#' slice_dt(a,141:.N)
#' slice_dt(a,1,.N)
#' slice_head_dt(a,5)
#' slice_head_dt(a,0.1)
#' slice_tail_dt(a,5)
#' slice_tail_dt(a,0.1)
#' slice_max_dt(a,Sepal.Length,10)
#' slice_max_dt(a,Sepal.Length,10,with_ties = FALSE)
#' slice_min_dt(a,Sepal.Length,10)
#' slice_min_dt(a,Sepal.Length,10,with_ties = FALSE)
#' slice_sample_dt(a,10)
#' slice_sample_dt(a,0.1)
#'

#' @rdname slice
#' @export
slice_dt = function(.data,...){
  as_dt(.data)[eval(substitute(c(...)))]
}

#' @rdname slice
#' @export
slice_head_dt = function(.data,n){
  .data = as_dt(.data)
  if(abs(n) >= 1L) head(.data,n)
  else head(.data,nrow(.data)*n)
}

#' @rdname slice
#' @export
slice_tail_dt = function(.data,n){
  .data = as_dt(.data)
  if(abs(n) >= 1L) tail(.data,n)
  else tail(.data,nrow(.data)*n)
}

#' @rdname slice
#' @export
slice_max_dt = function(.data,order_by,n,with_ties = TRUE){
  .data = as_dt(.data)
  if(n > 0 & n < 1) n = nrow(n) * n
  else if(n <= 0) stop("Invalid input, n should take a positive value.")

  order_by = deparse(substitute(order_by))
  tm_ = ifelse(with_ties,"min","first")
  index = frankv(.data[[order_by]],order = -1,ties.method = tm_) <= n

  .data[index]
}

#' @rdname slice
#' @export
slice_min_dt = function(.data,order_by,n,with_ties = TRUE){
  .data = as_dt(.data)
  if(n > 0 & n < 1) n = nrow(n) * n
  else if(n <= 0) stop("Invalid input, n should take a positive value.")

  order_by = deparse(substitute(order_by))
  tm_ = ifelse(with_ties,"min","first")
  index = frankv(.data[[order_by]],order = 1,ties.method = tm_) <= n

  .data[index]
}


#' @rdname slice
#' @export
slice_sample_dt = function(.data, n, replace = FALSE){
  .data = as_dt(.data)
  if(n >= 1L) index = sample(nrow(.data),size = n,replace = replace)
  else if(n > 0) index = sample(nrow(.data),size = n*nrow(.data),replace = replace)
  else stop("Invalid input, n should take a positive value.")
  .data[index]
}
