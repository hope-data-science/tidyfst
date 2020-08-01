.onAttach = function(...) {
    options(
        "datatable.print.class" = TRUE, # print class in data.table
           "datatable.print.trunc.cols" = TRUE,
           "datatable.print.keys" = TRUE
        )
    hints = c(
        "Life's short, use R."
    )
    curr_hint = sample(hints, 1)
    packageStartupMessage(paste0("\n", curr_hint, "\n"))
}
