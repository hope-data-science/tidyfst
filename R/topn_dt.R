
#' @title Select top (or bottom) n rows (by value)
#' @description Analogous function for \code{top_n} and \code{top_frac} in \pkg{dplyr}, but with a different API.
#'
#' @param data data.frame
#' @param n number of rows to return for `topn_dt()`, fraction of rows to return for `topfrac_dt()`.
#'  Will include more rows if there are ties.
#' @param n  If \code{n} is positive, selects the top rows. If negative, selects the bottom rows.
#' @param wt (Optional). The variable to use for ordering.
#' If not specified, defaults to the last variable in the data.frame.
#' @return data.table
#' @seealso \code{\link[dplyr]{top_n}}
#' @examples
#' iris %>% top_n_dt(10,Sepal.Length)
#' iris %>% top_n_dt(-10,Sepal.Length)
#' iris %>% top_frac_dt(.1,Sepal.Length)
#' iris %>% top_frac_dt(-.1,Sepal.Length)
#'

#' @rdname topn
#' @export

top_n_dt = function(data,n,wt = NULL){
  dt = as_dt(data)
  wt = substitute(wt)
  if(n > 0){
    if(is.null(wt)) wt = names(dt)[length(dt)]
    else wt = deparse(wt)
    dt[[wt]] %>% sort(decreasing = TRUE) %>% .[n] -> value
    "dt[{wt} >= value]" %>% str_glue() %>% parse(text = .) %>% eval()
  } else{
    n = -n
    if(is.null(wt)) wt = names(dt)[length(dt)]
    else wt = deparse(wt)
    dt[[wt]] %>% sort() %>% .[n] -> value
    "dt[{wt} <= value]" %>% str_glue() %>% parse(text = .) %>% eval()
  }
}

#' @rdname topn
#' @export
#'
## put column name in front of number
top_frac_dt = function(data,n,wt = NULL){
  dt = as_dt(data)
  wt = substitute(wt)
  if(n > 0){
    if(is.null(wt)) wt = names(dt)[length(dt)]
    else wt = deparse(wt)
    dt[[wt]] %>% sort(decreasing = TRUE) %>% .[length(.)*n] -> value
    "dt[{wt} >= value]" %>% str_glue() %>% parse(text = .) %>% eval()
  } else{
    n = -n
    if(is.null(wt)) wt = names(dt)[length(dt)]
    else wt = deparse(wt)
    dt[[wt]] %>% sort() %>% .[length(.)*n]  -> value
    "dt[{wt} <= value]" %>% str_glue() %>% parse(text = .) %>% eval()
  }
}

