
#' @title Fast operations of data.table by reference (II)
#' @description Combination of \code{set*} functions provided by \pkg{data.table}.
#'  This is memeroy efficient because no copy is made at all.
#' @param .data A data.table
#' @param ...
#'  For \code{set_in_dt}: Receive '[i,j,by]' in data.table syntax.
#'   See \code{\link[tidyfst]{in_dt}}.
#'  For \code{set_mutate}:
#'   List of variables or name-value pairs of summary/modifications functions.
#'   See \code{\link[tidyfst]{mutate_dt}}.
#'  For \code{set_arrange}:
#'   Arrange by what group? Minus means descending order.
#'   See \code{\link[tidyfst]{arrange_dt}}.
#'  For \code{set_rename}:
#'   List of variables or name-value pairs of summary/modifications functions.
#'   See \code{\link[tidyfst]{rename_dt}}.
#'  For \code{set_relocate}: Columns to move.
#'   See \code{\link[tidyfst]{relocate_dt}}
#'  For \code{set_add_count}: Variables to group by.
#'   See \code{\link[tidyfst]{add_count_dt}}
#'  For \code{set_replace_na} and \code{set_fill_na}:
#'   Colunms to be replaced or filled. If not specified, use all columns.
#'   See \code{\link[tidyfst]{fill_na_dt}}
#' @param by 	Mutate by which group(s)?
#' @param cols For \code{set_arrange}:A character vector of column names of x by which to order.
#' If present, override \code{...}. Defaults to \code{NULL}.
#' @param order For \code{set_arrange}:An integer vector with only possible
#' values of 1 and -1, corresponding to ascending and descending order.
#' Defaults to 1.
#' @param how For \code{set_relocate}:The mode of movement, including "first","last","after","before". Default uses "first".
#' @param where For \code{set_relocate}:Destination of columns selected by .... Applicable for "after" and "before" mode.
#' @param .name For \code{set_add_count}:
#' Character. Name of resulting variable. Default uses "n".
#' @param to What value should NA replace by?
#' @param direction Direction in which to fill missing values. Currently either "down" (the default) or "up".
#' @details These are a set of functions for modification
#' on data.table by reference. They follow the same syntax of similar
#' \pkg{tidyfst} functions. They do not return the result and considered
#' to be memory efficient.
#' @return  The input is modified by reference, and returned (invisibly)
#' so it can be used in compound statements.
#' @seealso \code{\link[tidyfst]{set_dt}}
#' @examples
#'
#' library(pryr)
#' rm(list = ls())
#'
#' nr_of_rows <- 1e5
#'
#' df <- data.table(
#'   Logical = sample(c(TRUE, FALSE, NA),
#'                    prob = c(0.85, 0.1, 0.05),
#'                    nr_of_rows, replace = TRUE)
#' )
#'
#' mem_change(mutate_dt(df,one = 1) -> res)
#'
#' # makes no copy, update on "df" directly
#' mem_change(set_mutate(df,one = 1))
#'
#' all.equal(res,df)

#' @rdname set
#' @export
set_in_dt = function(.data,...){
  .data[...]
}

#' @rdname set
#' @export
set_mutate = function(.data,...,by = NULL){
  .data = setDT(.data)
  eval(substitute(.data[,`:=`(...),by]))
}

# set_mutate = function(.data,...){
#   substitute(list(...)) %>%
#     deparse() %>%
#     str_remove("list") -> dot_string
#   eval(parse(text = str_glue(".data[,`:=`{dot_string}]")))
# }

#' @rdname set
#' @export
set_arrange = function(.data,...,cols = NULL,order = 1L){
  if(is.null(cols)) setorder(.data,...)
  else setorderv(.data,cols = cols,order = order)
}

#' @rdname set
#' @export
set_rename = function(.data,...){
  substitute(list(...)) %>%
    lapply(deparse) %>%
    .[-1] -> dot_string
  new_names = names(dot_string)
  old_names = as.character(dot_string)
  setnames(.data,old = old_names,new = new_names)
}

#' @rdname set
#' @export
set_relocate = function(.data,...,
                        how= "first",
                        where = NULL){
  relocate_dt(.data[0],...,how= how, where = where) %>%
    names() -> name_order
  setcolorder(.data,neworder = name_order)
}


#' @rdname set
#' @export
set_add_count = function (.data, ..., .name = "n") {
  dot_string = substitute(list(...)) %>% deparse()
  eval(parse(text = str_glue(".data[, {.name}:= .N, by = {dot_string}]")))
}

#' @rdname set
#' @export
set_replace_na = function (.data, ..., to) {
  if (substitute(list(...)) %>% deparse() == "list()")
    dot_string <- NULL
  else dot_string <- .data[0] %>% select_dt(...) %>% names()
  if (is.null(dot_string)) {
    for (j in seq_len(ncol(.data)))
      set(.data, which(is.na(.data[[j]])), j, to)
  }
  else {
    for (j in dot_string)
      set(.data, which(is.na(.data[[j]])), j, to)
  }
}

#' @rdname set
#' @export
set_fill_na = function (.data, ..., direction = "down") {

  if (substitute(list(...)) %>% deparse() == "list()")
    update_cols <- names(.data)
  else update_cols <- .data[0] %>% select_dt(...) %>% names()
  num_cols <- .data[0] %>%
    select_dt(cols = update_cols) %>%
    select_dt(is.numeric) %>%
    names()
  nnum_cols <- setdiff(update_cols, num_cols)
  if (length(num_cols) > 0) {
    if (direction == "down")
      setnafill(.data, type = "locf", cols = num_cols)
    else if (direction == "up")
      setnafill(.data, type = "nocb", cols = num_cols)
  }
  if (length(nnum_cols) > 0) {
    .data[, `:=`((nnum_cols),
           lapply(.SD, shift_fill,  direction = direction)),
          .SDcols = nnum_cols]
  }
}




