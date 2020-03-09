
#' @title Dump, replace and fill missing values in data.frame
#' @description Analogous function for \code{drop_na}, \code{replace_na} and
#' \code{fill} in \pkg{tidyr}, but with a different API.
#'
#' @param data data.frame
#' @param ... Colunms to be replaced or filled. If not specified, use all columns.
#' @param to What value should NA replace by?
#' @param direction Direction in which to fill missing values.
#' Currently either "down" (the default) or "up".
#' @return data.table
#' @details \code{drop_all_na_cols} could drop the columns with only NAs,
#' while \code{drop_all_na_rows} could drop the rows with only NAs.
#' @references https://stackoverflow.com/questions/2643939/remove-columns-from-dataframe-where-all-values-are-na
#' @references https://stackoverflow.com/questions/7235657/fastest-way-to-replace-nas-in-a-large-data-table
#' @seealso \code{\link[tidyr]{drop_na}},\code{\link[tidyr]{replace_na}},
#' \code{\link[tidyr]{fill}}
#' @examples
#' df <- data.table(x = c(1, 2, NA), y = c("a", NA, "b"))
#'  df %>% drop_na_dt()
#'  df %>% drop_na_dt(x)
#'  df %>% drop_na_dt(y)
#'  df %>% drop_na_dt(x,y)
#'
#'  df %>% replace_na_dt(to = 0)
#'  df %>% replace_na_dt(x,to = 0)
#'  df %>% replace_na_dt(y,to = 0)
#'  df %>% replace_na_dt(x,y,to = 0)
#'
#'  df %>% fill_na_dt(x)
#'  df %>% fill_na_dt() # not specified, fill all columns
#'  df %>% fill_na_dt(y,direction = "up")

#' @rdname missing
#' @export
drop_na_dt = function(data,...){
  data = as_dt(data)
  if(substitute(list(...)) %>% deparse() == "list()")
    dot_string <- NULL
  else
    data %>%
      select_dt(...) %>%
      names() -> dot_string
  if(is.null(dot_string)) na.omit(data)
  else {
    index = str_glue("!is.na({dot_string})") %>% paste0(collapse = " & ")
    eval(parse(text = str_glue("data[{index}]")))
  }
}

#' @rdname missing
#' @export
drop_all_na_cols = function(data){
  dt = as_dt(data)
  dt[,which(unlist(lapply(dt, function(x)!all(is.na(x))))),with=F]
}

drop_all_na_rows = function(data){
  dt = as_dt(data)
  dt[complete.cases(dt)]
}

#' @rdname missing
#' @export

# https://stackoverflow.com/questions/7235657/fastest-way-to-replace-nas-in-a-large-data-table
replace_na_dt = function(data,...,to){
  data = as_dt(data)
  if(substitute(list(...)) %>% deparse() == "list()")
    dot_string <- NULL
  else
    data %>%
      select_dt(...) %>%
      names() -> dot_string
  if(is.null(dot_string)) {
    for (j in seq_len(ncol(data)))
      set(data,which(is.na(data[[j]])),j,to)
  } else{
    for (j in dot_string)
      set(data,which(is.na(data[[j]])),j,to)
  }
  data
}

#' @rdname missing
#' @export
fill_na_dt = function(data,...,direction = c("down","up")){
  dt = as_dt(data)
  if(substitute(list(...)) %>% deparse() == "list()")
    update_cols <- names(dt)
  else
    dt[0] %>%
      select_dt(...) %>%
      names() -> update_cols
  dt[,(update_cols) := lapply(.SD, get(paste0(direction,"_fill"))),
                                .SDcols = update_cols][]

}


down_fill = function(x){
  for(i in seq_along(x)){
    if(!is.na(x[i]) | i == 1) next
    else if(is.na(x[i]) & is.na(x[i-1])) next
    else x[i] <- x[i-1]
  }
  x
}

up_fill = function(x){
  rev(x) %>%
    down_fill() %>%
    rev()
}








