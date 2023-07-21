.onAttach = function(...) {
    options(
        "datatable.print.class" = TRUE, # print class in data.table
        "datatable.print.trunc.cols" = TRUE,
        "datatable.print.keys" = TRUE
    )
    # hints = c(
    #     "Life's short, use R."
    # )
    # curr_hint = sample(hints, 1)
    # packageStartupMessage(paste0("\n", curr_hint, "\n"))

  packageStartupMessage("Thank you for using tidyfst!")
  packageStartupMessage("To acknowledge our work, please cite the package:")
  packageStartupMessage("Huang et al., (2020). tidyfst: Tidy Verbs for Fast Data Manipulation. Journal of Open Source Software, 5(52), 2388, https://doi.org/10.21105/joss.02388")
}


