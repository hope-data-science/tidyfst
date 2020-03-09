
#' @title Convenient print of time taken
#' @description Convenient printing of time elapsed. A wrapper of
#' \code{data.table::timetaken}, but showing the results more directly.
#' @param expr Valid R expression to be timed.
#' @return A character vector of the form HH:MM:SS,
#' or SS.MMMsec if under 60 seconds. See examples.
#' @seealso \code{\link[data.table]{timetaken}}, \code{\link[base]{system.time}}
#' @examples
#'
#' sys_time_print(Sys.sleep(1))
#'
#' a = iris
#' sys_time_print({
#'   res = iris %>%
#'     mutate_dt(one = 1)
#' })
#' res
#' @export

sys_time_print = function(expr){
  started.at=proc.time()
  eval(substitute(expr),envir = parent.frame())
  paste("Finished in",timetaken(started.at))
}




