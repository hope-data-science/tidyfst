
#' @title Separate a character column into two columns using
#' a regular expression separator
#' @description Given either regular expression,
#' \code{separate_dt()} turns a single character column into two columns.
#' Analogous to \code{tidyr::separate}, but only split into two columns only.
#' @param .data A data frame.
#' @param separated_colname Column name, string only.
#' @param into Character vector of length 2.
#' @param sep Separator between columns.
#' @param remove If \code{TRUE}, remove input column from output data frame.
#' @seealso \code{\link[tidyr]{separate}}, \code{\link[tidyfst]{unite_dt}}
#' @examples
#' df <- data.frame(x = c(NA, "a.b", "a.d", "b.c"))
#' df %>% separate_dt(x, c("A", "B"))
#' # equals to
#' df %>% separate_dt("x", c("A", "B"))
#'
#' # If you just want the second variable:
#' df %>% separate_dt(x,into = c(NA,"B"))

#' @export
separate_dt = function(.data,separated_colname,into,
                       sep = "[^[:alnum:]]+",
                       remove = TRUE){
  dt = as.data.table(.data)
  substitute(separated_colname) %>% deparse() -> parse_name
  if(!str_detect(parse_name,"^\"")) separated_colname = parse_name

  if(anyNA(into)) into[is.na(into)] = "NA_COL_"

  dt[[separated_colname]] %>%
    tstrsplit(split = sep) %>%
    setDT() %>%
    setnames(names(.),into) %>%
    select_dt(-"NA_COL_")-> split_columns
  if(remove)
    dt[,(separated_colname):=NULL][,names(split_columns):=split_columns][]
  else dt[,names(split_columns):=split_columns][]

}


# separate_dt = function(.data,separated_colname,into,
#                     sep = "[^[:alnum:]]+",
#                     remove = TRUE){
#   dt = as.data.table(.data)
#   substitute(separated_colname) %>% deparse() -> parse_name
#   if(!str_detect(parse_name,"^\"")) separated_colname = parse_name
#
#   dt[[separated_colname]] %>%
#     tstrsplit(split = sep) %>%
#     setDT() %>%
#     setnames(names(.),into) -> split_columns
#   if(remove)
#     dt[,(separated_colname):=NULL][,names(split_columns):=split_columns][]
#   else dt[,names(split_columns):=split_columns][]
#
# }













