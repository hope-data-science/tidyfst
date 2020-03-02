
#' @title Short cut to data.table
#' @description To use facilities provided by \pkg{data.table}, but do not have to
#' load \pkg{data.table} package.
#' @param data A data.frame
#' @param ... Recieve \code{B} in data.table's \code{A[B]} syntax.
#' @details The \code{as_dt} could turn any data frame to data.table class. If the data is
#' not a data frame, return error.
#' @details  The \code{in_dt} function creates a virtual environment in data.table, it could be
#' piped well because it still follows the principals of \pkg{tidyfst}, which are: (1) Never
#' use in place replacement and (2) Always recieves a data frame (data.frame/tibble/data.table)
#' and returns a data.table. Therefore, the in place functions like \code{:=} will still
#' return the results.
#' @seealso \code{\link[data.table]{data.table}}
#' @examples
#' iris %>% as_dt()
#' iris %>% in_dt(order(-Sepal.Length),.SD[.N],by=Species)

#' @rdname dt
#' @export
in_dt = function(data,...){
  dt = as_dt(data)
  dt[...][]
}

#' @rdname dt
#' @export
as_dt = function(data){
  if(!is.data.frame(data)) stop("Only a data.frame could be received.")
  as.data.table(data)
}

