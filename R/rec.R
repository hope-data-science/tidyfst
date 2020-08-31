

#' @title Recode number or strings
#' @name rec
#' @description Recode discrete variables, including numerice and character
#' variable.
#' @param x A numeric or character vector.
#' @param rec String with recode pairs of old and new values.
#'  Find the usage in examples.
#' @param keep Logical. Decide whether to keep the original values if not recoded.
#'  Defaults to \code{TRUE}.
#' @return A vector.
#' @seealso \code{\link[sjmisc]{rec}}
#' @examples
#'
#' x = 1:10
#' x
#' rec_num(x, rec = "1=10; 4=2")
#' rec_num(x, rec = "1:3=1; 4:6=2")
#' rec_num(x, rec = "1:3=1; 4:6=2",keep = FALSE)
#'
#' y = letters[1:5]
#' y
#' rec_char(y,rec = "a=A;b=B")
#' rec_char(y,rec = "a,b=A;c,d=B")
#' rec_char(y,rec = "a,b=A;c,d=B",keep = FALSE)
#'

#' @rdname rec
#' @export
rec_num = function(x,rec,keep = TRUE){
  str_split(rec,";",simplify = TRUE) %>%
    str_squish() %>%
    strsplit("=") -> rec_list

  lapply(rec_list,function(x) paste0("x %in% c(",x[1],"),",x[2])) %>%
    str_c(collapse = ",") -> in_fcase

  res = eval(parse(text = str_glue("fcase({in_fcase})")))
  if(keep) fcoalesce(res,as.numeric(x))
  else res

}

#' @rdname rec
#' @export
rec_char = function(x, rec, keep = TRUE){
  str_split(rec,";",simplify = TRUE) %>%
    str_squish() %>%
    strsplit("=") -> rec_list

  lapply(rec_list,function(x) {
    x[1]%>% str_split(",",simplify = T) %>%
      lapply(function(x) paste0("'",x,"'")) %>%
      str_c(collapse = ",") %>%
      str_c("c(",.,")") %>%
      str_c("x %chin% ",.,",'",x[2],"'")
  }) %>% str_c(collapse = ",") -> in_fcase

  res = eval(parse(text = str_glue("fcase({in_fcase})")))
  if(keep) fcoalesce(res,x)
  else res

}


