
# select/filter/slice/arrange/mutate/summarise/summarise_all/distinct
# count/add_count/topn/topfrac
# join
# nest/unnest
# long/wide
# rename


library(maditr)

# to use it from R scripts, use `source('F:/tidydt/tidydt_source.R', echo=TRUE)`

# 01.basic
select_dt = dt_select #
filter_dt = dt_filter #
arrange_dt = dt_arrange #
summarise_dt = summarize_dt = dt_summarise #
summarise_all_dt = summarize_all_dt = dt_summarise_all #

mutate_dt = function(data, ..., by){
  eval.parent(substitute(let(data, ...,
                             by = by) %>% as.data.table)
  )
}    #



# receieve an integer vector
slice_dt = function(data,int_vec){
  as.data.table(data)[int_vec]
}  #


distinct_dt = function(data,...,.keep_all = FALSE){

  data = as.data.table(data)

  if(is.null(substitute(...))) return(unique(data))

  dots = substitute(...) %>% deparse()

  if(.keep_all) res = unique(data,by = dots)
  else res = unique(data,by = dots) %>% select_dt(...)

  res
}  #

# 02.count family

count_dt = dt_count #
add_count_dt = function(data, ..., weight = NULL, sort = FALSE, name = "n"){
  name = as.symbol(name)
  weight_expr = substitute(weight)
  if(is.null(weight_expr)){
    res = eval.parent(substitute(let(data, name := .N, by = .(...))))
  } else {
    res = eval.parent(substitute(let_if(data, !is.na(weight), name := sum(weight), by = .(...))))
  }
  if(sort) {
    res = eval(substitute(sort_by(res, -name), list(name = name)))

  }
  res %>% as.data.table()
} #

## put column name in front of number
topn_dt = function(data, wt,n){

  data = as.data.table(data)

  if(n > 0){
    eval.parent(substitute({
      data %>%
        filter_dt(wt >= data[order(-wt),wt[n]]) %>%
        arrange_dt(-wt)
    }))
  }else if(n < 0){
    eval.parent(substitute({
      data %>%
        filter_dt(wt <= data[order(wt),wt[-n]]) %>%
        arrange_dt(wt)
    }))
  }else data[0]

} #

## put column name in front of number
topfrac_dt = function(data, wt,n){

  data = as.data.table(data)

  if(n > 0){
    eval.parent(substitute({
      data[order(-wt)][1:(.N*n)]
    }))}
  else if(n < 0){
    eval.parent(substitute(
      data[order(wt)][1:(.N*(-n))]
    ))} else data[0]
} #

# 03.join
left_join_dt = dt_left_join
right_join_dt = dt_right_join
inner_join_dt = dt_inner_join
full_join_dt = dt_full_join
anti_join_dt = dt_anti_join
semi_join_dt = dt_semi_join


# 04.nest

# nest by what group? (...)
nest_dt = function(data, ...){
  data = as.data.table(data)
  var_list = substitute(list(...))
  data[,list(data = list(.SD)),by = var_list]
} #

# unnest which column? (col)
unnest_dt <- function(data, col) {

  setdiff(names(data),deparse(substitute(col))) -> group_name
  call_string = paste0("data[, unlist(data,recursive = FALSE), by = list(",group_name,")]")
  eval(parse(text = call_string))

} #

# iris %>% nest_dt(Species) -> a
# a %>% unnest_dt(data)

# 05. longer/wider(dcast/melt)


# easy wrapper for dcast,for advanced usage, use dcast directly
wider_dt = function(data,group,class_to_spread,value_to_spread = NULL,fill = NA){
  group = substitute(group) %>% deparse()
  class_to_spread = substitute(class_to_spread) %>% deparse()
  value_to_spread = substitute(value_to_spread)
  fill = substitute(fill) %>% deparse()
  if(is.null(value_to_spread))
    call_string = paste0("dcast(data,",
                         group," ~ ",class_to_spread,
                         ",fill =",fill,")")
  else
    call_string = paste0("dcast(data,",
                         group," ~ ",class_to_spread,
                         ",value.var ='",value_to_spread,"'",
                         ",fill =",fill,")")
  eval(parse(text = call_string))
}

# easy wrapper for melt,for advanced usage, use melt directly
longer_dt = function(data,group,gather_class = "class",gather_value = "value",na.rm = FALSE){
  group = substitute(group) %>% deparse()
  class = substitute(gather_class)
  value = substitute(gather_value)
  melt(data,id.vars = group,variable.name = class,value.name = value,na.rm = na.rm)
}

