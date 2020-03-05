# tidyfst: Tidy Verbs for Fast Data Manipulation<img src="man/figures/logo.png" align="right" alt="" width="120" />

[![](https://www.r-pkg.org/badges/version/tidyfst?color=orange)](https://cran.r-project.org/package=tidyfst) [![](https://img.shields.io/badge/devel%20version-0.7.7-yellow.svg)](https://github.com/hope-data-science/tidyfst) ![](http://cranlogs.r-pkg.org/badges/grand-total/tidyfst?color=green)  ![](https://img.shields.io/badge/lifecycle-maturing-purple.svg) [![](https://img.shields.io/github/last-commit/hope-data-science/tidyfst.svg)](https://github.com/hope-data-science/tidyfst/commits/master) [![DOI](https://zenodo.org/badge/240626994.svg)](https://zenodo.org/badge/latestdoi/240626994)





## Overview

*tidyfst* is a toolkit of tidy data manipulation verbs with *data.table* as the backend . Combining the merits of syntax elegance from *dplyr* and computing performance from *data.table*,  *tidyfst* intends to provide users with state-of-the-art data manipulation tools with least pain. This package is inspired by *maditr*, but follows a different philosophy of design,  such as prohibiting in place replacement and used a "_dt" suffix API. Also, *tidyfst* would introduce more tidy data verbs from other packages, including but not limited to *tidyverse* and *data.table*. If you are a *dplyr* user but have to use *data.table* for speedy computation,  or *data.table* user looking for readable coding syntax, *tidyfst* is designed for you (and me of course). For further details and tutorials, see [vignettes](https://hope-data-science.github.io/tidyfst/).

Enjoy the data science in *tidyfst* !



## Features

- Receives any data.frame (tibble/data.table/data.frame) and returns a data.table.
- Show the variable class of data.table as default.
- Never use in place replacement. 
- Use suffix rather than prefix to increase the efficiency (especially when you have IDE with automatic code completion).
- More flexible verbs for big data manipulation.
- For some useful functions in *data.table*, if *tidyfst* could not optimize the API syntax, never rewrite but export them directly to guarantee the performance.
- Supporting data importing and parsing with *fst*, details see [parse_fst/select_fst/filter_fst](https://hope-data-science.github.io/tidyfst/reference/fst.html) and [import_fst/export_fst](https://hope-data-science.github.io/tidyfst/reference/fst_io.html).
- Flagship functions: [group_dt](https://hope-data-science.github.io/tidyfst/reference/group_dt.html), [unnest_dt](https://hope-data-science.github.io/tidyfst/reference/unnest_dt.html), [mutate_when](https://hope-data-science.github.io/tidyfst/reference/mutate_when.html), etc.



## Installation

```R
install.packages("tidyfst")
# or
devtools::install_github("hope-data-science/tidyfst")
```



## Example

```R
library(tidyfst)

iris %>%
  mutate_dt(group = Species,sl = Sepal.Length,sw = Sepal.Width) %>%
  select_dt(group,sl,sw) %>%
  filter_dt(sl > 5) %>%
  arrange_dt(group,sl) %>%
  distinct_dt(sl,.keep_all = T) %>%
  summarise_dt(sw = max(sw),by = group)
#>         group  sw
#>        <fctr> <num>
#> 1:     setosa 4.4
#> 2: versicolor 3.4
#> 3:  virginica 3.8

mtcars %>%
  group_dt(by =.(vs,am),
  summarise_dt(avg = mean(mpg)))
#>    vs am      avg
#>   <num> <num>    <num>
#> 1:  0  1 19.75000
#> 2:  1  1 28.37143
#> 3:  1  0 20.74286
#> 4:  0  0 15.05000

iris[3:8,] %>%
  mutate_when(Petal.Width == .2,
              one = 1,Sepal.Length=2)
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species one
#>          <num>       <num>        <num>       <num>  <fctr> <num>
#> 1:          2.0         3.2          1.3         0.2  setosa   1
#> 2:          2.0         3.1          1.5         0.2  setosa   1
#> 3:          2.0         3.6          1.4         0.2  setosa   1
#> 4:          5.4         3.9          1.7         0.4  setosa  NA
#> 5:          4.6         3.4          1.4         0.3  setosa  NA
#> 6:          2.0         3.4          1.5         0.2  setosa   1


```



## Future plans

*unnest_dt* is now fast enough to beat the *tidyr::unnest*, but the *nest_dt* function would build a nested data.table with *data.table* inside. How to use such data structure is remained to be seen, and the performance is still to be explored.

*tidyfst* will keep up with the [updates](https://github.com/Rdatatable/data.table/blob/master/NEWS.md) of *data.table* , in the next step would introduce more new features to improve the performance and flexibility to facilitate fast data manipulation in tidy syntax. 

## Vignettes
- [Example 1: Basic usage](https://hope-data-science.github.io/tidyfst/articles/example1_intro.html)
- [Example 2: Join tables](https://hope-data-science.github.io/tidyfst/articles/example2_join.html)
- [Example 3: Reshape](https://hope-data-science.github.io/tidyfst/articles/example3_reshape.html)
- [Example 4: Nest](https://hope-data-science.github.io/tidyfst/articles/example4_nest.html)
- [Example 5: Fst](https://hope-data-science.github.io/tidyfst/articles/example5_fst.html) 
- [Example 6: Dt](https://hope-data-science.github.io/tidyfst/articles/example6_dt.html) 

## Related work

- [maditr](https://github.com/gdemin/maditr)
- [fst](https://github.com/fstpackage/fst)
- [data.table](https://github.com/Rdatatable/data.table)
- [dplyr](https://github.com/tidyverse/dplyr)
- [dtplyr](https://github.com/tidyverse/dtplyr)
- [table.express](https://github.com/asardaes/table.express)
- [tidyfast](https://github.com/TysonStanley/tidyfast)
- [tidytable](https://github.com/markfairbanks/tidytable)



## Acknowledgement

The author of [maditr](https://github.com/gdemin/maditr), [Gregory Demin](https://github.com/gdemin) and the author of [fst](https://github.com/fstpackage/fst), [Marcus Klik](https://github.com/MarcusKlik) have helped me a lot in the development of this work. It is so lucky to have them (and many other selfless contributors) in the same open source community of R.

