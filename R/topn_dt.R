
#' @title Select top (or bottom) n rows (by value)
#' @description Analogous function for \code{top_n} and \code{top_frac} in \pkg{dplyr}, but with a different API.
#'
#' @param data data.frame
#' @param n number of rows to return for `top_n_dt()`, fraction of rows to return for `topfrac_dt()`.
#'  Will include more rows if there are ties.
#' @param n  If \code{n} is positive, selects the top rows. If negative, selects the bottom rows.
#' @param wt (Optional). The variable to use for ordering.
#' If not specified, defaults to the last variable in the data.frame.
#' @description In \code{top_dt}, you can use a different API for both
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
top_dt = function(data,wt,n = NULL,prop = NULL){
  dt = as_dt(data)
  if(is.null(n) & !is.null(prop))
    eval(substitute(top_frac_dt(dt,prop,wt)))
  else if(!is.null(n) & is.null(prop))
    eval(substitute(top_n_dt(dt,n,wt)))
  else stop("Both or none of `n` and `prop` are provided!")
}

#' @rdname topn
#' @export
top_n_dt = function(data,n,wt = NULL){
  dt = as_dt(data)
  n_ = n
  wt = fifelse(is.null(substitute(wt)),
               names(dt)[length(dt)],
               deparse(substitute(wt)))

  if(n_ > 0) dt[frankv(dt,cols = wt,order = -1,ties.method = "min") <= n_]
  else if(n_ < 0) dt[frankv(dt,cols = wt,order = 1,ties.method = "min") <= -n_]
  else dt[0]
}

# top_n_dt = function(data,n,wt = NULL){
#   dt = as_dt(data)
#   if(is.null(substitute(wt))) wt = as.symbol(names(dt)[length(dt)])
#   if(n > 0)
#     eval(substitute(dt[wt >= fsort(dt[,wt]) %>% .[length(.)-n + 1]]))
#   else if(n < 0)
#     eval(substitute(dt[wt <= fsort(dt[,wt]) %>% .[-n]]))
#   else
#     dt[0]
# }



#' @rdname topn
#' @export
#'
## put column name in front of number
top_frac_dt = function(data,n,wt = NULL){
  dt = as_dt(data)
  n = nrow(dt) * n
  eval(substitute(top_n_dt(dt,n,wt)))
}

# top_frac_dt = function(data,n,wt = NULL){
#   dt = as_dt(data)
#   wt = substitute(wt)
#   if(n > 0){
#     if(is.null(wt)) wt = names(dt)[length(dt)]
#     else wt = deparse(wt)
#     dt[[wt]] %>% sort(decreasing = TRUE) %>% .[length(.)*n] -> value
#     "dt[{wt} >= value]" %>% str_glue() %>% parse(text = .) %>% eval()
#   } else{
#     n = -n
#     if(is.null(wt)) wt = names(dt)[length(dt)]
#     else wt = deparse(wt)
#     dt[[wt]] %>% sort() %>% .[length(.)*n]  -> value
#     "dt[{wt} <= value]" %>% str_glue() %>% parse(text = .) %>% eval()
#   }
# }



