
#' @title Use tibble for printing of data.frame
#' @description This function could let the user to choose whether they
#' would like the output data.table to be printed as the form of data.table
#' or tibble.
#' @param use Logical. Use tibble for printing or not? Default uses \code{FALSE}.
#' @details This function actually define or remove a function named as
#' \code{print.data.table} which let it return the printing of the tibble. One can
#'  also turn off this mode by \code{rm(print.data.table)}. Note that this procedure
#'  would not change the form of data.table, but just change the printing output.
#' @examples
#'
#' # while the printing form changes, the class of data never changes
#'
#' iris %>% count_dt(Species) -> a
#' class(a)
#'
#' print.data.table = show_tibble(TRUE)
#' a
#' class(a)
#'
#' print.data.table = show_tibble(FALSE)
#' a
#' class(a)



#' @export
show_tibble = function(use = FALSE){
  if(use){
    message("The tibble mode has been turned on.\n")
    function(x, ...) print(as_tibble(x), ...)
  }else {
    message("The tibble mode has been shut off.\n")
    NULL
  }
}

# show_tibble = function(use = FALSE){
#   if(use){
#     print.data.table <<- function(x, ...) {
#       print(as_tibble(x), ...)
#     }
#     message("The tibble mode has been turned on.\n")
#   }else {
#     print.data.table <<- NULL
#     message("The tibble mode has been shut off.\n")
#   }
# }
# globalVariables(c("<<-"))

