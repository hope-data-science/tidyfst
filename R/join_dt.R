
#' @title Join table by common keys
#' @description Join operations.
#'
#' @param x data.frame
#' @param y data.frame
#' @param by a character vector of variables to join by. If NULL, the default,
#'   *_join() will do a natural join, using all variables with common names
#'   across the two tables. A message lists the variables so that you can check
#'   they're right (to suppress the message, simply explicitly list the
#'   variables that you want to join). To join by different variables on x and y
#'   use a named vector. For example, by = c("a" = "b") will match x.a to y.b.
#' @param suffix If there are non-joined duplicate variables in x and y, these
#'   suffixes will be added to the output to disambiguate them. Should be a
#'   character vector of length 2.
#'
#' @return data.table
#' @seealso \code{\link[dplyr]{left_join}}
#' @examples
#'
#' workers = fread("
#'     name company
#'     Nick Acme
#'     John Ajax
#'     Daniela Ajax
#' ")
#'
#' positions = fread("
#'     name position
#'     John designer
#'     Daniela engineer
#'     Cathie manager
#' ")
#'
#' workers %>% inner_join_dt(positions)
#' workers %>% left_join_dt(positions)
#' workers %>% right_join_dt(positions)
#' workers %>% full_join_dt(positions)
#'
#' # filtering joins
#' workers %>% anti_join_dt(positions)
#' workers %>% semi_join_dt(positions)
#'
#' # To suppress the message, supply 'by' argument
#' workers %>% left_join_dt(positions, by = "name")
#'
#' # Use a named 'by' if the join variables have different names
#' positions2 = setNames(positions, c("worker", "position")) # rename first column in 'positions'
#' workers %>% inner_join_dt(positions2, by = c("name" = "worker"))


#' @rdname join
#' @export
left_join_dt = function(x,y,by = NULL,suffix = c(".x",".y")){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  if(is.null(by)) {
    join_names = intersect(names(dt1),names(dt2)) %>% str_c(collapse = ",")
    message(str_glue("Joining by: {join_names}\n\n"))
    merge(dt1,dt2,all.x = TRUE,suffixes = suffix)
  }
  else if(is.null(names(by))) merge(dt1,dt2,all.x = TRUE,by = by,suffixes = suffix)
  else  merge(dt1,dt2,all.x = TRUE,by.x = names(by),by.y = by,suffixes = suffix)
}

#' @rdname join
#' @export
right_join_dt = function(x,y,by = NULL,suffix = c(".x",".y")){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  if(is.null(by)) {
    join_names = intersect(names(dt1),names(dt2)) %>% str_c(collapse = ",")
    message(str_glue("Joining by: {join_names}\n\n"))
    merge(dt1,dt2,all.y = TRUE,suffixes = suffix)
  }
  else if(is.null(names(by))) merge(dt1,dt2,all.y = TRUE,by = by,suffixes = suffix)
  else  merge(dt1,dt2,all.y = TRUE,by.x = names(by),by.y = by,suffixes = suffix)
}

#' @rdname join
#' @export
inner_join_dt = function(x,y,by = NULL,suffix = c(".x",".y")){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  if(is.null(by)) {
    join_names = intersect(names(dt1),names(dt2)) %>% str_c(collapse = ",")
    message(str_glue("Joining by: {join_names}\n\n"))
    merge(dt1,dt2,suffixes = suffix)
  }
  else if(is.null(names(by))) merge(dt1,dt2,by = by,suffixes = suffix)
  else  merge(dt1,dt2,by.x = names(by),by.y = by,suffixes = suffix)
}

#' @rdname join
#' @export
full_join_dt = function(x,y,by = NULL,suffix = c(".x",".y")){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  if(is.null(by)) {
    join_names = intersect(names(dt1),names(dt2)) %>% str_c(collapse = ",")
    message(str_glue("Joining by: {join_names}\n\n"))
    merge(dt1,dt2,all = TRUE,suffixes = suffix)
  }
  else if(is.null(names(by))) merge(dt1,dt2,all = TRUE,by = by,suffixes = suffix)
  else  merge(dt1,dt2,all = TRUE,by.x = names(by),by.y = by,suffixes = suffix)
}

#' @rdname join
#' @export
anti_join_dt = function(x,y,by = NULL){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  sel_by = by
  if(is.null(by)) merge(dt1,dt2)[,1:length(dt1)] %>% fsetdiff(dt1,.)-> res
  else if(is.null(names(by)))
    merge(dt1,dt2[,.SD,.SDcols = sel_by],by) %>%
     setcolorder(names(dt1)) %>%
     fsetdiff(dt1,.)-> res
  else
    merge(dt1,dt2[,.SD,.SDcols = sel_by],by.x = names(by),by.y = by) %>%
     setcolorder(names(dt1)) %>%
     fsetdiff(dt1,.)-> res
  unique(res)
}

#' @rdname join
#' @export
semi_join_dt = function(x,y,by = NULL){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  sel_by = by
  if(is.null(by)) merge(dt1,dt2)[,1:length(dt1)] -> res
  else if(is.null(names(by))) merge(dt1,dt2[,.SD,.SDcols = sel_by],by)-> res
  else merge(dt1,dt2[,.SD,.SDcols = sel_by],by.x = names(by),by.y = by)-> res
  unique(res)
}

















