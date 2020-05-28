
#' @title Join tables
#' @name join
#' @description  The mutating joins add columns from `y` to `x`,
#' matching rows based on the keys:
#'
#' * `inner_join_dt()`: includes all rows in `x` and `y`.
#' * `left_join_dt()`: includes all rows in `x`.
#' * `right_join_dt()`: includes all rows in `y`.
#' * `full_join_dt()`: includes all rows in `x` or `y`.
#' @description
#' Filtering joins filter rows from `x` based on the presence or absence
#' of matches in `y`:
#'
#' * `semi_join_dt()` return all rows from `x` with a match in `y`.
#' * `anti_join_dt()` return all rows from `x` without a match in `y`.
#' @param x A data.table
#' @param y A data.table
#' @param by (Optional) A character vector of variables to join by.
#'
#'   If `NULL`, the default, `*_join_dt()` will perform a natural join, using all
#'   variables in common across `x` and `y`. A message lists the variables so that you
#'   can check they're correct; suppress the message by supplying `by` explicitly.
#'
#'   To join by different variables on `x` and `y`, use a named vector.
#'   For example, `by = c("a" = "b")` will match `x$a` to `y$b`.
#'
#'   To join by multiple variables, use a vector with length > 1.
#'   For example, `by = c("a", "b")` will match `x$a` to `y$a` and `x$b` to
#'   `y$b`. Use a named vector to match different variables in `x` and `y`.
#'   For example, `by = c("a" = "b", "c" = "d")` will match `x$a` to `y$b` and
#'   `x$c` to `y$d`.
#' @param on  (Optional)
#' Indicate which columns in x should be joined with which columns in y.
#' Examples included:
#'   1.\code{.by = c("a","b")} (this is a must for \code{set_full_join_dt});
#'   2.\code{.by = c(x1="y1", x2="y2")};
#'   3.\code{.by = c("x1==y1", "x2==y2")};
#'   4.\code{.by = c("a", V2="b")};
#'   5.\code{.by = .(a, b)};
#'   6.\code{.by = c("x>=a", "y<=b")} or \code{.by = .(x>=a, y<=b)}.
#' @param suffix If there are non-joined duplicate variables in x and y, these
#'   suffixes will be added to the output to disambiguate them. Should be a
#'   character vector of length 2.
#' @return A data.table
#' @examples
#'
#' workers = fread("
#'     name company
#'     Nick Acme
#'     John Ajax
#'     Daniela Ajax
#' ")
#'
#' positions = fread("
#'     name position
#'     John designer
#'     Daniela engineer
#'     Cathie manager
#' ")
#'
#' workers %>% inner_join_dt(positions)
#' workers %>% left_join_dt(positions)
#' workers %>% right_join_dt(positions)
#' workers %>% full_join_dt(positions)
#'
#' # filtering joins
#' workers %>% anti_join_dt(positions)
#' workers %>% semi_join_dt(positions)
#'
#' # To suppress the message, supply 'by' argument
#' workers %>% left_join_dt(positions, by = "name")
#'
#' # Use a named 'by' if the join variables have different names
#' positions2 = setNames(positions, c("worker", "position")) # rename first column in 'positions'
#' workers %>% inner_join_dt(positions2, by = c("name" = "worker"))
#'
#' # the syntax of 'on' could be a bit different
#' workers %>% inner_join_dt(positions2,on = "name==worker")
#'
#'

