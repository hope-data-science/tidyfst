
#' @title Complete a data frame with missing combinations of data
#' @description Turns implicit missing values into explicit missing values.
#' Analogous function for \code{complete} function in \pkg{tidyr}.
#' @param .data data.frame
#' @param ... Specification of columns to expand.The selection of columns is
#' supported by the flexible \code{\link[tidyfst]{select_dt}}.
#' To find all unique combinations of provided columns, including those not found in the data,
#' supply each variable as a separate argument. But the two modes (select the
#' needed columns and fill outside values) could not be mixed,
#' find more details in examples.
#' @param fill Atomic value to fill into the missing cell, default uses \code{NA}.
#' @details When the provided columns with addtion data are of different length,
#' all the unique combinations would be returned. This operation should be used
#' only on unique entries, and it will always returned the unique entries.
#' @details If you supply fill parameter, these values will also replace existing explicit missing values in the data set.
#' @seealso \code{\link[tidyr]{complete}}
#' @return data.table
#' @examples
#' df <- data.table(
#'   group = c(1:2, 1),
#'   item_id = c(1:2, 2),
#'   item_name = c("a", "b", "b"),
#'   value1 = 1:3,
#'   value2 = 4:6
#' )
#'
#' df %>% complete_dt(item_id,item_name)
#' df %>% complete_dt(item_id,item_name,fill = 0)
#' df %>% complete_dt("item")
#' df %>% complete_dt(item_id=1:3)
#' df %>% complete_dt(item_id=1:3,group=1:2)
#' df %>% complete_dt(item_id=1:3,group=1:3,item_name=c("a","b","c"))
#'

#' @export

complete_dt = function(.data,...,fill = NA){
  dt = as_dt(.data)

  if(
    substitute(list(...)) %>%
    deparse() %>%
    .[1] %>%
    str_detect("=")
  ) {
    list(...) %>%
      lapply(unique) %>%
      deparse() %>%
      str_replace("list","CJ") %>%
      parse(text = .) %>%
      eval() %>%
      merge(dt,all = TRUE) %>%
      #merge(setorder(dt),all = TRUE) %>%
      replace_na_dt(to=fill) %>%
      unique()
  }else
    dt %>%
    #setorder(dt)%>%
    select_dt(...) %>%
    lapply(unique) %>%
    deparse() %>%
    str_replace("list","CJ") %>%
    parse(text = .) %>%
    eval() %>%
    merge(dt,all = TRUE) %>%
    replace_na_dt(to=fill) %>%
    unique()
}


