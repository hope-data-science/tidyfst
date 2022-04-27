
#' @title Convenient print of time taken
#' @description Convenient printing of time elapsed. A wrapper of
#' \code{data.table::timetaken}, but showing the results more directly.
#' @param expr Valid R expression to be timed.
#' @param write_clip Logical. Whether copy the message to clipboard. Default uses \code{TRUE}.
#' @return  A character vector of the form HH:MM:SS,
#' or SS.MMMsec if under 60 seconds (invisibly for \code{show_time}). See examples.
#' @details \code{sys_time_print} and \code{show_time} work similarly, but \code{show_time}
#'  is considered more user-friendly because it copy the message to clipboard automatically,
#'  whereas \code{sys_time_print} only return a string.
#' @seealso \code{\link[data.table]{timetaken}}, \code{\link[base]{system.time}}
#' @examples
#'
#' sys_time_print(Sys.sleep(1))
#' show_time(Sys.sleep(1))
#'
#' a = iris
#' sys_time_print({
#'   res = iris %>%
#'     mutate_dt(one = 1)
#' })
#' res
#' @export
sys_time_print = function (expr) {
  started.at = proc.time()
  eval(substitute(expr), envir = parent.frame())
  paste("Finished in", timetaken(started.at))
}

#' @export
show_time = function(expr,write_clip = TRUE){
  started.at=proc.time()
  eval(substitute(expr),envir = parent.frame())
  time_message = paste("Finished in",timetaken(started.at))
  cat(paste0(time_message,"\n"))
  if(write_clip){
    message("Message above has copied to clipboard")
    writeClipboard(paste0("# ",time_message))
  }
  invisible(time_message)
}




