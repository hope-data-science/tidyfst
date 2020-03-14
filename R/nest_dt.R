
#' @title Nest and unnest
#' @description Analogous function for \code{nest} and \code{unnest} in \pkg{tidyr}.
#' \code{unnest_dt} will automatically remove other list-columns except for the
#' target list-columns (which would be unnested later). Also, \code{squeeze_dt} is
#' designed to merge multiple columns into list column.
#' @param data data.table, nested or unnested
#' @param ... The variables for nest group(for \code{nest_dt}),
#' columns to be nested(for \code{squeeze_dt} and \code{chop_dt}),
#' or column(s) to be unnested(for \code{unnest_dt}).
#' Could recieve anything that \code{\link[tidyfst]{select_dt}} could receive.
#' @param mcols Name-variable pairs in the list, form like
#' \code{list(petal="^Pe",sepal="^Se")}, see example.
#' @return data.table, nested or unnested
#' @details In the \code{nest_dt}, the data would be nested to a column named `ndt`,
#'  which is short for nested data.table.
#' @details The \code{squeeze_dt} would not remove the originial columns.
#' @details The \code{unchop_dt} is the reverse operation of \code{chop_dt}.
#' @details These functions are experiencing the experimental stage, especially
#' the \code{unnest_dt}. If they don't work on some circumtances, try \pkg{tidyr}
#' package.
#' @seealso \code{\link[tidyr]{nest}}, \code{\link[tidyr]{chop}}
#' @references https://www.r-bloggers.com/much-faster-unnesting-with-data-table/
#' @references https://stackoverflow.com/questions/25430986/create-nested-data-tables-by-collapsing-rows-into-new-data-tables
#' @examples
#'
#' # examples for nest_dt
#' # nest by which columns?
#'  mtcars %>% nest_dt(cyl)
#'  mtcars %>% nest_dt("cyl")
#'  mtcars %>% nest_dt(cyl,vs)
#'  mtcars %>% nest_dt(vs:am)
#'  mtcars %>% nest_dt("cyl|vs")
#'  mtcars %>% nest_dt(c("cyl","vs"))
#'
#' # nest two columns directly
#' iris %>% nest_dt(mcols = list(petal="^Pe",sepal="^Se"))
#'
#' # examples for unnest_dt
#' # unnest which column?
#'  mtcars %>% nest_dt("cyl|vs") %>%
#'    unnest_dt(ndt)
#'  mtcars %>% nest_dt("cyl|vs") %>%
#'    unnest_dt("ndt")
#'
#' df <- data.table(
#'   a = list(c("a", "b"), "c"),
#'   b = list(c(TRUE,TRUE),FALSE),
#'   c = list(3,c(1,2)),
#'   d = c(11, 22)
#' )
#'
#' df
#' df %>% unnest_dt(a)
#' df %>% unnest_dt(2)
#' df %>% unnest_dt("c")
#' df %>% unnest_dt(cols = names(df)[3])
#'
#' # You can unnest multiple columns simultaneously
#' df %>% unnest_dt(1:3)
#' df %>% unnest_dt(a,b,c)
#' df %>% unnest_dt("a|b|c")
#'
#' # examples for squeeze_dt
#' # nest which columns?
#' iris %>% squeeze_dt(1:2)
#' iris %>% squeeze_dt("Se")
#' iris %>% squeeze_dt(Sepal.Length:Petal.Width)
#'
#' # examples for chop_dt
#' df <- data.table(x = c(1, 1, 1, 2, 2, 3), y = 1:6, z = 6:1)
#' df %>% chop_dt(y,z)
#' df %>% chop_dt(y,z) %>% unchop_dt(y,z)

#' @rdname nest
#' @export

# nest by which columns?

nest_dt = function(data,...,mcols = NULL){
  dt = as_dt(data)
  if(is.null(mcols)) nest_by(dt,...)
  else{
    names(dt) %>%
      str_subset(str_c(mcols,collapse = "|"),
                 negate = TRUE) -> group_names
    lapply(mcols,function(x) str_subset(names(dt),x)) %>%
      lapply(function(x) c(x,group_names)) %>%
      lapply(function(x) select_dt(dt,cols = x)) %>%
      lapply(function(x) nest_by(dt,cols = group_names)) %>%
      lapply(function(x) setkeyv(x,cols = group_names))-> list_table
    for(i in seq_along(list_table)){
      list_table[[i]] = setnames(list_table[[i]],
                               old = "ndt",new = names(list_table[i]))
    }
    Reduce(f = merge,x = list_table)
  }
}

nest_by = function(data,...){
  dt = as_dt(data)
  dt[0] %>% select_dt(...) %>% names() %>%
    str_c(collapse = ",")-> group
  eval(parse(text = str_glue("dt[,.(ndt = list(.SD)),by = .({group})]")))
}

#' @rdname nest
#' @export

# unnest which column(s)?

unnest_dt = function(data,...){
  dt = as_dt(data)
  col_names = dt[0] %>% select_dt(...) %>% names()
  if(length(col_names) == 1) unnest_col(dt,...)
  else
    lapply(col_names,function(x) unnest_col(dt,cols = x)) %>%
    Reduce(x = ., f = function(x,y) merge(x,y))
}

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


#' @rdname nest
#' @export

# nest which columns?

squeeze_dt = function(data,...){
  dt = as_dt(data)
  dt %>% select_dt(...) %>%
    setNames(NULL) %>%
    apply(1,list) %>%
    lapply(unlist)-> ndt
  dt[,ndt := ndt][]
}

#' @rdname nest
#' @export
chop_dt = function(data,...){
  dt = as_dt(data)
  dt[0] %>% select_dt(...) %>% names() -> data_cols
  setdiff(names(dt),data_cols) -> group_cols
  group_cols %>%
    str_c(collapse = ",") %>%
    str_c("list(",.,")") -> group_names
  eval(parse(text = str_glue("dt[,lapply(.SD,list),
                             by = {group_names}]")))
}

#' @rdname nest
#' @export
unchop_dt = function(data,...){
  dt = as_dt(data)
  col_names = dt[0] %>% select_dt(...) %>% names()
  group_names = setdiff(names(dt),col_names)
  if(length(col_names) == 1) unnest_col(dt,...)
  else
    lapply(col_names,function(x) unnest_col(dt,cols = x)) %>%
    Reduce(x = ., f = function(x,y) cbind(x,y)) %>%
    .[,unique(names(.)),with=FALSE]
}



