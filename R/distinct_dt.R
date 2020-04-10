

#' @title Select distinct/unique rows in data.frame
#' @description Analogous function for \code{distinct} in \pkg{dplyr}
#' @param .data data.frame
#' @param ... Optional variables to use when determining uniqueness.
#'  If there are multiple rows for a given combination of inputs,
#'  only the first row will be preserved.
#'  If omitted, will use all variables.
#' @param .keep_all If \code{TRUE}, keep all variables in data.frame. If a combination of ... is not distinct,
#' this keeps the first row of values.
#' @return data.table
#' @seealso \code{\link[dplyr]{distinct}}
#' @examples
#' iris %>% distinct_dt()
#' iris %>% distinct_dt(Species)
#' iris %>% distinct_dt(Species,.keep_all = TRUE)
#' mtcars %>% distinct_dt(cyl,vs)
#' mtcars %>% distinct_dt(cyl,vs,.keep_all = TRUE)
#'
#' @export

distinct_dt = function(.data,...,.keep_all = FALSE){
  dt = as_dt(.data)
  sel_name = select_dt(dt[0],...) %>% names()
  if(.keep_all) unique(dt,by = sel_name)
  else unique(dt[,.SD,.SDcols = sel_name])
}

# distinct_dt = function(.data,...,.keep_all = FALSE){
#   dt = as_dt(.data)
#   if(length(substitute(...)) == 0) unique(dt)
#   else{
#     if(.keep_all) eval(substitute(dt[,.SD[1],by = .(...)]))
#     else eval(substitute(unique(dt[,.(...),])))
#   }
# }





