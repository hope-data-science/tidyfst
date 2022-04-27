

#' @title Select distinct/unique rows in data.frame
#' @description Select only unique/distinct rows from a data frame.
#' @param .data data.frame
#' @param ... Optional variables to use when determining uniqueness.
#'  If there are multiple rows for a given combination of inputs,
#'  only the first row will be preserved.
#'  If omitted, will use all variables.
#' @param .keep_all If \code{TRUE}, keep all variables in data.frame. If a combination of ... is not distinct,
#' this keeps the first row of values.
#' @param fromLast Logical indicating if duplication should be
#' considered from the reverse side. Defaults to \code{FALSE}.
#' @return data.table
#' @seealso \code{\link[dplyr]{distinct}}
#' @examples
#' iris %>% distinct_dt()
#' iris %>% distinct_dt(Species)
#' iris %>% distinct_dt(Species,.keep_all = TRUE)
#' mtcars %>% distinct_dt(cyl,vs)
#' mtcars %>% distinct_dt(cyl,vs,.keep_all = TRUE)
#' mtcars %>% distinct_dt(cyl,vs,.keep_all = TRUE,fromLast = TRUE)
#'
#'
#' @export

distinct_dt = function(.data,...,.keep_all = FALSE,fromLast = FALSE){
  dt = as_dt(.data)
  sel_name = select_dt(dt[0],...) %>% names()
  if(.keep_all) unique(dt,by = sel_name,fromLast = fromLast)
  else unique(dt[,.SD,.SDcols = sel_name],fromLast = fromLast)
}