# stocks = data.frame(
#   time = as.Date('2009-01-01') + 0:9,
#   X = rnorm(10, 0, 1),
#   Y = rnorm(10, 0, 2),
#   Z = rnorm(10, 0, 4)
# )
#
# stocks %>%
#   longer_dt(time) -> longer_stocks
#
# longer_stocks %>%
#   mutate_dt(one = 1) %>%
#   wider_dt(time,class,one)

# misc

## first provide old names, then provide new names
## always receives character vector
rename_dt = setnames

###############################################################################


library(pacman)
p_load(data.table,stringr,fst)

## general
as_dt = function(data){
  if(!is.data.frame(data)) stop("Only a data.frame could be received.")
  else as.data.table(data)
}

###################################################################################

## mutate
mutate_dt = function(data,...){
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") -> dot_string
  eval(parse(text = str_glue("dt[,`:=`{dot_string},][]")))
}

## transmute
transmute_dt = function(data,...){
  dt = as_dt(data)
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") -> dot_string
  eval(parse(text = str_glue("dt[,.{dot_string},]")))
}


### example
iris %>% mutate_dt(one = 1,Sepal.Length = Sepal.Length + 1)
iris %>% transmute_dt(one = 1,Sepal.Length = Sepal.Length + 1)

###################################################################################

## slice
slice_dt = function(data,...){
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2)-> dot_string
  if(str_detect(dot_string,"^[0-9]") &
     str_detect(dot_string,"[0-9]$") &
     str_detect(dot_string,","))
    eval(parse(text = str_glue("dt[c({dot_string})]")))
  else eval(parse(text = str_glue("dt[{dot_string}]")))
}

iris %>% slice_dt(1:3)
iris %>% slice_dt(1,3)
iris %>% slice_dt(c(1,3))

###################################################################################

## select
### cols: numeric or character vector
select_dt = function(data,...,cols = NULL){
  dt = as_dt(data)
  if(is.null(cols)){
    substitute(list(...)) %>%
      deparse() %>%
      str_extract("\\(.+\\)") %>%
      str_sub(2,-2)-> dot_string
    if(str_detect(dot_string,"^\"")){
      str_remove_all(dot_string,"\"") %>%
        str_subset(names(dt),.) %>%
        str_c(collapse = ",") -> dot_string
      eval(parse(text = str_glue("dt[,.({dot_string})]")))
    }
    else if(str_detect(dot_string,"^[0-9]"))
      eval(parse(text = str_glue("dt[,c({dot_string})]")))
    else if(str_detect(dot_string,"^c\\("))
      eval(parse(text = str_glue("dt[,{dot_string}]")))
    else eval(parse(text = str_glue("dt[,.({dot_string})]")))
  }
  else dt[,.SD,.SDcols = cols]
}

iris %>% select_dt(Species)
iris %>% select_dt(Sepal.Length,Sepal.Width)
iris %>% select_dt(c("Sepal.Length","Sepal.Width"))
iris %>% select_dt(1:3)
iris %>% select_dt(1,3)
iris %>% select_dt("Pe")
iris %>% select_dt("Pe|Sp")
iris %>% select_dt(cols = 2:3)
iris %>% select_dt(cols = names(iris)[2:3])

###################################################################################

## arrange

arrange_dt = function(data,...){
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2)-> dot_string
  eval(parse(text = str_glue("dt[order({dot_string})]")))
}

iris %>% arrange_dt(Sepal.Length)
iris %>% arrange_dt(Sepal.Length,Sepal.Width)
iris %>% arrange_dt(-Sepal.Length)
iris %>% arrange_dt(Sepal.Length,-Sepal.Width)

###################################################################################

## filter

filter_dt = function(data,...){
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2) %>%
    str_replace_all(","," & ")-> dot_string
  eval(parse(text = str_glue("dt[{dot_string}]")))
}

iris %>% filter_dt(Sepal.Length > 7)
iris %>% filter_dt(Sepal.Length > 7,Sepal.Width > 3)
iris %>% filter_dt(Sepal.Length > 7 & Sepal.Width > 3)
iris %>% filter_dt(Sepal.Length == max(Sepal.Length))

###################################################################################

## summarise

summarise_dt = function(data,...,by = NULL){
  dt = as_dt(data)
  by = substitute(by)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2) -> dot_string
  if(deparse(by) == "NULL"){
    eval(parse(text = str_glue("dt[,.({dot_string})]")))
  } else{
    if(by %>% deparse() %>% str_detect("\\."))
      eval(parse(text = str_glue("dt[,.({dot_string}),by = by]")))
    else{
      by %>%
        deparse() %>%
        str_c(".(",.,")") -> by
      eval(parse(text = str_glue("dt[,.({dot_string}),by = {by}]")))
    }
  }
}

