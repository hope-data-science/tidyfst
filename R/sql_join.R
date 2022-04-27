

#' @title Case insensitive table joining like SQL
#' @name sql_join
#' @description Work like the `*_join_dt` series functions, joining
#' tables with common or customized keys  in various ways. The only
#' difference is the joining is case insensitive like SQL.
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
#'
#'   Notice that in `sql_join`, the joining variables would turn to upper case
#'   in the output table.
#' @param type Which type of join would you like to use?
#'  Default uses "inner", other options include
#'  "left", "right", "full", "anti", "semi".
#' @param suffix If there are non-joined duplicate variables in x and y, these
#'   suffixes will be added to the output to disambiguate them. Should be a
#'   character vector of length 2.
#' @return A data.table
#' @seealso \code{\link[tidyfst]{join}}
#' @examples
#' dt1 = data.table(x = c("A","b"),y = 1:2)
#' dt2 = data.table(x = c("a","B"),z = 4:5)
#' sql_join_dt(dt1,dt2)


#' @rdname sql_join
#' @export
sql_join_dt = function(x,y,by = NULL,type = "inner",suffix = c(".x",".y")){

  x = as.data.table(x)
  y = as.data.table(y)
  by_ = substitute(by) %>% deparse()
  if(by_ == "NULL"){
    by = intersect(names(x), names(y))
    x = x[,(by) := lapply(.SD,toupper),.SDcols = by]
    y = y[,(by) := lapply(.SD,toupper),.SDcols = by]
  }  else{
    x = x[,(names(by)) := lapply(.SD,toupper),.SDcols = names(by)]
    y = y[,(by) := lapply(.SD,toupper),.SDcols = by]
  }
  if(type %in% c("anti","semi"))
    get(str_glue("{type}_join_dt"))(x,y,by = by)
  else
    get(str_glue("{type}_join_dt"))(x,y,by = by,suffix = suffix)
}



