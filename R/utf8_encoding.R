

#' @title Use UTF-8 for character encoding in a data frame
#' @description \code{fread} from \pkg{data.table} could not recognize the encoding
#' and return the correct form, this could be unconvenient for text mining tasks. The
#' \code{utf8-encoding} could use "UTF-8" as the encoding to override the current
#' encoding of characters in a data frame.
#' @param .data A data.frame.
#' @return A data.table with characters in UTF-8 encoding

#' @export


utf8_encoding = function(.data){
  dt = as_dt(.data)
  mutate_vars(dt,is.character,str_conv,encoding = "UTF-8")
}
