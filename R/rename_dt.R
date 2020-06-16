
#' @title Rename column in data.frame
#' @description Analogous function for \code{rename} in \pkg{dplyr}
#' @param .data data.frame
#' @param ... statements of rename, e.g. `sl = Sepal.Length` means the column named
#' as "Sepal.Length" would be renamed to "sl"
#' @return data.table
#' @seealso \code{\link[dplyr]{rename}}
#' @examples
#' iris %>%
#'   rename_dt(sl = Sepal.Length,sw = Sepal.Width) %>%
#'   head()
#' iris %>% rename_with_dt(toupper)
#' iris %>% rename_with_dt(toupper,"^Pe")
#'
#' @rdname rename_dt
#' @export

rename_dt = function(.data,...){
  dt = as.data.table(.data)
  substitute(list(...)) %>%
    lapply(deparse) %>%
    .[-1] -> dot_string
  new_names = names(dot_string)
  old_names = as.character(dot_string)
  setnames(dt,old = old_names,new = new_names)[]
}

#' @rdname rename_dt
#' @export
rename_with_dt = function(.data,.fn,...){
  dt = as.data.table(.data)
  dt[0] %>% select_dt(...) %>% names() -> old_names
  .fn -> new_names
  setnames(dt,old = old_names,new = new_names)[]
}