summarize_dt = summarise_dt

iris %>% summarise_dt(xx = max(Sepal.Length),yy = min(Sepal.Length))
iris %>% summarise_dt(xx = max(Sepal.Length),by = Species)
iris %>% summarise_dt(xx = max(Sepal.Length),by = .(Species))
mtcars %>% summarise_dt(max_mpg = max(mpg),min_mpg = min(mpg),
                        by = .(cyl,gear))

###################################################################################

## count

count_dt = function(data,...,sort = TRUE,name = "n"){
  dt = as_dt(data)
  if(sort == TRUE) dt[,.(n = .N),by = ...][order(-n)] -> dt
  else dt[,.(n = .N),by = ...] -> dt
  if(name != "n")  setnames(dt,old = "n",new = name)
  as.data.table(dt)
}

iris %>% count_dt(Species)
mtcars %>% count_dt(carb)
mtcars %>% count_dt(carb,name = "count")
mtcars %>% count_dt(carb,sort=F)

## add_count

add_count_dt = function(data,...,name = "n"){
  dt = as_dt(data)
  dt[,mutate_dt(.SD,n = .N),by = ...] -> dt
  if(name != "n")  setnames(dt,old = "n",new = name)
  as.data.table(dt)
}

iris %>% add_count_dt(Species)
iris %>% add_count_dt(Species,name = "N")

###################################################################################

## join

left_join_dt = function(x,y,by = NULL,suffix = c(".x",".y")){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  if(is.null(by)) {
    join_names = intersect(names(dt1),names(dt2)) %>% str_c(collapse = ",")
    print(str_glue("Joining by: {join_names}\n"))
    merge(dt1,dt2,all.x = TRUE,suffixes = suffix)
  }
  else if(is.null(names(by))) merge(dt1,dt2,all.x = TRUE,by = by,suffixes = suffix)
  else  merge(dt1,dt2,all.x = TRUE,by.x = names(by),by.y = by,suffixes = suffix)
}

right_join_dt = function(x,y,by = NULL,suffix = c(".x",".y")){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  if(is.null(by)) {
    join_names = intersect(names(dt1),names(dt2)) %>% str_c(collapse = ",")
    print(str_glue("Joining by: {join_names}\n"))
    merge(dt1,dt2,all.y = TRUE,suffixes = suffix)
  }
  else if(is.null(names(by))) merge(dt1,dt2,all.y = TRUE,by = by,suffixes = suffix)
  else  merge(dt1,dt2,all.y = TRUE,by.x = names(by),by.y = by,suffixes = suffix)
}

inner_join_dt = function(x,y,by = NULL,suffix = c(".x",".y")){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  if(is.null(by)) {
    join_names = intersect(names(dt1),names(dt2)) %>% str_c(collapse = ",")
    print(str_glue("Joining by: {join_names}\n"))
    merge(dt1,dt2,suffixes = suffix)
  }
  else if(is.null(names(by))) merge(dt1,dt2,by = by,suffixes = suffix)
  else  merge(dt1,dt2,by.x = names(by),by.y = by,suffixes = suffix)
}

full_join_dt = function(x,y,by = NULL,suffix = c(".x",".y")){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  if(is.null(by)) {
    join_names = intersect(names(dt1),names(dt2)) %>% str_c(collapse = ",")
    print(str_glue("Joining by: {join_names}\n"))
    merge(dt1,dt2,all = TRUE,suffixes = suffix)
  }
  else if(is.null(names(by))) merge(dt1,dt2,all = TRUE,by = by,suffixes = suffix)
  else  merge(dt1,dt2,all = TRUE,by.x = names(by),by.y = by,suffixes = suffix)
}

anti_join_dt = function(x,y,by = NULL){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  x_names = names(dt1)
  both_have = inner_join_dt(dt1,dt2,by)[,..x_names]
  fsetdiff(dt1,both_have)
}

semi_join_dt = function(x,y,by = NULL){
  dt1 = as_dt(x)
  dt2 = as_dt(y)
  x_names = names(dt1)
  both_have = inner_join_dt(dt1,dt2,by)[,..x_names]
  fintersect(dt1,both_have)
}

###################################################################################

## distinct

distinct_dt = function(data,...,.keep_all = FALSE){
  dt = as_dt(data)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_c(".",.)-> dot_string
  if(is.na(dot_string)) unique(dt)
  else{
    if(!.keep_all)
      dt %>% select_dt(...) %>% unique()
    else eval(parse(text = str_glue("dt[,.SD[1],by = {dot_string}]")))
  }
}

