
## 0.5.7
0. Major updates:(1) Change package name to `tidyfst` (according to the suggestions from CRAN);(2) Do not use `maditr` codes any more (change the description), based on `stringr` and `data.table` only; (3) Support `fst` package with tidy syntax; (4) Add 4 vignettes
1. Support 'fst' package in various ways (see functions end with "_fst")
2. Test the functions and get three vignettes for comparison
3. Totally support group computing with `group_dt` function
4. Correct various typos in the document
5. Rewrite `nest_by` and `unnest_col`. Did not use "_dt" name because they are different from the `tidyverse` API. They might be even more efficient and simple to use.
6. Add "negate" parameter to `select_dt` function.
7. Add `all_dt`,`at_dt` and `if_dt` functions for flexible mutate and summarise.
8. Fix the bug in `count_dt` and `add_count_dt` and add examples in the function.
9. Add `show_tibble` function, and now the package can use the printing form of tibble to get better information of the data.table. This is not used by default, but might be preferred for tidyverse users.

## 0.3.1
Fix some bugs and add a vignette.

## 0.3.0
Rewrite all functions and use only `data.table` and `stringr` as imported packages.
Have changed the license to MIT.
This time, `tidydt` is lightweight,efficient and powerful. It is totally different from the previous version in many ways.
The previous version would be archived in <https://github.com/hope-data-science/tidydt0>.

## 0.2.1
Some issue seems to happen, check <https://github.com/hope-data-science/tidydt0/issues/1>. Hope to get an offical answer from CRAN. 
Done in the mailing list, keep moving. [20200129]

## v0.2.0 20200123
1. Use new API for `rename_dt`, more like the `rename` in `dplyr`.
2. Change some API name, e.g. `topn_dt` to `top_n_dt`.
3. Add functions to deal with missing values(`replace_na_dt`,`drop_na_dt`).
4. Change the `on_attach.R` file to change the hints.
5. Add `pull_dt`, which I use a lot and so may many others.
6. Add `mutate_when` for another advanced `case_when` utility.
7. Fix according to CRAN suggestions.

## Test environments
* local OS X install, R 3.6.2
* ubuntu 14.04 (on travis-ci), R 3.6.2
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
