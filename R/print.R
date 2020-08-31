
#' @title Set global printing method for data.table
#' @description This function allow user to define how data.table is printed.
#' @param topn The number of rows to be printed from the beginning and
#'  end of tables with more than \code{nrow} rows.
#' @param nrows The number of rows which will be printed before truncation is enforced.
#' @param class If \code{TRUE}, the resulting output will include above each column its storage class (or a self-evident abbreviation thereof).
#' @param row.names If \code{TRUE}, row indices will be printed.
#' @param col.names One of three flavours for controlling the display of column names in output. \code{"auto"} includes column names above the data, as well as below the table if \code{nrow(x) > 20}. \code{"top"} excludes this lower register when applicable, and \code{"none"} suppresses column names altogether (as well as column classes if \code{class = TRUE}.
#' @param print.keys If \code{TRUE}, any \code{\link{key}} and/or \code{\link[=indices]{index}} currently assigned to \code{x} will be printed prior to the preview of the data.
#' @param trunc.cols  If \code{TRUE}, only the columns that can be printed in the console without wrapping the columns to new lines will be printed (similar to \code{tibbles}).
#' @seealso \code{\link[data.table]{print.data.table}}
#' @details Notice that \pkg{tidyfst} has a slightly different printing default for data.table,
#'  which is it always prints the keys and variable class (not like \pkg{data.table}).
#' @return None. This function is used for its side effect of changing options.
#' @examples
#'
#' iris %>% as.data.table()
#' print_options(topn = 3,trunc.cols = TRUE)
#' iris %>% as.data.table()
#'
#' # set all settings to default in tidyfst
#' print_options()
#' iris %>% as.data.table()
#'

#' @export
print_options = function(
  topn=5,
  nrows=100,
  class=TRUE,
  row.names=TRUE,
  col.names="auto",
  print.keys=TRUE,
  trunc.cols=FALSE
){
  options(
    "datatable.print.topn" = topn,
    "datatable.print.nrows" = nrows,
    "datatable.print.class" = class,
    "datatable.print.rownames" = row.names,
    "datatable.print.colnames" = col.names,
    "datatable.print.keys" = print.keys,
    "datatable.print.trunc.cols" = trunc.cols
  )
}

# default in data.able
# print_options = function(
#   topn=getOption("datatable.print.topn"),             # default: 5
#   nrows=getOption("datatable.print.nrows"),           # default: 100
#   class=getOption("datatable.print.class"),           # default: FALSE
#   row.names=getOption("datatable.print.rownames"),    # default: TRUE
#   col.names=getOption("datatable.print.colnames"),    # default: "auto"
#   print.keys=getOption("datatable.print.keys"),       # default: FALSE
#   trunc.cols=getOption("datatable.print.trunc.cols") # default: FALSE
# ){
#   options(
#     "datatable.print.topn" = topn,
#     "datatable.print.nrows" = nrows,
#     "datatable.print.class" = class,
#     "datatable.print.rownames" = row.names,
#     "datatable.print.colnames" = col.names,
#     "datatable.print.keys" = print.keys,
#     "datatable.print.trunc.cols" = trunc.cols
#   )
# }
