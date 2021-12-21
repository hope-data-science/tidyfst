
#' @title Count pairs of items within a group
#' @description Count the number of times each pair
#' of items appear together within a group.
#' For example, this could count the number of times two words appear within documents.
#' This function has referred to \code{pairwise_count} in \strong{widyr} package,
#' but with very different defaults on several parameters.
#' @param .data A data.frame.
#' @param .group Column name of counting group.
#' @param .value Item to count pairs, will end up in \code{V1} and \code{V2} columns.
#' @param upper When \code{FALSE}(Default), duplicated combinations would be removed.
#' @param diag Whether to include diagonal (V1==V2) in output. Default uses \code{FALSE}.
#' @param sort Whether to sort rows by counts. Default uses \code{TRUE}.
#' @return A data.table with 3 columns (named as "V1","V2" and "n"), containing combinations
#'  in "V1" and "V2", and counts in "n".
#' @seealso \code{\link[widyr]{pairwise_count}}
#' @examples
#'
#' dat <- data.table(group = rep(1:5, each = 2),
#'               letter = c("a", "b",
#'                          "a", "c",
#'                          "a", "c",
#'                          "b", "e",
#'                          "b", "f"))
#' pairwise_count_dt(dat,group,letter)
#' pairwise_count_dt(dat,group,letter,sort = FALSE)
#' pairwise_count_dt(dat,group,letter,diag = TRUE)
#' pairwise_count_dt(dat,group,letter,diag = TRUE,upper = TRUE)
#'
#' # The column name could be specified using character.
#' pairwise_count_dt(dat,"group","letter")

#' @rdname pairwise
#' @export
pairwise_count_dt = function(.data,.group,.value,upper = FALSE,diag = FALSE,sort = TRUE){
  dt = as_dt(.data)
  parse_name <- substitute(.group) %>% deparse()
  if (!str_detect(parse_name, "^\""))
    .group = parse_name
  parse_name <- substitute(.value) %>% deparse()
  if (!str_detect(parse_name, "^\""))
    .value = parse_name

  str_glue("dt[,CJ(V1={.value},V2={.value},unique = TRUE),by = .group][,(.group):=NULL]") %>%
    parse(text = .) %>% eval() %>%
    count_dt(sort = sort)-> res

  if(!diag) res = res[V1!=V2]
  if(!upper) res = res[V1 <= V2]

  res
}

globalVariables(c("V1","V2"))

