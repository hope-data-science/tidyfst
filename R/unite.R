
#' @title Unite multiple columns into one by pasting strings together
#' @description Convenience function to paste together multiple columns into one.
#' Analogous to \code{tidyr::unite}.
#' @param data A data frame.
#' @param united_colname The name of the new column, string only.
#' @param ... A selection of columns. If want to select all columns,
#' pass "" to the parameter. See example.
#' @param remove If \code{TRUE}, remove input columns from output data frame.
#' @param na.rm If \code{TRUE}, missing values would be merged into \code{NA},
#' otherwise \code{NA} is treated as character "NA". This is different from
#' \pkg{tidyr}.
#' @seealso \code{\link[tidyr]{unite}},\code{\link[tidyfst]{separate_dt}}
#' @examples
#' df <- expand.grid(x = c("a", NA), y = c("b", NA))
#' df
#'
#' # Treat missing value as character "NA"
#' df %>% unite_dt("z", x:y, remove = FALSE)
#' # Treat missing value as NA
#' df %>% unite_dt("z", x:y, na.rm = TRUE, remove = FALSE)
#' df %>%
#'   unite_dt("xy", x:y)
#'
#' # Select all columns
#' iris %>% unite_dt("merged_name","")

#' @export
unite_dt = function(data,united_colname,...,
                    sep = "_",remove = TRUE,
                    na.rm = FALSE){
  dt = as_dt(data)

  dt %>%
    select_dt(...) -> selected_cols
  paste_fun = ifelse(na.rm,str_c,paste)
  Reduce(function(x,y) paste_fun(x,y,sep = sep),selected_cols) -> new_col

  if(!remove) dt[,c(united_colname):=new_col][]
  else
    dt[,.SD,.SDcols = names(selected_cols)][,c(united_colname):=new_col][]

}







