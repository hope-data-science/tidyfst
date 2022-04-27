
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
#' @param by Slice by which group(s)?
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
#'
#' # use by to slice by group
#'
#' ## following codes get the same results
#' slice_dt(a,1:3,by = "Species")
#' slice_dt(a,1:3,by = Species)
#' slice_dt(a,1:3,by = .(Species))
#'
#' slice_head_dt(a,2,by = Species)
#' slice_tail_dt(a,2,by = Species)
#'
#' slice_max_dt(a,Sepal.Length,3,by = Species)
#' slice_max_dt(a,Sepal.Length,3,by = Species,with_ties = FALSE)
#' slice_min_dt(a,Sepal.Length,3,by = Species)
#' slice_min_dt(a,Sepal.Length,3,by = Species,with_ties = FALSE)
#'
#' # in `slice_sample_dt`, "by" could only take character class
#' slice_sample_dt(a,.1,by = "Species")
#' slice_sample_dt(a,3,by = "Species")
#' slice_sample_dt(a,51,replace = TRUE,by = "Species")
#'

#' @rdname slice
#' @export
slice_dt = function(.data,...,by = NULL){
  dt = as_dt(.data)
  substitute(by) %>% deparse() -> by_char
  if(by_char == "NULL") dt[eval(substitute(c(...)))]
  else
    eval(substitute(
    dt[,.SD[c(...)],by]
  ))
}


# slice_dt = function(.data,...){
#   as_dt(.data)[eval(substitute(c(...)))]
# }

#' @rdname slice
#' @export
slice_head_dt = function(.data,n,by = NULL){
  .data = as_dt(.data)
  substitute(by) %>% deparse() -> by_char
  if(by_char == "NULL"){
    if(abs(n) >= 1L) head(.data,n)
    else head(.data,nrow(.data)*n)
  }else{
    if(abs(n) >= 1L)
      eval(substitute(
        .data[,head(.SD,n),by]
      ))
    else
      eval(substitute(
        .data[,head(.SD,nrow(.SD)*n),by]
      ))
  }
}


# slice_head_dt = function(.data,n){
#   .data = as_dt(.data)
#   if(abs(n) >= 1L) head(.data,n)
#   else head(.data,nrow(.data)*n)
# }

#' @rdname slice
#' @export
slice_tail_dt = function(.data,n,by = NULL){
  .data = as_dt(.data)
  substitute(by) %>% deparse() -> by_char
  if(by_char == "NULL"){
    if(abs(n) >= 1L) tail(.data,n)
    else tail(.data,nrow(.data)*n)
  }else{
    if(abs(n) >= 1L)
      eval(substitute(
        .data[,tail(.SD,n),by]
      ))
    else
      eval(substitute(
        .data[,tail(.SD,nrow(.SD)*n),by]
      ))
  }
}

# slice_tail_dt = function(.data,n){
#   .data = as_dt(.data)
#   if(abs(n) >= 1L) tail(.data,n)
#   else tail(.data,nrow(.data)*n)
# }

#' @rdname slice
#' @export
slice_max_dt = function(.data,order_by,n,by = NULL,with_ties = TRUE){
  dt = as_dt(.data)
  wt = substitute(order_by) %>% deparse()
  by = substitute(by) %>% deparse()
  setorderv(dt,cols = wt,order = -1L)
  if (n > 0 & n < 1)
    n = nrow(.data) * n
  else if (n <= 0)
    stop("Invalid input, n should take a positive value.")

  if(by != "NULL"){
    if(with_ties){
      eval(parse(text = str_glue("
                            dt[,.SD[{wt} %in% ({wt} %>%
                            sort %>% tail(.,n) %>% unique)],{by}]
                             ")))
    }
    else{
      eval(parse(text = str_glue("
                            dt[,.SD[1:n],{by}]
                             ")))
    }
  }else{
    if(with_ties) eval(parse(text = str_glue("
                            dt[{wt} %in% (sort({wt}) %>%
                            tail(.,n) %>% unique)]
                             ")))
    else dt[1:n]
  }
}

#' @rdname slice
#' @export
slice_min_dt = function(.data,order_by,n,by = NULL,with_ties = TRUE){
  dt = as_dt(.data)
  wt = substitute(order_by) %>% deparse()
  by = substitute(by) %>% deparse()
  setorderv(dt,cols = wt,order = 1L)
  if (n > 0 & n < 1)
    n = nrow(.data) * n
  else if (n <= 0)
    stop("Invalid input, n should take a positive value.")

  if(by != "NULL"){
    if(with_ties){
      eval(parse(text = str_glue("
                            dt[,.SD[{wt} %in% ({wt} %>%
                            sort %>% head(.,n) %>% unique)],{by}]
                             ")))
    }
    else{
      eval(parse(text = str_glue("
                            dt[,.SD[1:n],{by}]
                             ")))
    }
  }else{
    if(with_ties) eval(parse(text = str_glue("
                            dt[{wt} %in% (sort({wt}) %>%
                            head(.,n) %>% unique)]
                             ")))
    else dt[1:n]
  }
}

#' @rdname slice
#' @export
slice_sample_dt = function(.data, n, replace = FALSE, by = NULL){
  if(n >= 1L) sample_n_dt(.data,size = n,replace = replace,by = by)
  else if(n > 0) sample_frac_dt(.data,size = n,replace = replace,by = by)
  else stop("Invalid input, n should take a positive value.")
}



