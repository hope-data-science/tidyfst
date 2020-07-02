
#' @title Change column order
#' @description Change the position of columns,
#'  using the same syntax as `select_dt()`. Check similar function
#'  as `relocate` in \pkg{dplyr}.
#' @param .data A data.frame
#' @param ... Columns to move
#' @param how The mode of movement, including "first","last","after","before".
#' Default uses "first".
#' @param where Destination of columns selected by \code{...}.
#' Applicable for "after" and "before" mode.
#' @return A data.table with rearranged columns.

#' @examples
#' df <- data.table(a = 1, b = 1, c = 1, d = "a", e = "a", f = "a")
#' df
#' df %>% relocate_dt(f)
#' df %>% relocate_dt(a,how = "last")
#'
#' df %>% relocate_dt(is.character)
#' df %>% relocate_dt(is.numeric, how = "last")
#' df %>% relocate_dt("[aeiou]")
#'
#' df %>% relocate_dt(a, how = "after",where = f)
#' df %>% relocate_dt(f, how = "before",where = a)
#' df %>% relocate_dt(f, how = "before",where = c)
#' df %>% relocate_dt(f, how = "after",where = c)
#'
#' df2 <- data.table(a = 1, b = "a", c = 1, d = "a")
#' df2 %>% relocate_dt(is.numeric,
#'                     how = "after",
#'                     where = is.character)
#' df2 %>% relocate_dt(is.numeric,
#'                     how="before",
#'                     where = is.character)

#' @export

relocate_dt = function(.data,...,
                       how= "first",
                       where = NULL){
  #dt = as_dt(.data)
  dt = as.data.table(.data)

  dt[0] %>% select_dt(...) %>% names() -> sel_names
  names(dt[0]) %>% setdiff(sel_names) -> rest_names
  dt[0] %>% select_dt(cols = rest_names) -> rest_dt
  substitute(where) %>% deparse() -> where_n
  if(str_detect(where_n,"^\"|^'")) where_n = where

  if(how == "first") c(sel_names,rest_names) -> name_order
  else if(how == "last") c(rest_names,sel_names) -> name_order
  else if(where_n == "NULL") stop("The `where` parameter should be provided.")
  else
  {
    if(where_n %like% "^is\\."){
      eval(parse(text = str_glue("dt1 = select_dt(rest_dt,{where_n}) %>% names")))
      eval(parse(text = str_glue("dt2 = select_dt(rest_dt,-{where_n}) %>% names")))
      if(how == "after") c(dt1,sel_names,dt2) -> name_order
      else c(sel_names,dt1,dt2) -> name_order
    }
    else{
      chmatch(where_n,rest_names) -> position
      if(how == "after"){
        if(position < length(rest_names))
          c(rest_names[1:position], sel_names,
            rest_names[(position+1):length(rest_names)]) -> name_order
        else c(rest_names,sel_names) -> name_order
      }
      else if(how == "before"){
        if(position > 1)
          c(rest_names[1:(position-1)],sel_names,
            rest_names[position:length(rest_names)]) -> name_order
        else c(sel_names,rest_names) -> name_order
      }
      else stop("The `how` parameter could not be recognized.")
    }
  }
  setcolorder(dt,neworder = name_order)[]
}

# relocate_dt = function(.data,...,
#                        how= "first",
#                        where = NULL){
#   dt = as_dt(.data)
#
#   dt %>% select_dt(...) -> sel_dt
#   names(sel_dt) -> sel_names
#   names(dt) %>% setdiff(sel_names) -> rest_names
#   dt %>% select_dt(cols = rest_names) -> rest_dt
#   substitute(where) %>% deparse() -> where_n
#   if(str_detect(where_n,"^\"|^'")) where_n = where
#
#   if(how == "first") c(sel_dt,rest_dt) %>% as.data.table()
#   else if(how == "last") c(rest_dt,sel_dt) %>% as.data.table()
#   else if(where_n == "NULL") stop("The `where` parameter should be provided.")
#   else
#   {
#     if(where_n %like% "^is\\."){
#       eval(parse(text = str_glue("dt1 = select_dt(rest_dt,{where_n})")))
#       eval(parse(text = str_glue("dt2 = select_dt(rest_dt,-{where_n})")))
#       if(how == "after") cbind(dt1,sel_dt,dt2) %>% as.data.table()
#       else cbind(sel_dt,dt1,dt2) %>% as.data.table()
#     }
#     else{
#       chmatch(where_n,names(rest_dt)) -> position
#       if(how == "after"){
#         if(position < ncol(rest_dt))
#           as.data.table(cbind(rest_dt[,1:position],
#                               sel_dt,
#                               rest_dt[,(position+1):ncol(rest_dt)]))
#         else c(rest_dt,sel_dt) %>% as.data.table()
#       }
#       else if(how == "before"){
#         if(position > 1)
#           as.data.table(cbind(rest_dt[,1:(position-1)],
#                               sel_dt,
#                               rest_dt[,position:ncol(rest_dt)]))
#         else c(sel_dt,rest_dt) %>% as.data.table()
#       }
#       else stop("The `how` parameter could not be recognized.")
#     }
#   }
# }

globalVariables(c("dt1","dt2"))




