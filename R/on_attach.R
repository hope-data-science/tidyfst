.onAttach = function(...) {
    hints = c(
        "Life's short, use R."
    )
    curr_hint = sample(hints, 1)
    packageStartupMessage(paste0("\n", curr_hint, "\n"))
}
