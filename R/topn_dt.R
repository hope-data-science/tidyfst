
#' @title Select top (or bottom) n rows (by value)
#' @description Get the top entries (rows) according to the values of specified columns.
#'  One can get the top or bottom ones according to number or proportion.
#' @param .data data.frame
#' @param wt (Optional). The variable to use for ordering.
#' If not specified, defaults to the last variable in the data.frame.
#' @param n Number of rows to return.
#'  Will include more rows if there are ties.
#'  If \code{n} is positive, selects the top rows.
#'  If negative, select the bottom rows.
#' @param prop Fraction of rows to return.
#'  Will include more rows if there are ties.
#'  If \code{prop} is positive, selects the top rows.
#'  If negative, select the bottom rows.
#' @description In \code{top_dt}, you can use an API for both
#' functionalities in `top_n_dt()` and `top_frac_dt()`.
#' @return data.table
#' @seealso \code{\link[dplyr]{top_n}}
#' @examples
#' iris %>% top_n_dt(10,Sepal.Length)
#' iris %>% top_n_dt(-10,Sepal.Length)
#' iris %>% top_frac_dt(.1,Sepal.Length)
#' iris %>% top_frac_dt(-.1,Sepal.Length)
#'
#' # For `top_dt`, you can use both modes above
#' iris %>% top_dt(Sepal.Length,n = 10)
#' iris %>% top_dt(Sepal.Length,prop = .1)

#' @rdname topn
#' @export
top_dt = function(.data,wt = NULL,n = NULL,prop = NULL){
  dt = as_dt(.data)
  if(is.null(n) & !is.null(prop))
    eval(substitute(top_frac_dt(dt,prop,wt)))
  else if(!is.null(n) & is.null(prop))
    eval(substitute(top_n_dt(dt,n,wt)))
  else stop("Both or none of `n` and `prop` are provided!")
}

#' @rdname topn
#' @export
top_n_dt = function(.data,n,wt = NULL){
  dt = as_dt(.data)
  n_ = n
  wt_ = fifelse(is.null(substitute(wt)),
               names(dt)[length(dt)],
               deparse(substitute(wt)))

  if(n_ > 0) dt[frankv(dt,cols = wt_,order = -1,ties.method = "min") <= n_]
  else if(n_ < 0) dt[frankv(dt,cols = wt_,order = 1,ties.method = "min") <= -n_]
  else dt[0]
}



#' @rdname topn
#' @export
#'
## put column name in front of number
top_frac_dt = function(.data,prop,wt = NULL){
  dt = as_dt(.data)
  n = nrow(dt) * prop
  eval(substitute(top_n_dt(dt,n,wt)))
}



