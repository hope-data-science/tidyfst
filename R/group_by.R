
#' @title Group by variable(s) and implement operations
#' @description Using \code{setkey} and \code{setkeyv} in \pkg{data.table}
#' to carry out \code{group_by}-like functionalities in \pkg{dplyr}. This is
#' not only convenient but also efficient in computation.
#' @param .data A data frame
#' @param ... Variables to group by for \code{group_by_dt},
#'  namely the columns to sort by. Do not quote the column names.
#'  Any data manipulation arguments that could be
#'  implemented on a data.frame for \code{group_exe_dt}.
#'  It can receive what \code{select_dt} receives.
#' @param cols A character vector of column names to group by.
#' @return A data.table with keys
#' @details \code{group_by_dt} and \code{group_exe_dt} are a pair of functions
#' to be used in combination. It utilizes the feature of key setting in data.table,
#' which provides high performance for group operations, especially when you have
#' to operate by specific groups frequently.
#' @examples
#'
#' # aggregation after grouping using group_exe_dt
#' as.data.table(iris) -> a
#' a %>%
#'   group_by_dt(Species) %>%
#'   group_exe_dt(head(1))
#'
#' a %>%
#'   group_by_dt(Species) %>%
#'   group_exe_dt(
#'     head(3) %>%
#'       summarise_dt(sum = sum(Sepal.Length))
#'   )
#'
#' mtcars %>%
#'   group_by_dt("cyl|am") %>%
#'   group_exe_dt(
#'     summarise_dt(mpg_sum = sum(mpg))
#'   )
#' # equals to
#' mtcars %>%
#'   group_by_dt(cols = c("cyl","am")) %>%
#'   group_exe_dt(
#'     summarise_dt(mpg_sum = sum(mpg))
#'   )

#' @rdname group_by
#' @export

group_by_dt = function(.data,...,cols = NULL){
  #dt = as_dt(.data)
  .data = as.data.table(.data)

  if(!is.null(cols)) setkeyv(.data,cols)
  else {
    .data[0] %>% select_dt(...) %>% names() -> cols
    setkeyv(.data,cols)
  }

  .data
}

#' @rdname group_by
#' @export
group_exe_dt = function(.data,...){
  dt_keys = key(.data)
  if(is.null(dt_keys))
    stop("`group_exe_dt` must receive a data.table with key(s).")
  else
    dt_keys = str_c(dt_keys,collapse = ",") %>%
      str_c(".(",.,")")

  dt = as_dt(.data)
  eval(parse(text = str_glue("group_dt(.data = dt,by = {dt_keys},...)")))
}