mtcars %>% distinct_dt(cyl,vs,.keep_all = TRUE)

iris %>% distinct_dt()
iris %>% distinct_dt(Species)
iris %>% distinct_dt(Species,.keep_all = T)

###################################################################################

## top_n/top_frac

top_n_dt = function(data,n,wt = NULL){
  dt = as_dt(data)
  wt = substitute(wt)
  if(n > 0){
    if(is.null(wt)) wt = names(dt)[length(dt)]
    else wt = deparse(wt)
    dt[[wt]] %>% sort(decreasing = TRUE) %>% .[n] -> value
    "dt[{wt} >= value]" %>% str_glue() %>% parse(text = .) %>% eval()
  } else{
    n = -n
    if(is.null(wt)) wt = names(dt)[length(dt)]
    else wt = deparse(wt)
    dt[[wt]] %>% sort() %>% .[n] -> value
    "dt[{wt} <= value]" %>% str_glue() %>% parse(text = .) %>% eval()
  }
}

top_n_dt(iris,-10,Sepal.Length)

top_frac_dt = function(data,n,wt = NULL){
  dt = as_dt(data)
  wt = substitute(wt)
  if(n > 0){
    if(is.null(wt)) wt = names(dt)[length(dt)]
    else wt = deparse(wt)
    dt[[wt]] %>% sort(decreasing = TRUE) %>% .[length(.)*n] -> value
    "dt[{wt} >= value]" %>% str_glue() %>% parse(text = .) %>% eval()
  } else{
    n = -n
    if(is.null(wt)) wt = names(dt)[length(dt)]
    else wt = deparse(wt)
    dt[[wt]] %>% sort() %>% .[length(.)*n]  -> value
    "dt[{wt} <= value]" %>% str_glue() %>% parse(text = .) %>% eval()
  }
}

## select_fst
### cols: numeric or character vector
select_fst = function(ft,...){
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2)-> dot_string
  if(str_detect(dot_string,"^\"")){
    dot_string = str_remove_all(dot_string,"\"")
    str_detect(names(ft),dot_string) -> logical_vec
    if(all(logical_vec == FALSE)) {
      warning("No matched columns,try other patterns. Names of the `fst_table` are listed.")
      names(ft)
    } else
      ft[,logical_vec] %>% as.data.table()
  }
  else if(str_detect(dot_string,"^[0-9]") &
          str_detect(dot_string,"[0-9]$"))
    eval(parse(text = str_glue("ft[,c({dot_string})] %>% as.data.table()")))
  else if(str_detect(dot_string,",")){
    dot_string %>%
      str_split(",",simplify = TRUE) %>%
      str_squish() %>%
      str_c("'",.,"'") %>%
      str_c(collapse = ",") %>%
      str_c("c(",.,")") -> dot_string
    eval(parse(text = str_glue("ft[,{dot_string}] %>% as.data.table()")))
  } else
    eval(parse(text = str_glue("ft[,{dot_string}] %>% as.data.table()")))
}


###################################################################################

## group

group_dt = function(data,by = NULL,...){
  dt = as_dt(data)
  by = substitute(by)
  substitute(list(...)) %>%
    deparse() %>%
    str_extract("\\(.+\\)") %>%
    str_sub(2,-2) -> dot_string
  if(deparse(by) == "NULL") stop("Please provide the group(s).")
  else if(by %>% deparse() %>% str_detect("\\."))
    eval(parse(text = str_glue("dt[,(.SD %>% {dot_string}),by = by]")))
  else {
    by %>%
      deparse() %>%
      str_c(".(",.,")") -> by
    eval(parse(text = str_glue("dt[,(.SD %>% {dot_string}),by = {by}]")))
  }
}

iris %>% group_dt(by = Species,slice_dt(1))
iris %>% group_dt(Species,summarise_dt(new = max(Sepal.Length)))
iris %>% group_dt(Species,
                  mutate_dt(new = max(Sepal.Length)) %>%
                    summarise_dt(a=sum(Sepal.Length)))

###################################################################################

## sample

sampe_n_dt = function(data,size,replace = FALSE){
  dt = as_dt(data)
  if(size > nrow(data) & replace == FALSE) stop("Sample size is too large.")
  index = sample(nrow(dt,size = size,replace = replace))
  dt[index]
}

sampe_frac_dt = function(data,size,replace = FALSE){
  dt = as_dt(data)
  if(!between(size,0,1) & replace == FALSE) stop("The fraction is invalid.")
  size = as.integer(nrow(dt) * size)
  index = sample(nrow(dt,size = size,replace = replace))
  dt[index]
}



