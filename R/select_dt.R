
#' @title Select column from data.frame
#' @description Analogous function for \code{select} in \pkg{dplyr}.
#' @param data data.frame
#' @param ... List of variables or name-value pairs of summary/modifications
#'   functions.
#' @param cols (Optional)A numeric or character vector.
#' @param negate Applicable when regular expression is used.
#' If \code{TRUE}, return the non-matched pattern. Default uses \code{FALSE}.
#' @return data.table
#' @seealso \code{\link[dplyr]{select}}
#' @examples
#' iris %>% select_dt(Species)
#' iris %>% select_dt(Sepal.Length,Sepal.Width)
#' iris %>% select_dt(c("Sepal.Length","Sepal.Width"))
#' iris %>% select_dt(1:3)
#' iris %>% select_dt(1,3)
#' iris %>% select_dt("Pe")
#' iris %>% select_dt("Pe",negate = TRUE)
#' iris %>% select_dt("Pe|Sp")
#' iris %>% select_dt(cols = 2:3)
#' iris %>% select_dt(cols = names(iris)[2:3])

#' @export
select_dt = function(data,...,cols = NULL,negate =FALSE){
  dt = as_dt(data)
  if(is.null(cols)){
    substitute(list(...)) %>%
      deparse() %>%
      str_extract("\\(.+\\)") %>%
      str_sub(2,-2)-> dot_string
    if(str_detect(dot_string,"^\"")){
      str_remove_all(dot_string,"\"") %>%
        str_subset(names(dt),.,negate = negate) %>%
        str_c(collapse = ",") -> dot_string
      eval(parse(text = str_glue("dt[,.({dot_string})]")))
    }
    else if(str_detect(dot_string,"^[0-9]"))
      eval(parse(text = str_glue("dt[,c({dot_string})]")))
    else if(str_detect(dot_string,"^c\\("))
      eval(parse(text = str_glue("dt[,{dot_string}]")))
    else eval(parse(text = str_glue("dt[,.({dot_string})]")))
  }
  else dt[,.SD,.SDcols = cols]
}




