
#' @title Pivot data from wide to long
#' @description Analogous function for \code{pivot_longer} in \pkg{tidyr}.
#' @param data A data.frame
#' @param ... Pattern for unchanged group or unquoted names. Pattern can accept
#' regular expression to match column names. If set `negate = TRUE`,
#' return non-matching columns.
#' @param gathered_name name for the measured variable names column.
#' The default name is 'variable'.
#' @param gathered_value name for the molten data values column(s).
#' The default name is 'value'.
#' @param group_to_keep Group to keep, namely vector of unchanged variables.
#' Can be integer (corresponding id column numbers) or
#' character (id column names) vector.
#' @param negate If \code{TRUE}, return non-matching elements.
#' @param na.rm If \code{TRUE}, \code{NA} values will be removed from the molten data.
#' @return A data.table
#' @seealso \code{\link[data.table]{melt}}
#' @seealso \code{\link[tidyr]{pivot_longer}}
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
#' \donttest{
#' library(tidyr)
#'
#' billboard %>%
#'   longer_dt(
#'     "wk",
#'     gathered_name = "week",
#'     gathered_value = "rank",
#'     na.rm = TRUE,negate = TRUE
#'   )
#'
#' # or use:
#'  billboard %>%
#'    longer_dt(
#'      artist,track,date.entered,
#'      gathered_name = "week",
#'      gathered_value = "rank",
#'      na.rm = TRUE,negate = TRUE
#'    )
#'
#'  # or use:
#'  billboard %>%
#'    longer_dt(
#'      group_to_keep = 1:3,
#'      gathered_name = "week",
#'      gathered_value = "rank",
#'      na.rm = TRUE,negate = TRUE
#'    )
#' }


#' @export
longer_dt = function(data,...,
                     gathered_name = "variable",
                     gathered_value = "value",
                     group_to_keep = NULL,negate = FALSE,
                     na.rm = FALSE){
  dt = as_dt(data)
  group = group_to_keep
  if(!is.null(group))
    melt(data = dt,
         id = group,
         variable.name = gathered_name,
         value.name = gathered_value,
         na.rm = na.rm)
  else{
    substitute(list(...)) %>%
      deparse() %>%
      str_extract("\\(.+\\)") %>%
      str_sub(2,-2)-> dot_string
    if(str_detect(dot_string,"^\"")){
      str_sub(dot_string,2,-2) %>%
        str_subset(names(dt),.,negate = negate)-> group
      melt(data = dt,
           id = group,
           variable.name = gathered_name,
           value.name = gathered_value,
           na.rm = na.rm)
    }else{
      dot_string %>%
        str_split(",",simplify = TRUE) %>%
        str_squish() -> group
      melt(data = dt,
           id = group,
           variable.name = gathered_name,
           value.name = gathered_value,
           na.rm = na.rm)
    }
  }
}


