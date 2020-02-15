
#' @title Conditional update of columns in data.table
#' @description Integrate \code{mutate} and \code{case_when} in \pkg{dplyr} and make
#' a new tidy verb for data.table.
#' @param data data.frame
#' @param ... the first argument (contents before the first comma) should be the condition,
#' other should be equation(s) just like `mutate_dt`.
#' @return data.table
#' @seealso \code{\link[dplyr]{case_when}}
#' @examples
#' iris[3:8,]
#' iris[3:8,] %>%
#'   mutate_when(Petal.Width == .2,
#'               one = 1,Sepal.Length=2)
#' @export


mutate_when = function(data,...){
  dt = as_dt(data)
  dot_string <- substitute(list(...)) %>% deparse() %>% str_extract("(?<=\\().+?(?=\\))") %>%
    strsplit(",") %>% unlist()
  when = dot_string[1]
  what = dot_string[-1] %>% paste0(collapse = ",")
  eval(parse(text = str_glue(" dt[{when},`:=`({what})][]")))
}


