
#' @title Dump or replace missing values in data.frame
#' @description Analogous function for \code{drop_na} and \code{replace_na} in \pkg{tidyr}, but with a different API.
#'
#' @param data data.frame
#' @param ... Colunms to be replaced. If not specified, use all columns.
#' @param to What value should NA replace by?
#' @return data.table
#' @references https://stackoverflow.com/questions/7235657/fastest-way-to-replace-nas-in-a-large-data-table
#' @seealso \code{\link[tidyr]{drop_na}},\code{\link[tidyr]{replace_na}}
#' @examples
#' df <- data.table(x = c(1, 2, NA), y = c("a", NA, "b"))
#' df %>% drop_na_dt()
#' df %>% drop_na_dt(x)
#'
#' df %>% replace_na_dt(to = 0)
#' df %>% replace_na_dt(x,to = 0)
#' df %>% replace_na_dt(y,to = 0)

#' @rdname missing
#' @export
drop_na_dt = function(data,...){
  data = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("(?<=\\().+?(?=\\))") %>%
    strsplit(",") %>%
    unlist() -> dot_string
  if(is.na(dot_string)) na.omit(data)
  else {
    index = str_glue("!is.na({dot_string})") %>% paste0(collapse = " & ")
    eval(parse(text = str_glue("data[{index}]")))
  }
}

#' @rdname missing
#' @export

# https://stackoverflow.com/questions/7235657/fastest-way-to-replace-nas-in-a-large-data-table
replace_na_dt = function(data,...,to){
  data = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("(?<=\\().+?(?=\\))") %>%
    strsplit(",") %>%
    unlist() -> dot_string
  if(is.na(dot_string)) {
    for (j in seq_len(ncol(data)))
      set(data,which(is.na(data[[j]])),j,to)
  } else{
    for (j in dot_string)
      set(data,which(is.na(data[[j]])),j,to)
  }
  data
}










