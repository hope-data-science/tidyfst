
#' @title Join table by common keys
#' @description Join operations.
#'
#' @param x data.frame
#' @param y data.frame
#' @param by
#'   For functions with suffix \code{_dt}.
#'    A character vector of variables to join by. If NULL, the default,
#'   *_join() will do a natural join, using all variables with common names
#'   across the two tables. A message lists the variables so that you can check
#'   they're right (to suppress the message, simply explicitly list the
#'   variables that you want to join). To join by different variables on x and y
#'   use a named vector. For example, by = c("a" = "b") will match x.a to y.b.
#' @param by For functions without suffix \code{_dt},
#'   this parameter will pass to the
#'   \code{on} paramter to the data.table. Details could be found at
#'   \code{\link[data.table]{data.table}}.Examples included:
#'   1.\code{.by = c("a","b")} (this is a must for \code{set_full_join});
#'   2.\code{.by = c(x1="y1", x2="y2")};
#'   3.\code{.by = c("x1==y1", "x2==y2")};
#'   4.\code{.by = c("a", V2="b")};
#'   5.\code{.by = .(a, b)};
#'   6.\code{.by = c("x>=a", "y<=b")} or \code{.by = .(x>=a, y<=b)}.
#' @param suffix If there are non-joined duplicate variables in x and y, these
#'   suffixes will be added to the output to disambiguate them. Should be a
#'   character vector of length 2.
#' @description For functions without suffix \code{_dt}, they use
#' \code{X[Y]} syntax to join tables, and pass the "by" parameter to
#' "on" in data.table. They have different features and syntax. They
#' starts with first letter of left/right/full/inner/semi/anti.

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
#'
#' # the syntax of non-"_dt" suffix joins is a bit different
#' workers %>% ijoin(positions2,by = "name==worker")
#'
#' x= data.table(a=1:5,a1 = 2:6,b=11:15)
#' y= data.table(a=c(1:4,6), a1 = c(1,2,4,5,1),c=c(101:104,106))
#'
#' merge(x,y,all = TRUE) -> a
#' fjoin(x,y,by = c("a","a1")) -> b
#' data.table::setcolorder(a,names(b))
#'
#' fsetequal(a,b)

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
  if(is.null(by)) {
    by = intersect(names(x), names(y))
    by_name = str_c(by, collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
    dt1[!dt2, on = by]
  } else dt1[!dt2, on = by]
}

# anti_join_dt = function(x,y,by = NULL){
#   dt1 = as_dt(x)
#   dt2 = as_dt(y)
#   sel_by = by
#   if(is.null(by)) merge(dt1,dt2)[,1:length(dt1)] %>% fsetdiff(dt1,.)-> res
#   else if(is.null(names(by)))
#     merge(dt1,dt2[,.SD,.SDcols = sel_by],by) %>%
#      setcolorder(names(dt1)) %>%
#      fsetdiff(dt1,.)-> res
#   else
#     merge(dt1,dt2[,.SD,.SDcols = sel_by],by.x = names(by),by.y = by) %>%
#      setcolorder(names(dt1)) %>%
#      fsetdiff(dt1,.)-> res
#   unique(res)
# }

#' @rdname join
#' @export
semi_join_dt = function(x,y,by = NULL){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  sel_by = by
  if(is.null(by)){
    by = intersect(names(x), names(y))
    by_name = str_c(by, collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
  }
  w = unique(dt1[dt2, on = by, nomatch = 0L, which = TRUE, allow.cartesian = TRUE])
  dt1[w]
}

# semi_join_dt = function(x,y,by = NULL){
#   dt1 = as_dt(x)
#   dt2 = as_dt(y)
#   sel_by = by
#   if(is.null(by)) merge(dt1,dt2)[,1:length(dt1)] -> res
#   else if(is.null(names(by))) merge(dt1,dt2[,.SD,.SDcols = sel_by],by)-> res
#   else merge(dt1,dt2[,.SD,.SDcols = sel_by],by.x = names(by),by.y = by)-> res
#   unique(res)
# }



#' @rdname join
#' @export
ljoin = function(x,y,by = NULL){
  x = as_dt(x)
  y = as_dt(y)
  if(is.null(by)) {
    by = intersect(names(x),names(y))
    by_name = str_c(by,collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
  }
  y[x,on = by]
}

#' @rdname join
#' @export
rjoin = function(x,y,by = NULL){
  x = as_dt(x)
  y = as_dt(y)
  if(is.null(by)) {
    by = intersect(names(x),names(y))
    by_name = str_c(by,collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
  }
  x[y,on = by]
}

#' @rdname join
#' @export
ijoin = function(x,y,by = NULL){
  x = as_dt(x)
  y = as_dt(y)
  if(is.null(by)) {
    by = intersect(names(x),names(y))
    by_name = str_c(by,collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
  }
  x[y, nomatch = 0L, on = by]
}

#' @rdname join
#' @export
fjoin = function(x,y,by = NULL){
  x = as_dt(x)
  y = as_dt(y)
  if(is.null(by)) {
    by = intersect(names(x),names(y))
    by_name = str_c(by,collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
  }
  rbind(x[,.SD,.SDcols = by],y[,.SD,.SDcols = by]) %>%
    unique() -> unique_keys
  y[x[.(unique_keys), on=by],on = by]
}

#' @rdname join
#' @export
ajoin = function(x,y,by = NULL){
  x = as_dt(x)
  y = as_dt(y)
  if(is.null(by)) {
    by = intersect(names(x),names(y))
    by_name = str_c(by,collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
  }
  x[!y, on = by]
}

#' @rdname join
#' @export
sjoin = function(x,y,by = NULL){
  x = as_dt(x)
  y = as_dt(y)
  if(is.null(by)) {
    by = intersect(names(x),names(y))
    by_name = str_c(by,collapse = ",")
    message(str_glue("Joining by: {by_name}\n\n"))
  }
  w = unique(x[y, on = by, nomatch = 0L, which = TRUE, allow.cartesian = TRUE])
  x[w]
}






