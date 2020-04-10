
#' @title Tools for working with row names
#' @description The enhanced data.frame, including tibble and data.table, do not
#' support row names. To link to some base r facilities, there should be functions
#' to save information in row names. These functions are analogous to
#' \code{rownames_to_column} and \code{column_to_rownames} in \pkg{tibble}.
#' @param .data A data.frame.
#' @param var Name of column to use for rownames.
#' @return \code{rn_col} returns a data.table,
#' \code{col_rn} returns a data frame.
#' @examples
#'
#'  mtcars %>% rn_col()
#'  mtcars %>% rn_col("rn")
#'
#'  mtcars %>% rn_col() -> new_mtcars
#'
#'  new_mtcars %>% col_rn() -> old_mtcars
#'  old_mtcars
#'  setequal(mtcars,old_mtcars)

#' @rdname rownames
#' @export

rn_col = function(.data,var = "rowname"){
  dt = as_dt(.data)
  eval(parse(text = str_glue("dt[,{var}:=rownames(.data)] %>% relocate_dt({var})")))
}

#' @rdname rownames
#' @export

col_rn = function(.data,var = "rowname"){
  # dt = as_dt(.data)
  dt = as.data.table(.data)
  setDF(dt[,(var):=NULL])
  rownames(dt) = .data[[var]]
  dt
}
