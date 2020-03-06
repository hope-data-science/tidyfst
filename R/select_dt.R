
#' @title Select column from data.frame
#' @description Analogous function for \code{select} and \code{select_if} in \pkg{dplyr}.
#' @param data data.frame
#' @param ... List of variables or name-value pairs of summary/modifications
#'   functions.
#' @param cols (Optional)A numeric or character vector.
#' @param negate Applicable when regular expression is used.
#' If \code{TRUE}, return the non-matched pattern. Default uses \code{FALSE}.
#' @param .if Conditional function to select columns.
#' When starts with `-`(minus symbol), return the negative columns.
#' @return data.table
#' @seealso \code{\link[dplyr]{select}}, \code{\link[dplyr]{select_if}}
#' @examples
#' iris %>% select_dt(Species)
#' iris %>% select_dt(Sepal.Length,Sepal.Width)
#' iris %>% select_dt(Sepal.Length:Petal.Length)
#' iris %>% select_dt(-Sepal.Length)
#' iris %>% select_dt(-Sepal.Length,-Petal.Length)
#' iris %>% select_dt(-(Sepal.Length:Petal.Length))
#' iris %>% select_dt(c("Sepal.Length","Sepal.Width"))
#' iris %>% select_dt(1)
#' iris %>% select_dt(-1)
#' iris %>% select_dt(1:3)
#' iris %>% select_dt(-(1:3))
#' iris %>% select_dt(1,3)
#' iris %>% select_dt("Pe")
#' iris %>% select_dt("Pe",negate = TRUE)
#' iris %>% select_dt("Pe|Sp")
#' iris %>% select_dt(cols = 2:3)
#' iris %>% select_dt(cols = names(iris)[2:3])
#'
#' iris %>% select_if_dt(is.factor)
#' iris %>% select_if_dt(-is.factor)

#' @rdname select
#' @export

select_dt = function(data,...,cols = NULL,negate =FALSE){
  dt = as_dt(data)
  if(is.null(cols)){
    substitute(list(...)) %>%
      deparse() %>% paste0() %>%
      str_extract("\\(.+\\)") %>%
      str_sub(2,-2)-> dot_string
    if(is.na(dot_string)) dt
    else if(str_detect(dot_string,"^\"")){
      str_remove_all(dot_string,"\"") %>%
        str_subset(names(dt),.,negate = negate) %>%
        str_c(collapse = ",") -> dot_string
      eval(parse(text = str_glue("dt[,.({dot_string})]")))
    }
    else if(str_detect(dot_string,"[0-9]$")& str_detect(dot_string,"^-|^[0-9]"))
      eval(parse(text = str_glue("dt[,c({dot_string})]")))
    else if(str_detect(dot_string,"^c\\(")|str_count(dot_string,":") == 1)
      eval(parse(text = str_glue("dt[,{dot_string}]")))
    else if(str_detect(dot_string,"^-")){
      dot_string = str_remove_all(dot_string,"-") %>% str_squish()
      if(!str_detect(dot_string,","))
        eval(parse(text = str_glue("dt[,{dot_string} := NULL][]")))
      else{
        str_split(dot_string,",",simplify = TRUE) -> delete_names
        eval(parse(text = str_glue("dt[, {delete_names}:=NULL][]")))
      }
    }
    else eval(parse(text = str_glue("dt[,.({dot_string})]")))
  }
  else dt[,.SD,.SDcols = cols]
}


#' @rdname select
#' @export
select_if_dt = function(data,.if){
  dt = as_dt(data)
  if_name = substitute(.if) %>% deparse()
  if(str_detect(if_name,"^-")){
    .if = str_remove(if_name,"-")
    eval(parse(text = str_glue("sel_name = subset(sapply(dt,{.if}),
                        sapply(dt,{.if}) == FALSE) %>% names()")))
  } else
    sel_name = subset(sapply(dt,.if),sapply(dt,.if) == TRUE) %>% names()

  dt[,.SD, .SDcols = sel_name]
}


