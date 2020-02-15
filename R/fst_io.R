
#' @title Read and write fst files
#' @description Wrapper for \code{\link[fst]{read_fst}} and \code{\link[fst]{write_fst}}
#' from \pkg{fst}, but use a different default. For data import, always return a data.table.
#' For data export, always compress the data to the smallest size.
#' @param x a data frame to write to disk
#' @param path path to fst file
#' @param compress value in the range 0 to 100, indicating the amount of compression to use.
#' Lower values mean larger file sizes. The default compression is set to 50.
#' @param uniform_encoding If `TRUE`, all character vectors will be assumed to have elements with equal encoding.
#' The encoding (latin1, UTF8 or native) of the first non-NA element will used as encoding for the whole column.
#' This will be a correct assumption for most use cases.
#' If `uniform.encoding` is set to `FALSE`, no such assumption will be made and all elements will be converted
#' to the same encoding. The latter is a relatively expensive operation and will reduce write performance for
#' character columns.
#' @param columns Column names to read. The default is to read all columns.
#' @param from Read data starting from this row number.
#' @param to Read data up until this row number. The default is to read to the last row of the stored dataset.
#' @param as.data.table If TRUE, the result will be returned as a \code{data.table} object. Any keys set on
#' dataset \code{x} before writing will be retained. This allows for storage of sorted datasets. This option
#' requires \code{data.table} package to be installed.
#' @param old_format must be FALSE, the old fst file format is deprecated and can only be read and
#' converted with fst package versions 0.8.0 to 0.8.10.
#' @return `import_fst` returns a data.table with the selected columns and rows. `export_fst`
#' writes `x` to a `fst` file and invisibly returns `x` (so you can use this function in a pipeline).
#' @seealso \code{\link[fst]{read_fst}}
#' @examples
#' \donttest{
#' export_fst(iris,"iris_fst_test.fst")
#' iris_dt = import_fst("iris_fst_test.fst")
#' iris_dt
#' unlink("iris_fst_test.fst")
#' }

#' @rdname fst_io
#' @export
export_fst = function(x, path, compress = 100, uniform_encoding = TRUE){
  write_fst(x, path, compress, uniform_encoding)
}

#' @rdname fst_io
#' @export
import_fst = function(path, columns = NULL, from = 1, to = NULL,
                      as.data.table = TRUE, old_format = FALSE){
  read_fst(path, columns, from, to,
           as.data.table, old_format)
}



