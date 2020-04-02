
#' @title Dump, replace and fill missing values in data.frame
#' @description Analogous function for \code{drop_na}, \code{replace_na} and
#' \code{fill} in \pkg{tidyr}, but with a different API.
#'
#' @param .data data.frame
#' @param ... Colunms to be replaced or filled. If not specified, use all columns.
#' @param prop If proportion of NAs is larger than or equal to "prop", would be deleted.
#' @param n If number of NAs is larger than or equal to "n", would be deleted.
#' @param to What value should NA replace by?
#' @param direction Direction in which to fill missing values.
#' Currently either "down" (the default) or "up".
#' @param x A vector with missing values to be filled.
#' @return data.table
#' @details \code{drop_na_dt} drops the entries with NAs in specific columns.
#' \code{fill_na_dt} fill NAs with observations ahead ("down") or below ("up"),
#' which is also known as last observation carried forward (LOCF) and
#' next observation carried backward(NOCB).
#' @details \code{delete_na_cols} could drop the columns with NA proportion larger
#' than or equal to "prop" or NA number larger than or equal to "n",
#' \code{delete_na_rows} works alike but deals with rows.
#' @details \code{shift_fill} could fill a vector with missing values.
#' @references https://stackoverflow.com/questions/23597140/how-to-find-the-percentage-of-nas-in-a-data-frame
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
#'
#' x = data.frame(x = c(1, 2, NA, 3), y = c(NA, NA, 4, 5),z = rep(NA,4))
#' x
#' x %>% delete_na_cols()
#' x %>% delete_na_cols(prop = 0.75)
#' x %>% delete_na_cols(prop = 0.5)
#' x %>% delete_na_cols(prop = 0.24)
#' x %>% delete_na_cols(n = 2)
#'
#' x %>% delete_na_rows(prop = 0.6)
#' x %>% delete_na_rows(n = 2)
#'
#' # shift_fill
#' y = c("a",NA,"b",NA,"c")
#'
#' shift_fill(y) # equals to
#' shift_fill(y,"down")
#'
#' shift_fill(y,"up")

#' @rdname missing
#' @export
drop_na_dt = function(.data,...){
  dt = as_dt(.data)
  if(substitute(list(...)) %>% deparse() == "list()")
    dot_string <- NULL
  else
    dt[0] %>%
      select_dt(...) %>%
      names() -> dot_string
  if(is.null(dot_string)) na.omit(dt)
  else {
    index = str_glue("!is.na({dot_string})") %>% paste0(collapse = " & ")
    eval(parse(text = str_glue("dt[{index}]")))
  }
}

#' @rdname missing
#' @export

replace_na_dt = function(.data,...,to){
  if(is.na(to)) return(.data)
  dt = as_dt(.data)
  if(substitute(list(...)) %>% deparse() == "list()")
    dot_string <- NULL
  else
    dt[0] %>%
      select_dt(...) %>%
      names() -> dot_string
  if(is.null(dot_string)) {
    for (j in seq_len(ncol(dt)))
      set(dt,which(is.na(dt[[j]])),j,to)
  } else{
    for (j in dot_string)
      set(dt,which(is.na(dt[[j]])),j,to)
  }
  dt
}


#' @rdname missing
#' @export

delete_na_cols = function(.data,prop = NULL, n = NULL){
  dt = as_dt(.data)

  if(is.numeric(prop) && prop > 1) {
    n = prop
    prop = NULL
  }
  if(is.null(prop) & !is.null(n)) prop = n/nrow(dt)
  if(is.null(prop)) prop = 1
  if(prop %between% c(0,1)){
    colMeans(is.na(dt)) %>%
      subset(subset = .< prop) %>%
      names() -> to_save

    select_dt(dt,cols = to_save)
  }
  else stop("Inputs are invalid.")
}


#' @rdname missing
#' @export
delete_na_rows = function(.data,prop = NULL, n = NULL){
  dt = as_dt(.data)

  if(is.numeric(prop) && prop > 1) {
    n = prop
    prop = NULL
  }
  if(is.null(prop) & !is.null(n)) prop = n/nrow(dt)
  if(is.null(prop)) prop = 1
  if(prop %between% c(0,1)){
    which(rowMeans(is.na(dt)) < prop) -> to_save

    dt[to_save]
  }
  else stop("Inputs are invalid.")
}


#' @rdname missing
#' @export

fill_na_dt = function(.data,...,direction = "down"){
  dt = as_dt(.data)
  if(substitute(list(...)) %>% deparse() == "list()")
    update_cols <- names(dt)
  else
    dt[0] %>%
      select_dt(...) %>%
      names() -> update_cols

  dt[0] %>% select_dt(cols = update_cols) %>%
    select_dt(is.numeric) %>%
    names()-> num_cols
  setdiff(update_cols,num_cols) -> nnum_cols

  if(length(num_cols) > 0) {
    if(direction == "down") setnafill(dt,type = "locf",cols = num_cols)
    else if(direction == "up") setnafill(dt,type = "nocb",cols = num_cols)
  }
  if(length(nnum_cols) > 0){
    dt[,(nnum_cols) := lapply(.SD, shift_fill,direction = direction),
       .SDcols = nnum_cols]
  }

  dt[]
}

#' @rdname missing
#' @export
shift_fill = function(x,direction = "down"){
  if(direction == "down") type = "lag"
  else if(direction == "up") type = "lead"
  repeat{
    x = fcoalesce(x,shift(x,type = type))
    if(!anyNA(x)) break
  }
  x
}



