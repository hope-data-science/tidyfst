

#' @title Select distinct/unique rows in data.frame
#' @description Analogous function for \code{distinct} in \pkg{dplyr}
#' @param data data.frame
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



distinct_dt = function(data,...,.keep_all = FALSE){
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_c(".",.)-> dot_string
  if(is.na(dot_string)) unique(dt)
  else{
    if(!.keep_all)
      dt %>% select_dt(...) %>% unique()
    else eval(parse(text = str_glue("dt[,.SD[1],by = {dot_string}]")))
  }
}







