
#' @title Nest and unnest
#' @description Analogous function for \code{nest} and \code{unnest} in \pkg{tidyr}.
#' \code{unnest_col} will automatically remove other list-columns except for the
#' target list-column (which would be unnested later). Also, \code{nest_cols} is
#' designed to merge multiple columns into list column.
#' @param data data.table, nested or unnested
#' @param ... The variables for nest group(for \code{nest_by}),
#' columns to be nested(for \code{nest_cols}),
#' or column to be unnested(for \code{unnest_col}).
#' Could recieve anything that \code{\link[tidyfst]{select_dt}} could receive.
#' @return data.table, nested or unnested
#' @details In the \code{nest_dt}, the data would be nested to a column named `ndt`,
#'  which is short for nested data.table.
#' @details The \code{nest_cols} would not remove the originial columns.
#' @seealso \code{\link[tidyr]{nest}}
#' @references https://www.r-bloggers.com/much-faster-unnesting-with-data-table/
#' @references https://stackoverflow.com/questions/25430986/create-nested-data-tables-by-collapsing-rows-into-new-data-tables
#' @examples
#'
#' # examples for nest_by
#' # nest by which columns?
#'  mtcars %>% nest_by(cyl)
#'  mtcars %>% nest_by("cyl")
#'  mtcars %>% nest_by(cyl,vs)
#'  mtcars %>% nest_by(vs:am)
#'  mtcars %>% nest_by("cyl|vs")
#'  mtcars %>% nest_by(c("cyl","vs"))
#'
#' # examples for unnest_col
#' # unnest which column?
#'  mtcars %>% nest_by("cyl|vs") %>%
#'    unnest_col(ndt)
#'  mtcars %>% nest_by("cyl|vs") %>%
#'    unnest_col("ndt")
#'
#' # examples for nest_cols
#' # nest which columns?
#' iris %>% nest_cols(1:2)
#' iris %>% nest_cols("Se")
#' iris %>% nest_cols(Sepal.Length:Petal.Width)

#' @rdname nest
#' @export

# nest by which columns?

nest_by = function(data,...){
  dt = as_dt(data)
  dt[0] %>% select_dt(...) %>% names() %>%
    str_c(collapse = ",")-> group
  eval(parse(text = str_glue("dt[,.(ndt = list(.SD)),by = .({group})]")))
}

#' @rdname nest
#' @export

# nest which columns?

nest_cols = function(data,...){
  dt = as_dt(data)
  dt %>% select_dt(...) %>%
    setNames(NULL) %>%
    apply(1,list) %>%
    lapply(unlist)-> ndt
  dt[,ndt := ndt][]
}


#' @rdname nest
#' @export

# unnest which column?

unnest_col = function(data,...){
  dt = as_dt(data)
  col_name = dt[0] %>% select_dt(...) %>% names()
  lapply(dt,class) -> dt_class
  names(subset(dt_class,dt_class != "list")) -> valid_col_names
  if(!col_name %chin% names(dt)) stop("The column does not exist.")
  valid_col_names %>%
    str_c(collapse = ",") %>%
    str_c("list(",.,")") -> group_name
  dt[[col_name]][[1]] -> first_element
  if(is.vector(first_element))
    eval(parse(text = str_glue("dt[,.({col_name} = unlist({col_name},recursive = FALSE)),by = {group_name}]")))
  else
    eval(parse(text = str_glue("dt[,unlist({col_name},recursive = FALSE),by = {group_name}]")))
}


# unnest_col = function(data,col){
#   dt = as_dt(data)
#   col_name = substitute(col) %>% deparse()
#   lapply(dt,class) -> dt_class
#   names(subset(dt_class,dt_class != "list")) -> valid_col_names
#   if(!col_name %in% names(dt)) stop("The column does not exist.")
#   valid_col_names %>%
#     str_c(collapse = ",") %>%
#     str_c("list(",.,")") -> group_name
#   dt[[col_name]][[1]] -> first_element
#   if(is.vector(first_element))
#     eval(parse(text = str_glue("dt[,.({col_name} = unlist({col_name},recursive = FALSE)),by = {group_name}]")))
#   else
#     eval(parse(text = str_glue("dt[,unlist({col_name},recursive = FALSE),by = {group_name}]")))
# }



