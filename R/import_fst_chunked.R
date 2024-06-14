
#' @title Read a fst file by chunks
#' @description For `import_fst_chunked`, if a large fst file which could not be imported into the memory all at once,
#'  this function could read the fst file by chunks and preprocessed the chunk to ensure the
#'  results yielded by the chunks are small enough to be summarised in the end.
#'  For `get_fst_chunk_size`, this function can measure the memory used by a specified row number.
#' @param path Path to fst file
#' @param chunk_size Integer. The number of rows to include in each chunk
#' @param chunk_f A function implemented on every chunk.
#' @param combine_f A function to aggregate all the elements from the list of results from chunks.
#' @param nrows Number of rows to test.
#'
#' @return For `import_fst_chunked`, default to the whole data.frame in data.table.
#'  Could be adjusted to any type. For `get_fst_chunk_size`, return the file size.
#' @seealso \code{\link[readr]{read_csv_chunked}}
#' @examples
#'
#' \dontrun{
#'   # Generate some random data frame with 10 million rows and various column types
#'   nr_of_rows <- 1e7
#'   df <- data.frame(
#'     Logical = sample(c(TRUE, FALSE, NA), prob = c(0.85, 0.1, 0.05), nr_of_rows, replace = TRUE),
#'     Integer = sample(1L:100L, nr_of_rows, replace = TRUE),
#'     Real = sample(sample(1:10000, 20) / 100, nr_of_rows, replace = TRUE),
#'     Factor = as.factor(sample(labels(UScitiesD), nr_of_rows, replace = TRUE))
#'   )
#'
#'   # Write the file to disk
#'   fst_file <- tempfile(fileext = ".fst")
#'   write_fst(df, fst_file)
#'
#'   # Get the size of 10000 rows
#'   get_fst_chunk_size(fst_file,1e4)
#'
#'   # File all rows that Integer == 7 by chunks
#'   import_fst_chunked(fst_file,chunk_f = \(x) x[Integer==7])
#'
#' }
#'

#' @rdname import_fst_chunked
#' @export

import_fst_chunked = \(path,chunk_size = 10000L,chunk_f = identity,combine_f = rbindlist){
  parse_fst(path) %>% nrow() -> ft_nrow
  seq(from = 1,to = ft_nrow,by = chunk_size)-> start_index
  c(start_index[-1] - 1,ft_nrow) -> end_index
  Map(f = \(s,e){
    read_fst(path,from = s,to = e,as.data.table = TRUE) %>%
      chunk_f
  },start_index,end_index) %>% combine_f
}

#' @rdname import_fst_chunked
#' @export
get_fst_chunk_size = \(path,nrows){
  object_size(read_fst(path,from = 1,to = nrows))
}

