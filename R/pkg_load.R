
#' Load or unload R package(s)
#'
#' This function is a wrapper for \code{\link[base]{require}} and
#' \code{\link[base]{detach}}.  \code{pkg_load} checks to see if a
#' package is installed, if not it attempts to install the package
#' from CRAN. \code{pkg_unload} can detach one or more loaded packages.
#'
#' @param ... Name(s) of package(s).
#' @param pkg_names (Optional)Character vector containing packages to load
#'  or unload. Default uses \code{NULL}.
#' @seealso
#' \code{\link[base]{require}},
#' \code{\link[base]{detach}},
#' \code{\link[pacman]{p_load}},
#' \code{\link[pacman]{p_unload}}
#' @examples
#' \dontrun{
#' pkg_load(data.table)
#' pkg_unload(data.table)
#'
#' pkg_load(stringr,fst)
#' pkg_unload(stringr,fst)
#'
#' pkg_load(pkg_names = c("data.table","fst"))
#' p_unload(pkg_names = c("data.table","fst"))
#'
#' pkg_load(data.table,stringr,fst)
#' pkg_unload("all") # shortcut to unload all loaded packages
#' }

#' @rdname pkg_load
#' @export
pkg_load = function(...,pkg_names = NULL){
  if(is.null(pkg_names)){
    (match.call(expand.dots = FALSE)$...) %>%
      as.character() %>%
      setdiff(.packages())-> list.of.packages
  }else list.of.packages = pkg_names

  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  sapply(list.of.packages,\(x){
    suppressMessages(require(x,character.only = TRUE))
  }) %>% all() %>% invisible()
}

#' @rdname pkg_load
#' @export
pkg_unload = function(...,pkg_names = NULL){
  if(is.null(pkg_names)){
    (match.call(expand.dots = FALSE)$...) %>%
      as.character() -> list.of.packages
  }else list.of.packages = pkg_names

  if("all" %in% list.of.packages)
    list.of.packages = names(utils::sessionInfo()[["otherPkgs"]])
  else
    list.of.packages = list.of.packages %>%
      intersect(names(utils::sessionInfo()[["otherPkgs"]]))

  sapply(list.of.packages,\(x){
    x <- paste0("package:", x)
    suppressWarnings(detach(x, unload = TRUE, character.only = TRUE,
                            force = TRUE))
  })
  if(length(list.of.packages)>0){
    message("The following packages have been unloaded:\n",
            paste0("\b", paste(list.of.packages, collapse = ", ")))
  }

}
