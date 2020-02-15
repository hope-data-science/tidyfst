
#' @title Data manipulation within groups
#' @description Analogous function for \code{group_by} in \pkg{dplyr},
#' but in another efficient way.
#' @param data data.frame
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
#' # for summarise_dt, you can use "by" to calculate within the group
#' mtcars %>%
#'   summarise_dt(
#'    disp = mean(disp),
#'    hp = mean(hp),
#'    by = cyl
#' )
#'
#'  # but you could also, of course, use group_dt
#' mtcars %>%
#'   group_dt(by =.(vs,am),
#'     summarise_dt(avg = mean(mpg)))
#'

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
  if(deparse(by) == "NULL") stop("Please provide the group(s).")
  else if(by %>% deparse() %>% str_detect("^\\."))
    eval(parse(text = str_glue("dt[,(.SD %>% {dot_string}),by = by]")))
  else {
    by %>%
      deparse() %>%
      str_c(".(",.,")") -> by
    eval(parse(text = str_glue("dt[,(.SD %>% {dot_string}),by = {by}]")))
  }
}


## general
as_dt = function(data){
  if(!is.data.frame(data)) stop("Only a data.frame could be received.")
  as.data.table(data)
}

