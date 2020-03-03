
## 0.7.7
1. Optimize `group_dt`. First, it is faster than before because I use `[][]` instead of ` %>% `. (Using `%>%` for `.SD` is slow) Second, I design an alternative to use `.SD` directly in `group_dt`, which might improve the efficiency further.
2. Debug `filter_dt`.
3. Add `fill_na_dt` to fill NAs in data.table. Debug all missing functions. Examples are refreshed.
4. Debug `mutate_when`.
5. Add `complete_dt` to complete a data.frame like `tidyr::complete`.
6. Add `dummy_dt` to get dummy variables from columns.
7. Add `t_dt` to transpose data frame efficiently.
8. Remove the export of "as.data.table", add two functions:`as_dt` and `in_dt` to create a short cut to data.table facilities.
9. Add `unite_dt` and `separate_dt` for simple usage.

## 0.6.9
Date: 20200227
0. Reason for urgent update: The use of `show_tibble` violates the principals of programming. I hope this idea would not spread in the vignette. See changes in 4.
1. Improve `select_dt` to let it accept `a:c`-like inputs. Add example `iris %>% select_dt(Sepal.Length:Petal.Length)`. Moreover, now `select_dt` supports delete columns with `-` symbol.
2. Improve `group_dt` to let "by" parameter also accept list of variables, which means we could not use `mtcars %>% group_dt(by =list(vs,am),summarise_dt(avg = mean(mpg)))`.
3. Fix a few typos in description and vignettes.
4. Show the class of variables by default, using `options("datatable.print.class" = TRUE)`, and remove the inappropriate use of `show_tibble`. Details see <https://github.com/tidyverse/tibble/issues/716>.
5. Add `select_if_dt` function. Moreover, support negative conditional selection in `if_dt`.
6. Delete the vignette entitled "Example 5: Tibble", as this feature is not used any more.
7. Add vignette "Example 5:Fst" for better introduction of the feature.
8. Update vignette "Example 1:Basic usage".
 
## 0.6.6 
Date:20200224
1. Change all `print` and `cat` function to `message`.
2. Use `tempdir()` to write file and read it back in the example of `parse_fst`.
3. Fix the bug in `count_dt` and `add_count_dt` and add examples in the function.
4. Add `show_tibble` function, and now the package can use the printing form of tibble to get better information of the data.table. This is not used by default, but might be preferred for tidyverse users.
5. Remove all the unnecessary `\donttest` and use `\dontrun` when have to write files to directory, only to make an example of how to use it(refer to `utils::write.table` document). This should make the best example for real usage.
6. Add URL to Description file.
7. More vignettes added.

## 0.5.7
0. Major updates:(1) Change package name to `tidyfst` (according to the suggestions from CRAN);(2) Do not use `maditr` codes any more (change the description), based on `stringr` and `data.table` only; (3) Support `fst` package with tidy syntax; (4) Add 4 vignettes
1. Support 'fst' package in various ways (see functions end with "_fst")
2. Test the functions and get three vignettes for comparison
3. Totally support group computing with `group_dt` function
4. Correct various typos in the document
5. Rewrite `nest_by` and `unnest_col`. Did not use "_dt" name because they are different from the `tidyverse` API. They might be even more efficient and simple to use.
6. Add "negate" parameter to `select_dt` function.
7. Add `all_dt`,`at_dt` and `if_dt` functions for flexible mutate and summarise.


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
