
#' @title Wise mutate or summarise with "all-at-if"
#' @description In \pkg{dplyr}, there are functions like \code{mutate_at},
#' \code{mutate_if} and \code{mutate_all}, as well as \code{summarise_at},
#' \code{summarise_if} and \code{summarise_all}. Here we provide a simple way
#' to do both in \code{all_dt},\code{at_dt} and \code{if_dt}.
#' @param data A data.frame
#' @param .func Main function name,either "mutate(_dt)" or "summarise(_dt)"
#' @param .funcs Function to be run within each column, should return a value or
#' vectors with same length.
#' @param ... Parameters to be passed to parameter *.funcs*.
#' @param .at Variables to select, could use regular expression or numeric/character
#' vector.
#' @param .if Conditional function to select columns.
#' When starts with `-`(minus symbol), return the negative columns.
#' @details Always return the columns with their original names after \code{mutate} or
#' \code{summarise}.
#' @return A data.table
#' @examples
#'
#' # all_
#' all_dt(iris[,-5],mutate_dt,scale)
#' all_dt(iris[,-5],mutate,scale)
#' all_dt(iris[,-5],summarise,max)
#' all_dt(iris[,-5],summarise,min)
#'
#' # at_
#' iris %>% at_dt("Se",mutate,scale)
#' iris %>% at_dt(1:3,mutate,scale)
#' iris %>% at_dt(c("Petal.Length"),mutate,scale,center = FALSE)
#'
#'  # if_
#'  iris %>%
#'    if_dt(is.double,mutate_dt,scale,center = FALSE)
#'   ## support minus symbol to select negative conditions
#'  iris %>%
#'    if_dt(-is.factor,mutate_dt,scale,center = FALSE)
#'  iris %>%
#'    if_dt(is.factor,mutate,as.character)
#'  iris %>%
#'    if_dt(is.numeric,summarise,max,na.rm = TRUE)

#' @rdname all_at_if
#' @export
all_dt = function(data,.func,.funcs,...){
  dt = as_dt(data)
  func = substitute(.func) %>% deparse()
  if(str_detect(func,"^mutate")) sapply(dt,.funcs,...) %>% as.data.table()
  else if(str_detect(func,"^summari")){
    dt[, lapply(.SD, .funcs, ...)]
  }
}


#' @rdname all_at_if
#' @export
at_dt = function(data,.at,.func,.funcs,...){
  dt = as_dt(data)
  if(is.character(.at) & length(.at) == 1)
    dt2 = dt[,.SD,.SDcols = str_subset(names(dt),.at)]
  else
    dt2 = dt[,.SD,.SDcols = .at]
  func = substitute(.func) %>% deparse()
  if(str_detect(func,"^mutate")){
    to_update = sapply(dt2,.funcs,...) %>% as.data.table()
    unchanged = setdiff(names(dt),names(dt2))
    dt %>%
      select_dt(cols = unchanged) %>%
      cbind(to_update) %>%
      select_dt(cols = names(dt))
  }
  else if(str_detect(func,"^summari")){
    dt2[, lapply(.SD, .funcs, ...)]
  }
}



#' @rdname all_at_if
#' @export
if_dt = function(data,.if,.func,.funcs,...){
  dt = as_dt(data)

  if_name = substitute(.if) %>% deparse()
  if(str_detect(if_name,"^-")){
    .if = str_remove(if_name,"-")
    eval(parse(text = str_glue("sel_name = subset(sapply(dt,{.if}),
                        sapply(dt,{.if}) == FALSE) %>% names()")))
  } else
    sel_name = subset(sapply(dt,.if),sapply(dt,.if) == TRUE) %>% names()
  dt2 = dt[,.SD, .SDcols = sel_name]

  func = substitute(.func) %>% deparse()
  if(str_detect(func,"^mutate")){
    to_update = sapply(dt2,.funcs,...) %>% as.data.table()
    unchanged = setdiff(names(dt),names(dt2))
    dt %>%
      select_dt(cols = unchanged) %>%
      cbind(to_update) %>%
      select_dt(cols = names(dt))
  }
  else if(str_detect(func,"^summari")){
    dt2[, lapply(.SD, .funcs, ...)]
  }
}






