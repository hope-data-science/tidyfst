
#' @title Impute missing values with mean, median or mode
#' @description Impute the columns of data.frame with its mean, median or mode.
#' @param .data A data.frame
#' @param ... Columns to select
#' @param .func Character, "mode" (default), "mean" or "median".
#' Could also define it by oneself.
#' @return A data.table
#' @examples
#'
#' Pclass <- c(3, 1, 3, 1, 3, 2, 2, 3, NA, NA)
#' Sex <- c('male', 'male', 'female', 'female', 'female',
#'          'female', NA, 'male', 'female', NA)
#' Age <- c(22, 38, 26, 35, NA,
#'          45, 25, 39, 28, 40)
#' SibSp <- c(0, 1, 3, 1, 2, 3, 2, 2, NA, 0)
#' Fare <- c(7.25, 71.3, 7.92, NA, 8.05, 8.46, 51.9, 60, 32, 15)
#' Embarked <- c('S', NA, 'S', 'Q', 'Q', 'S', 'C', 'S', 'C', 'S')
#' data <- data.frame('Pclass' = Pclass,
#'  'Sex' = Sex, 'Age' = Age, 'SibSp' = SibSp,
#'  'Fare' = Fare, 'Embarked' = Embarked)
#'
#' data
#' data %>% impute_dt() # defalut uses "mode" as `.func`
#' data %>% impute_dt(is.numeric,.func = "mean")
#' data %>% impute_dt(is.numeric,.func = "median")
#'
#' my_fun = function(x){
#'   x[is.na(x)] = (max(x,na.rm = TRUE) - min(x,na.rm = TRUE))/2
#'   x
#' }
#' data %>% impute_dt(is.numeric,.func = my_fun)
#'

#' @export

impute_dt = function(.data,...,.func = "mode"){

  dt = as.data.table(.data)
  if (substitute(list(...)) %>% deparse() == "list()")
    sel_cols = names(dt)
  else
    dt[0] %>% select_dt(...) %>% names() -> sel_cols

  if(!is.function(.func)){
    if(.func == "mode")
      dt[,(sel_cols):=lapply(.SD,
                             function(x){
                               uniqv = unique(x)
                               x_i = uniqv[which.max(tabulate(match(x, uniqv)))]
                               x[which(is.na(x))] = x_i
                               x
                             }),
         .SDcols = sel_cols][]
    else if(.func == "mean"){
      dt[,(sel_cols):=lapply(.SD,
                             function(x){
                               x_i = mean(x,na.rm = TRUE)
                               x[which(is.na(x))] = x_i
                               x
                             }),
         .SDcols = sel_cols][]
    }else if(.func == "median"){
      dt[,(sel_cols):=lapply(.SD,
                             function(x){
                               x_i = median(x,na.rm = TRUE)
                               x[which(is.na(x))] = x_i
                               x
                             }),
         .SDcols = sel_cols][]
    }
  }else dt[,(sel_cols):=lapply(.SD,.func),.SDcols = sel_cols][]
}







