
#' @title Save a data.frame as a fst table
#' @description This function first export the data.frame to a temporal file,
#' and then parse it back as a fst table (class name is "fst_table").
#' @param .data A data.frame
#' @return An object of class \code{fst_table}
#' @examples
#'
#' \dontrun{
#'   iris %>%
#'     as_fst() -> iris_fst
#'   iris_fst
#' }

#' @export

as_fst = function(.data){
  if(!is.data.frame(.data))
    stop("Only a data.frame could be stored as fst table.")

  substitute(.data) %>%
    deparse() %>%
    tempfile(fileext = ".fst") -> fn
  export_fst(.data,path = fn)
  parse_fst(fn)
}