#' @rdname join
#' @export
inner_join_dt = function(x,y,by = NULL, on = NULL,suffix = c(".x",".y")){
  x = as_dt(x)
  y = as_dt(y)
  on_ = substitute(on) %>% deparse()
  by_ = substitute(by) %>% deparse()
  if(on_ != "NULL") x[y, nomatch = 0L, on = on]
  else if(by_ == "NULL"){
    by = intersect(names(x), names(y))
    by_name = str_c(by, collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
    merge.data.table(x,y,by = by,suffixes = suffix)
  }else if(is.null(names(by))) merge.data.table(x,y,by = by,suffixes = suffix)
  else merge.data.table(x,y,by.x = names(by),by.y = by,suffixes = suffix)
}

#' @rdname join
#' @export
left_join_dt = function(x,y,by = NULL, on = NULL,suffix = c(".x",".y")){
  x = as_dt(x)
  y = as_dt(y)
  on_ = substitute(on) %>% deparse()
  by_ = substitute(by) %>% deparse()
  if(on_ != "NULL") y[x, on = on]
  else if(by_ == "NULL"){
    by = intersect(names(x), names(y))
    by_name = str_c(by, collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
    merge.data.table(x,y,by = by,all.x = TRUE,suffixes = suffix)
  }else if(is.null(names(by))) merge.data.table(x,y,by = by,all.x = TRUE,suffixes = suffix)
  else merge.data.table(x,y,by.x = names(by),by.y = by,all.x = TRUE,suffixes = suffix)
}

#' @rdname join
#' @export
right_join_dt = function(x,y,by = NULL, on = NULL,suffix = c(".x",".y")){
  x = as_dt(x)
  y = as_dt(y)
  on_ = substitute(on) %>% deparse()
  by_ = substitute(by) %>% deparse()
  if(on_ != "NULL") x[y, on = on]
  else if(by_ == "NULL"){
    by = intersect(names(x), names(y))
    by_name = str_c(by, collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
    merge.data.table(x,y,by = by,all.y = TRUE,suffixes = suffix)
  }else if(is.null(names(by))) merge.data.table(x,y,by = by,all.y = TRUE,suffixes = suffix)
  else merge.data.table(x,y,by.x = names(by),by.y = by,all.y = TRUE,suffixes = suffix)
}

#' @rdname join
#' @export
full_join_dt = function(x,y,by = NULL, on = NULL,suffix = c(".x",".y")){
  x = as_dt(x)
  y = as_dt(y)
  on_ = substitute(on) %>% deparse()
  by_ = substitute(by) %>% deparse()
  if(on_ != "NULL") {
    if(by_!="null"){
      rbind(x[, .SD, .SDcols = by],
            y[, .SD, .SDcols = by]) %>%
        unique()-> unique_keys
      y[x[.(unique_keys), on = on], on = on]
    }else{
      rbind(x[, .SD, .SDcols = on],
            y[, .SD, .SDcols = on]) %>%
        unique()-> unique_keys
      y[x[.(unique_keys), on = on], on = on]
    }
  } else if(by_ == "NULL"){
    by = intersect(names(x), names(y))
    by_name = str_c(by, collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
    merge.data.table(x,y,by = by,all = TRUE,suffixes = suffix)
  }else if(is.null(names(by))) merge.data.table(x,y,by = by,all = TRUE,suffixes = suffix)
  else merge.data.table(x,y,by.x = names(by),by.y = by,all = TRUE,suffixes = suffix)
}

#' @rdname join
#' @export
anti_join_dt = function(x,y,by = NULL, on = NULL){
  x = as_dt(x)
  y = as_dt(y)
  on_ = substitute(on) %>% deparse()
  by_ = substitute(by) %>% deparse()
  if(on_ != "NULL") x[!y, on = on]
  else if(by_ == "NULL"){
    by = intersect(names(x), names(y))
    by_name = str_c(by, collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
    x[!y, on = by]
  }else x[!y, on = by]
}

#' @rdname join
#' @export
semi_join_dt = function(x,y,by = NULL, on = NULL){
  x = as_dt(x)
  y = as_dt(y)
  on_ = substitute(on) %>% deparse()
  by_ = substitute(by) %>% deparse()
  if(on_ != "NULL") {
    w = unique(x[y, on = on, nomatch = 0L, which = TRUE, allow.cartesian = TRUE])
    x[w]
  }
  else{
    if(by_ == "NULL"){
      by = intersect(names(x), names(y))
      by_name = str_c(by, collapse = ",")
      message(str_glue("Joining by: {by_name}\n\n"))
    }
    w = unique(x[y, on = by, nomatch = 0L, which = TRUE, allow.cartesian = TRUE])
    x[w]
  }
}
