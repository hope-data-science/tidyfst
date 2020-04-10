
#' @title Parse,inspect and extract data.table from fst file
#' @name fst
#' @description An API for reading fst file as data.table.
#' @param path path to fst file
#' @param ft An object of class fst_table, returned by \code{parse_fst}
#' @param row_no An integer vector (Positive)
#' @param ... The filter conditions
#' @return \code{parse_fst} returns a fst_table class.
#' @return \code{select_fst} and \code{filter_fst} returns a data.table.
#' @details \code{summary_fst} could provide some basic information about
#' the fst table.
#' @seealso \code{\link[fst]{fst}}, \code{\link[fst]{metadata_fst}}
#' @examples
#'
#' \dontrun{
#'   fst::write_fst(iris,"iris_test.fst")
#'   # parse the file but not reading it
#'   parse_fst("iris_test.fst") -> ft
#'   ft
#'
#'   class(ft)
#'   lapply(ft,class)
#'   names(ft)
#'   dim(ft)
#'   summary_fst(ft)
#'
#'   # get the data by query
#'   ft %>% slice_fst(1:3)
#'   ft %>% slice_fst(c(1,3))
#'
#'   ft %>% select_fst(Sepal.Length)
#'   ft %>% select_fst(Sepal.Length,Sepal.Width)
#'   ft %>% select_fst("Sepal.Length")
#'   ft %>% select_fst(1:3)
#'   ft %>% select_fst(1,3)
#'   ft %>% select_fst("Se")
#'   ft %>% select_fst("nothing")
#'   ft %>% select_fst("Se|Sp")
#'   ft %>% select_fst(cols = names(iris)[2:3])
#'
#'   ft %>% filter_fst(Sepal.Width > 3)
#'   ft %>% filter_fst(Sepal.Length > 6 , Species == "virginica")
#'   ft %>% filter_fst(Sepal.Length > 6 & Species == "virginica" & Sepal.Width < 3)
#'
#'   unlink("iris_test.fst")
#' }


globalVariables(c("."))

#' @rdname fst
#' @export
parse_fst = function(path){
  fst(path)
}


#' @rdname fst
#' @export

slice_fst = function(ft,row_no){
  setDT(ft[row_no,])[]
}

#' @rdname fst
#' @export
# select_fst = function(ft,...){
#
#   setDT(ft[1,])[0] %>% select_dt(...) %>% names() -> sel_names
#   setDT(ft[names(ft) %chin% sel_names])[]
#
# }

select_fst = function(ft,...){

  setDT(ft[1,])[0] %>% select_dt(...) %>% names() -> sel_names
  names(ft) %chin% sel_names -> logical_vec
  if(all(logical_vec == FALSE)) {
    warning("No matched columns,try other patterns. Names of the `fst_table` are listed.")
    names(ft)
  } else setDT(ft[logical_vec])[]

}

#' @rdname fst
#' @export

filter_fst = function(ft,...){
  substitute(list(...)) %>%
    lapply(deparse) %>%
    .[-1] %>%
    str_c(collapse = " & ")-> dot_string
  names(ft) -> ft_names
  ft_names[str_detect(dot_string,ft_names)] -> old
  paste0("ft$",old) -> new
  for(i in seq_along(old)) gsub(old[i],new[i],dot_string) -> dot_string
  eval(parse(text = str_glue("ft[{dot_string},] %>% as.data.table()")))
}

#' @rdname fst
#' @export
summary_fst = function(ft){
  metadata_fst(.subset2(ft, "meta")[[1]])
}




