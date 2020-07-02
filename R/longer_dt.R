
#' @title Pivot data from wide to long
#' @description Turning a wide table to its longer form. It takes multiple columns and collapses into key-value pairs.
#' @param .data A data.frame
#' @param ... Pattern for unchanged group or unquoted names. Pattern can accept
#' regular expression to match column names. It can recieve what \code{select_dt}
#' recieves.
#' @param name Name for the measured variable names column.
#' The default name is 'name'.
#' @param value Name for the molten data values column(s).
#' The default name is 'value'.
#' @param na.rm If \code{TRUE}, \code{NA} values will be removed from the molten data.
#' @return A data.table
#' @seealso \code{\link[tidyfst]{wider_dt}},
#'   \code{\link[data.table]{melt}},
#'   \code{\link[tidyr]{pivot_longer}}
#' @examples
#'
#' ## Example 1:
#' stocks = data.frame(
#'   time = as.Date('2009-01-01') + 0:9,
#'   X = rnorm(10, 0, 1),
#'   Y = rnorm(10, 0, 2),
#'   Z = rnorm(10, 0, 4)
#' )
#'
#' stocks
#'
#' stocks %>%
#'   longer_dt(time)
#'
#' stocks %>%
#'   longer_dt("ti")
#'
#' # Example 2:
#'
#' \donttest{
#'   library(tidyr)
#'
#'   billboard %>%
#'     longer_dt(
#'       -"wk",
#'       name = "week",
#'       value = "rank",
#'       na.rm = TRUE
#'     )
#'
#'   # or use:
#'   billboard %>%
#'     longer_dt(
#'       artist,track,date.entered,
#'       name = "week",
#'       value = "rank",
#'       na.rm = TRUE
#'     )
#'
#'   # or use:
#'   billboard %>%
#'     longer_dt(
#'       1:3,
#'       name = "week",
#'       value = "rank",
#'       na.rm = TRUE
#'     )
#' }


#' @rdname longer
#' @export
longer_dt = function(.data,...,
                     name = "name",
                     value = "value",
                     na.rm = FALSE){
  dt = as_dt(.data)
  group = dt[0] %>% select_mix(...) %>% names()
  melt(data = dt,
       id = group,
       variable.name = name,
       value.name = value,
       na.rm = na.rm)
}




