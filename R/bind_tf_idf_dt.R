

#' @title Compute TF–IDF Using data.table with Optional Counting and Grouping
#' @description
#' This function computes term frequency–inverse document frequency (tf–idf)
#' on a dataset with one row per term occurrence (or pre-counted).
#' It preserves original column names and returns new columns:
#'   - `n`: raw count (computed or user-supplied)
#'   - `tf`: term frequency per document
#'   - `idf`: inverse document frequency per group (or corpus)
#'   - `tf_idf`: tf × idf
#' If `group_col` is `NULL`, all documents are treated as a single group.
#'
#' @param .data       A data.frame or data.table of text data.
#' @param group_col   Character name of grouping column, or `NULL` for no grouping.
#' @param doc_col     Character name of document identifier column.
#' @param term_col    Character name of term/word column.
#' @param n_col       (Optional) Character name of pre-counted term-frequency column.
#'                    If `NULL` (default), counts are computed via `.N`.
#'
#' @return A data.table containing:
#'   - Original grouping, document, and term columns
#'   - `n`, `tf`, `idf`, and `tf_idf`
#'
#' @seealso \code{\link[tidytext]{bind_tf_idf}}
#' @examples
#'
#' # With groups
#' df <- data.frame(
#'   category = rep(c("A","B"), each = 6),
#'   doc_id   = rep(c("d1","d2","d3"), times = 4),
#'   word     = c("apple","banana","apple","banana","cherry","apple",
#'                "dog","cat","dog","mouse","cat","dog"),
#'   stringsAsFactors = FALSE
#' )
#' result <- bind_tf_idf_dt(df, "category", "doc_id", "word")
#' result
#'
#' # Without groups
#' df %>%
#'   filter_dt(category == "A") %>%
#'   bind_tf_idf_dt(doc_col = "doc_id",term_col = "word")
#'
#' # With counts provided
#' df %>%
#'   filter_dt(category == "A") %>%
#'   count_dt() %>%
#'   bind_tf_idf_dt(doc_col = "doc_id",term_col = "word",n_col = "n")
#' df %>%
#'   count_dt() %>%
#'   bind_tf_idf_dt(group_col = "category",
#'                  doc_col = "doc_id",
#'                  term_col = "word",n_col = "n")
#'


#' @export

bind_tf_idf_dt <- function(.data,
                           group_col = NULL,
                           doc_col,
                           term_col,
                           n_col = NULL) {
  # Convert to data.table
  dt <- as.data.table(.data)

  # Handle optional grouping
  if (is.null(group_col)) {
    dt[, .tmp_group := "__ALL__"]
    grp <- ".tmp_group"
    drop_tmp <- TRUE
  } else {
    grp <- group_col
    drop_tmp <- FALSE
  }

  # Compute or use existing n
  if (!is.null(n_col) && n_col %in% names(dt)) {
    # Copy pre-counted column
    dt_counts <- dt[, .(n = get(n_col)),
                    by = c(grp, doc_col, term_col)]
  } else {
    # Count occurrences per (group, document, term)
    dt_counts <- dt[, .(n = .N),
                    by = c(grp, doc_col, term_col)]
  }

  # Compute term frequency: tf = n / sum(n) per (group, document)
  dt_counts[, tf := n / sum(n), by = c(grp, doc_col)]

  # Compute inverse document frequency:
  # docs_in_group = number of unique docs in each group
  dt_counts[, docs_in_group := uniqueN(get(doc_col)), by = grp]
  # docs_with_term = number of docs in group containing the term
  dt_counts[, docs_with_term := uniqueN(get(doc_col)),
            by = c(grp, term_col)]
  # idf = log(docs_in_group / docs_with_term)
  dt_counts[, idf := log(docs_in_group / docs_with_term)]

  # Compute tf–idf
  dt_counts[, tf_idf := tf * idf]

  # Clean up helper columns
  dt_counts[, c("docs_in_group", "docs_with_term") := NULL]
  if (drop_tmp) dt_counts[, .tmp_group := NULL]

  # Return result
  return(dt_counts[])
}

globalVariables(c(".tmp_group","docs_in_group","docs_with_term","idf","n","tf","tf_idf"))

