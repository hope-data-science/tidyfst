
#' @title Nice printing of report the Space Allocated for an Object
#' @description Provides an estimate of the memory that is being used to store an R object.
#' A wrapper of `object.size`, but use a nicer printing unit.
#' @param object an R object.
#' @return An object of class "object_size"
#' @examples
#'
#' iris %>% object_size()
#'

#' @export
object_size = function(object){
  object.size(object) %>% print(unit = "auto")
}
