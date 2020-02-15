
#' @title Nest and unnest
#' @description Analogous function for \code{nest} and \code{unnest} in \pkg{tidyr}.
#' \code{unnest_col} will automatically remove other list-columns except for the
#' target list-column (which would be unnested later).
#'
#' @param data data.table, nested or unnested
#' @param group The variable for nest group, could recieve character vector or
#' regular expression.
#' @param negate Applicable when the "group" parameter uses regular expression,
#' if \code{TRUE}, return non-matching elements.
#' @param col The single variable of nested data to be unnested
#' @return data.table, nested or unnested
#' @details In the \code{nest_dt}, the data would be nested to a column named `ndt`,
#'  which is short for nested data.table.
#' @seealso \code{\link[tidyr]{nest}}
#' @references https://www.r-bloggers.com/much-faster-unnesting-with-data-table/
#' @references https://stackoverflow.com/questions/25430986/create-nested-data-tables-by-collapsing-rows-into-new-data-tables
#' @examples
#'
#' mtcars %>% nest_by("cyl")
#' mtcars %>% nest_by("cyl|vs")
#' mtcars %>% nest_by(c("cyl","vs"))
#'
#' mtcars %>% nest_by("cyl|vs") %>%
#'   unnest_col(ndt)

#' @rdname nest
#' @export

# nest by what group?
nest_by = function(data,group = NULL,negate = FALSE){
  dt = as_dt(data)
  if(is.null(group)) return(dt)
  group_name = substitute(group) %>% deparse()
  if(is.character(group) & length(group) == 1){
    names(dt) %>% str_subset(group,negate = negate) %>%
      str_c(collapse = ",") %>%
      str_c(".(",.,")") -> by_name
    eval(parse(text = str_glue("dt[,list(ndt = list(.SD)),by = {by_name}]")))
  }
  else if(is.character(group)){
    group %>% str_c(collapse = ",") %>%
      str_c(".(",.,")") -> by_name
    eval(parse(text = str_glue("dt[,list(ndt = list(.SD)),by = {by_name}]")))
  }
}

# nest by what group? (...)
# nest_dt = function(data, ...){
#   dt = as_dt(data)
#   #var_list = substitute(list(...))
#   dt[,list(ndt = list(.SD)),by = ...] # ndt,short for nested data.table
# }

#' @rdname nest
#' @export

# unnest which column? (col)
unnest_col = function(data,col){
  dt = as_dt(data)
  col_name = substitute(col) %>% deparse()
  lapply(dt,class) -> dt_class
  names(subset(dt_class,dt_class != "list")) -> valid_col_names
  if(!col_name %in% names(dt)) stop("The column does not exist.")
  valid_col_names %>%
    str_c(collapse = ",") %>%
    str_c("list(",.,")") -> group_name
  dt[[col_name]][[1]] -> first_element
  if(is.vector(first_element))
    eval(parse(text = str_glue("dt[,.({col_name} = unlist({col_name},recursive = FALSE)),by = {group_name}]")))
  else
    eval(parse(text = str_glue("dt[,unlist({col_name},recursive = FALSE),by = {group_name}]")))
}


# unnest_dt <- function(data, col) {
#   dt = as.data.table(data)
#   deparse(substitute(col)) -> col_name
#   setdiff(names(dt),col_name) -> group_name
#   call_string = paste0("dt[, unlist(",col_name,",recursive = FALSE), by = list(",group_name,")]")
#   eval(parse(text = call_string))
# }



## could not use `.()`` syntax
 # nest_by = function(data,group = NULL,negate = FALSE){
 #   dt = as_dt(data)
 #   if(is.null(group)) return(dt)
 #   group_name = substitute(group) %>% deparse()
 #   if(str_detect(group_name,"^\\.")){
 #     group_name = substitute(group)
 #     eval(parse(text = str_glue("dt[,list(ndt = list(.SD)),by = {group_name}]")))
 #   }
 #   else if(is.character(group) & length(group) == 1){
 #     names(dt) %>% str_subset(group,negate = negate) %>%
 #       str_c(collapse = ",") %>%
 #       str_c(".(",.,")") -> by_name
 #     eval(parse(text = str_glue("dt[,list(ndt = list(.SD)),by = {by_name}]")))
 #   }
 #   else if(is.character(group)){
 #     group %>% str_c(collapse = ",") %>%
 #       str_c(".(",.,")") -> by_name
 #     eval(parse(text = str_glue("dt[,list(ndt = list(.SD)),by = {by_name}]")))
 #   }
 # }


