
#' @title Select column from data.frame
#' @description Select specific column(s) via various ways. One can select columns by their column names, indexes or regular expression recognizing the column name(s).
#' @param .data data.frame
#' @param ... List of variables or name-value pairs of summary/modifications
#'   functions. It can also recieve conditional function to select columns.
#'   When starts with `-`(minus symbol) or `!`, return the negative columns.
#' @param cols (Optional)A numeric or character vector.
#' @param negate Applicable when regular expression and "cols" is used.
#' If \code{TRUE}, return the non-matched pattern. Default uses \code{FALSE}.
#' @param rm.dup Should duplicated columns be removed? Defaults to \code{TRUE}.
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
#' iris %>% select_dt(-c("Sepal.Length","Sepal.Width"))
#' iris %>% select_dt(1)
#' iris %>% select_dt(-1)
#' iris %>% select_dt(1:3)
#' iris %>% select_dt(-(1:3))
#' iris %>% select_dt(1,3)
#' iris %>% select_dt("Pe")
#' iris %>% select_dt(-"Se")
#' iris %>% select_dt(!"Se")
#' iris %>% select_dt("Pe",negate = TRUE)
#' iris %>% select_dt("Pe|Sp")
#' iris %>% select_dt(cols = 2:3)
#' iris %>% select_dt(cols = 2:3,negate = TRUE)
#' iris %>% select_dt(cols = c("Sepal.Length","Sepal.Width"))
#' iris %>% select_dt(cols = names(iris)[2:3])
#'
#' iris %>% select_dt(is.factor)
#' iris %>% select_dt(-is.factor)
#' iris %>% select_dt(!is.factor)
#'
#' # select_mix could provide flexible mix selection
#' select_mix(iris, Species,"Sepal.Length")
#' select_mix(iris,1:2,is.factor)
#'
#' select_mix(iris,Sepal.Length,is.numeric)
#' # set rm.dup to FALSE could save the duplicated column names
#' select_mix(iris,Sepal.Length,is.numeric,rm.dup = FALSE)
#'


#' @rdname select
#' @export

select_dt = function(.data,...,cols = NULL,negate =FALSE){
  dt = as_dt(.data)
  if(is.null(cols)){
    substitute(list(...)) %>%
      deparse() %>% paste0() %>%
      str_extract("\\(.+\\)") %>%
      str_sub(2,-2)-> dot_string
    if(is.na(dot_string)) dt
    else if(str_detect(dot_string,"^[-,0-9 ]+$"))
      eval(parse(text = str_glue("dt[,c({dot_string})]")))
    else if(str_detect(dot_string,"^[-!]?\"")){
      if(dot_string %like% "^[-!]") {
        dot_string = str_remove(dot_string,"^-|^!")
        negate = TRUE
      }
      str_remove_all(dot_string,"\"") %>%
        str_subset(names(dt),.,negate = negate) %>%
        str_c(collapse = ",") -> dot_string
      eval(parse(text = str_glue("dt[,.({dot_string})]")))
    }
    else if(str_detect(dot_string,"^[-!]?c\\(")|str_count(dot_string,":") == 1)
      eval(parse(text = str_glue("dt[,{dot_string}]")))
    else if(dot_string %like% "^[-!]?is\\.")
      eval(parse(text = str_glue("select_if_dt(dt,{dot_string})")))
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
  else {
    if(!negate) dt[,.SD,.SDcols = cols]
    else eval(dt[, .SD,.SDcols = !cols])
  }
}


select_if_dt = function(dt,.if){
  if_name = substitute(.if) %>% deparse()
  if(str_detect(if_name,"^[-!]")){
    .if = str_remove(if_name,"[-!]")
    eval(parse(text = str_glue("sel_name = subset(sapply(dt,{.if}),
                        sapply(dt,{.if}) == FALSE) %>% names()")))
  } else
    sel_name = subset(sapply(dt,.if),sapply(dt,.if) == TRUE) %>% names()

  dt[,.SD, .SDcols = sel_name]
}

#' @rdname select
#' @export
select_mix = function(.data,...,rm.dup = TRUE){
  dt = as_dt(.data)

  substitute(list(...)) %>%
    lapply(deparse) %>%
    .[-1] %>%
    lapply(function(col) eval(parse(text = str_glue("select_dt(dt,{col})")))) %>%
    Reduce(f = cbind,x = .) -> res

  if(rm.dup) res = res[,unique(names(res)),with=FALSE]

  res

}



