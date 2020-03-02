
#' @title Data manipulation within groups
#' @description Analogous function for \code{group_by} in \pkg{dplyr},
#' but in another efficient way.
#' @param data A data.frame
#' @param by Variables to group by,unquoted name of grouping variable of list of unquoted names of grouping variables.
#' @param ... Any data manipulation arguments that could be implemented on a data.frame.
#' @return data.table
#' @examples
#' iris %>% group_dt(by = Species,slice_dt(1:2))
#' iris %>% group_dt(Species,filter_dt(Sepal.Length == max(Sepal.Length)))
#' iris %>% group_dt(Species,summarise_dt(new = max(Sepal.Length)))
#'
#' # you can pipe in the `group_dt`
#' iris %>% group_dt(Species,
#'                   mutate_dt(max= max(Sepal.Length)) %>%
#'                     summarise_dt(sum=sum(Sepal.Length)))
#'
#' # for users familiar with data.table, you can work on .SD directly
#' # following codes get the first and last row from each group
#' iris %>%
#'   group_dt(
#'     by = Species,
#'     rbind(.SD[1],.SD[.N])
#'   )
#'
#' #' # for summarise_dt, you can use "by" to calculate within the group
#' mtcars %>%
#'   summarise_dt(
#'    disp = mean(disp),
#'    hp = mean(hp),
#'    by = cyl
#' )
#'
#'   # but you could also, of course, use group_dt
#'  mtcars %>%
#'    group_dt(by =.(vs,am),
#'      summarise_dt(avg = mean(mpg)))
#'
#'   # and list of variables could also be used
#'  mtcars %>%
#'    group_dt(by =list(vs,am),
#'             summarise_dt(avg = mean(mpg)))



#' @export

group_dt = function(data,by = NULL,...){
  dt = as_dt(data)
  by = substitute(by)
  substitute(list(...)) %>%
    deparse() %>%
    str_c(collapse = "") %>%
    # str_squish() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2) -> dot_string
  deparse(by) -> by_deparse
  if(by_deparse == "NULL") stop("Please provide the group(s).")
  else if(!str_detect(by_deparse,"^\\.|^list\\("))
    by_deparse %>%
      str_c(".(",.,")") -> by_deparse

  dot_string %>%
    strsplit("%>%") %>%
    unlist() %>%
    str_squish() %>%
    lapply(dot_convert) %>%
    str_c("[,",.,",","by = {by_deparse}]") %>%
    str_c(collapse = "") %>%
    str_c("dt",.) -> to_eval

  eval(parse(text = str_glue(to_eval)))
}

# previous method, slow
# group_dt = function(data,by = NULL,...){
#   dt = as_dt(data)
#   by = substitute(by)
#   substitute(list(...)) %>%
#     deparse() %>%
#     str_c(collapse = "") %>%
#    # str_squish() %>%
#     str_extract("\\(.+\\)") %>%
#     str_sub(2,-2) -> dot_string
#   deparse(by) -> by_deparse
#   if(by_deparse == "NULL") stop("Please provide the group(s).")
#   else if(by_deparse %>% str_detect("^\\.|^list\\("))
#     eval(parse(text = str_glue("dt[,(.SD %>% {dot_string}),by = by]")))
#   else {
#     by_deparse %>%
#       str_c(".(",.,")") -> by
#     eval(parse(text = str_glue("dt[,(.SD %>% {dot_string}),by = {by}]")))
#   }
# }

dot_convert = function(string){
  if(str_detect(string,"\\.SD")) {}
  else if(str_detect(string,",\\s*\\.\\s*,"))
    str_replace(string,",\\s*\\.\\s*,",",.SD,") -> string
  else if(str_detect(string,",s*\\.s*\\)"))
    str_replace(string,",s*\\.s*\\)",",.SD\\)") -> string
  else str_replace(string,"\\(","\\(.SD,") -> string
  string
}



