

#' @title Count observations by group
#' @description Analogous function for \code{count} and \code{add_count} in \pkg{dplyr}.
#'
#' @param data data.table/data.frame data.frame will be automatically converted
#'   to data.table.
#' @param ... variables to group by.
#' @param sort logical. If TRUE result will be sorted in desending order by resulting variable.
#' @param name character. Name of resulting variable. Default uses "n".
#'
#' @return data.table
#' @seealso \code{\link[dplyr]{count}}
#' @examples
#' iris %>% count_dt(Species)
#' iris %>% count_dt(Species,name = "count")
#' iris %>% add_count_dt(Species)
#' iris %>% add_count_dt(Species,name = "N")
#'
#' mtcars %>% count_dt(cyl,vs)
#' mtcars %>% add_count_dt(cyl,vs)
#'
#' @rdname count
#' @export
count_dt = function(data,...,sort = TRUE,name = "n"){
  dt = as_dt(data)
  dot_string = substitute(list(...))
  if(sort == TRUE) dt[,.(n = .N),by = dot_string][order(-n)] -> dt
  else dt[,.(n = .N),by = dot_string] -> dt
  if(name != "n")  setnames(dt,old = "n",new = name)
  as.data.table(dt)
}

#' @rdname count
#' @export
add_count_dt = function(data,...,name = "n"){
  dt = as_dt(data)
  dot_string = substitute(list(...))
  dt[,mutate_dt(.SD,n = .N),by = dot_string] -> dt
  if(name != "n")  setnames(dt,old = "n",new = name)
  as.data.table(dt)
}


globalVariables(c("n"))
