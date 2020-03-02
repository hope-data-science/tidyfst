
#' @title Efficient transpose of data.frame
#' @description An efficient way to transpose data frames(data.frame/data.table/tibble).
#' @param data A data.frame/data.table/tibble
#' @return A transposed data.frame
#' @details This function would return the original data.frame structure,
#' keeping all the row names and column names. If the row names are not
#' available or, "V1,V2..." will be provided.
#' @examples
#'
#' t_dt(iris)
#' t_dt(mtcars)

#' @export
t_dt = function(data){
  dt = as_dt(data)
  dt = transpose(dt) %>% as.data.frame()
  rownames(dt) = colnames(data)
  if(setequal(rownames(data),as.character(1:nrow(data))))
    colnames(dt) = paste0("V",rownames(data))
  else
    colnames(dt) = rownames(data)
  dt
}
