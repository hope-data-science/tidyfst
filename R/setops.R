
#' @title Set operations for data frames
#' @description Wrappers of set operations in \pkg{data.table}.
#' Only difference is it could be applied to non-data.table data frames by
#' recognizing and coercing them to data.table automatically.
#' @param x A data.frame
#' @param y A data.frame
#' @param all Logical. When \code{FALSE} (default),
#'  removes duplicate rows on the result.
#' @return A data.table
#' @seealso \code{\link[data.table]{setops}}
#' @examples
#'
#' x = iris[c(2,3,3,4),]
#' x2 = iris[2:4,]
#' y = iris[c(3:5),]
#'
#' intersect_dt(x, y)            # intersect
#' intersect_dt(x, y, all=TRUE)  # intersect all
#' setdiff_dt(x, y)              # except
#' setdiff_dt(x, y, all=TRUE)    # except all
#' union_dt(x, y)                # union
#' union_dt(x, y, all=TRUE)      # union all
#' setequal_dt(x, x2, all=FALSE) # setequal
#' setequal_dt(x, x2)            # setequal all
#'

#' @rdname setops
#' @export

intersect_dt = function(x,y,all = FALSE){
  x = as_dt(x)
  y = as_dt(y)
  fintersect(x,y,all)
}

#' @rdname setops
#' @export

union_dt = function(x,y,all = FALSE){
  x = as_dt(x)
  y = as_dt(y)
  funion(x,y,all)
}

#' @rdname setops
#' @export

setdiff_dt = function(x,y,all = FALSE){
  x = as_dt(x)
  y = as_dt(y)
  fsetdiff(x,y,all)
}

#' @rdname setops
#' @export

setequal_dt = function(x,y,all = TRUE){
  x = as_dt(x)
  y = as_dt(y)
  fsetequal(x,y,all)
}
