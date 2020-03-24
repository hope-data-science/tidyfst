#' @title Fast operations of data.table by reference (I)
#' @description Combination of \code{set*} functions provided by \pkg{data.table}.
#'  This is memeroy efficient because no copy is made at all.
#' @param data A data.frame
#' @param col_order (Optional) Character vector of the new column name ordering.
#' May also be column numbers. This parameter will pass to "neworder" parameter
#' in \code{\link[data.table]{setcolorder}}.
#' @param order_by (Optional) A character vector of column names by which to order.
#' This parameter will pass to "cols" parameter in \code{\link[data.table]{setorder}}.
#' @param order_dirc (Optional) An integer vector with only possible values of 1 and -1,
#' corresponding to ascending and descending order. This parameter will pass to
#' "order" parameter in \code{\link[data.table]{setorder}}. Default uses 1.
#' @param old_name (Optional) When \code{new_name} is provided,
#' character names or numeric positions of column names to change.
#' This parameter will pass to "old" parameter in
#' \code{\link[data.table]{setnames}}.
#' @param new_name (Optional) It can be a function or the new column names.
#' This parameter will pass to "new" parameter in
#' \code{\link[data.table]{setnames}}.
#' @param fill_cols (Optional)
#' Numeric or character vector specifying columns to be updated.
#' @param fill_type (Optional)
#' Character, one of "down", "up" or "replace". Defaults to "down".
#' @param fill_value (Optional)
#' Numeric or integer, value to be used to fill when
#' \code{fill_type=="replace"}. Defaults to \code{NA}.
#' @return The input is modified by reference, and returned (invisibly)
#' so it can be used in compound statements.
#' @details The \code{set_dt()} will first set any data.frame to a data.table,
#' then rename, fill NAs, arrange row order, arrange column order. If you
#' want to do the operation in another order, use it separately in multiple
#' \code{set_dt} functions in the desired order.
#' @seealso \code{\link[data.table]{setcolorder}},
#' \code{\link[data.table]{setorder}}, \code{\link[data.table]{setnames}},
#' \code{\link[data.table]{setnafill}}
#' @seealso \code{\link[tidyfst]{set_in_dt}}
#' @examples
#'
#' # set_dt
#' x = 1:10
#' x[c(1:2, 5:6, 9:10)] = NA
#' dt = data.table(v1=x, v2=lag_dt(x)/2, v3=lead_dt(x, 1L)/2)
#' dt
#' set_dt(dt,new_name = c("A","B","C"),fill_cols = names(dt),
#'         order_by = "A",order_dirc = -1,col_order = c("B","A","C"))
#' dt
#'


#' @export
set_dt = function(data,
                  col_order = NULL,
                  order_by = NULL, order_dirc = 1L,
                  old_name = NULL,new_name = NULL,
                  fill_cols = NULL,fill_type = "down",fill_value = NA){
  setDT(data)

  #rename
  if(!is.null(new_name)){
    if(is.null(old_name)) old_name = names(data)
    setnames(data,old = old_name,new = new_name)
  }

  #fill
  if(!is.null(fill_cols)){
    if(fill_type == "down") fill_code = "locf"
    else if(fill_type == "up") fill_code = "nocb"
    else if(fill_type == "replace") fill_code = "const"
    else stop("Fill type unrecognized.")

    if(fill_code == "const")
      setnafill(data,cols = fill_cols,type = fill_code,fill = fill_value)
    else setnafill(data,cols = fill_cols,type = fill_code)
  }

  #row order
  if(!is.null(order_by)) setorderv(data,cols = order_by,order = order_dirc)

  #col order
  if(!is.null(col_order)) setcolorder(data,neworder = col_order)

}



