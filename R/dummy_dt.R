
#' @title Fast creation of dummy variables
#' @description Quickly create dummy (binary) columns from character and factor type columns in the inputted data (and numeric columns if specified.)
#' This function is useful for statistical analysis when you want binary columns rather than character columns.
#' @param .data data.frame
#' @param ... Columns you want to create dummy variables from.
#' Very flexible, find in the examples.
#' @param longname logical. Should the output column labeled with the
#' original column name? Default uses \code{TRUE}.
#' @return data.table
#' @details If no columns provided, will return the original data frame.
#' @details This function is inspired by \pkg{fastDummies} package, but provides
#' simple and precise usage, whereas \code{fastDummies::dummy_cols} provides more
#' features for statistical usage.
#' @seealso \code{\link[fastDummies]{dummy_cols}}
#' @examples
#' iris %>% dummy_dt(Species)
#' iris %>% dummy_dt(Species,longname = FALSE)
#'
#' mtcars %>% head() %>% dummy_dt(vs,am)
#' mtcars %>% head() %>% dummy_dt("cyl|gear")

#' @export
dummy_dt = function(.data,...,longname = TRUE){
  # dt = as_dt(.data)
  dt = as.data.table(.data)
  if((substitute(list(...)) %>% deparse())=="list()")
    warning("No columns provided, return the orginal data.")
  else{
    dt[0] %>%
      select_dt(...) %>%
      names() -> col_names
    for(i in col_names){
      dummy_col(dt,i,longname = longname) -> dt
    }
  }
  dt
}

globalVariables("id_")

dummy_col = function(dt,col_name,longname){
  dt[, `:=`(one_=1,id_=1:.N) ]

  if(longname){
    dt[[col_name]] %>% unique() %>% as.character() -> old_names
    str_c(col_name,old_names,sep="_") -> new_names
    str_glue("dt=dcast(dt,...~{col_name},value.var = 'one_',fill = 0)") -> to_eval
    eval(parse(text = to_eval))
    setnames(dt,old_names,new_names)
  }else{
    str_glue("dt=dcast(dt,...~{col_name},value.var = 'one_',fill = 0)") -> to_eval
    eval(parse(text = to_eval))
  }
  dt[,id_:=NULL][]
}





