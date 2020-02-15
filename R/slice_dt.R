
#' @title Slice rows in data.frame
#' @description Analogous function for \code{slice} in \pkg{dplyr}
#' @param data data.frame
#' @param ... Integer row values.
#' @return data.table
#' @seealso \code{\link[dplyr]{slice}}
#' @examples
#' iris %>% slice_dt(1:3)
#' iris %>% slice_dt(1,3)
#' iris %>% slice_dt(c(1,3))
#' @export

slice_dt = function(data,...){
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2)-> dot_string
  if(str_detect(dot_string,"^[0-9]") &
     str_detect(dot_string,"[0-9]$") &
     str_detect(dot_string,","))
    eval(parse(text = str_glue("dt[c({dot_string})]")))
  else eval(parse(text = str_glue("dt[{dot_string}]")))
}


