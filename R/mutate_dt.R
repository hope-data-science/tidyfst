
#' @title Mutate columns in data.frame
#' @description Analogous function for \code{mutate} and \code{transmute} in \pkg{dplyr}.
#' @param .data data.frame
#' @param ... List of variables or name-value pairs of summary/modifications
#'   functions.
#' @param by (Optional) Mutate by what group?
#' @return data.table
#' @seealso \code{\link[dplyr]{mutate}}
#' @examples
#'
#' iris %>% mutate_dt(one = 1,Sepal.Length = Sepal.Length + 1)
#' iris %>% transmute_dt(one = 1,Sepal.Length = Sepal.Length + 1)
#' # add group number with symbol `.GRP`
#' iris %>% mutate_dt(id = 1:.N,grp = .GRP,by = Species)
#'
#' @rdname mutate
#' @export

mutate_dt = function(.data,...,by){
  #dt = as_dt(.data)
  dt = as.data.table(.data)
  substitute(dt[,`:=`(...),by][]) %>% eval()
}

#' @rdname mutate
#' @export

transmute_dt = function(.data,...,by){
  dt = as_dt(.data)

  substitute(dt[,.(...),by][]) %>% eval()
}




