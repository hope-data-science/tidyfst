
#' @title Add percentage to counts in data.frame
#' @description Add percentage for counts in the data.frame, both numeric and
#'  character with `%` would be provided.
#' @param x A number (numeric).
#' @param digits How many digits to keep in the percentage. Default uses 1.
#' @param .data A data frame.
#' @param count_name Column name of counts (Character).
#'  Default uses the last column of data.frame.
#' @references https://stackoverflow.com/questions/7145826/how-to-format-a-number-as-percentage-in-r
#' @examples
#'
#'  percent(0.9057)
#'  percent(0.9057,3)
#'
#'  iris %>%
#'    count_dt(Species) %>%
#'    add_prop()
#'
#'  iris %>%
#'    count_dt(Species) %>%
#'    add_prop(count_name = "n",digits = 2)
#'

#' @rdname add_prop
#' @export
percent = function(x,digits = 1){
  sprintf(paste0("%.",digits,"f%%"),x * 100)
}

#' @rdname add_prop
#' @export
add_prop = function(.data,count_name = last(names(.data)),digits = 1){
  dt = as.data.table(.data)
  dt[,prop:=dt[[count_name]]/sum(dt[[count_name]])][,
    prop_label:= percent(prop,digits = digits)
  ][]
}

globalVariables(c("prop","prop_label"))

