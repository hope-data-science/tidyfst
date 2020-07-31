
# for develop

library(pacman)
p_load(devtools,usethis,roxygen2,pkgdown,badger)
p_load(fst,stringr,data.table,tidyfst,testthat)

# use_test("")

# use_r("global_setting")
# use_r("select_dt")
# use_r("filter_dt")
# use_r("arrange_dt")

document()
install(upgrade = "never",dependencies = F)
#install(upgrade = "never",dependencies = F,quick = T)
#install(quick = T)
.rs.restartR()
rm(list = ls())
library(tidyfst)

# library(tidydt)

options(pkgdown.internet = F)
options(rmarkdown.html_vignette.check_title = FALSE)
build_site()

submit_cran()


f <- file.path(tempdir(), "mypackage_thefile.csv")
if (file.exists(f)) {
  d <- read.csv(f)
} else {
  # download it and save to f
}

# https://github.com/GuangchuangYu/badger
badge_devel("guangchuangyu/ggtree", "blue")
badge_devel("hope-data-science/tidydt", "blue")

a = "dl-keras-tf"
stringr::str_glue("wget -c \"https://codeload.github.com/rstudio-conf-2020/{a}/zip/master\" -O {a}")

a = "rstudio/cheatsheets"
stringr::str_glue("wget -c \"https://codeload.github.com/{a}/zip/master\" -O cheatsheet.zip")

use_logo(file.choose())
use_vignette(name = "Introduction",title = "Using data.table the tidy way")

iris %>%
  mutate_dt(group = Species,sl = Sepal.Length,sw = Sepal.Width) %>%
  select_dt(group,sl,sw) %>%
  filter_dt(sl > 5) %>%
  arrange_dt(group,sl) %>%
  distinct_dt(sl,keep_all = T) %>%
  summarise_dt(sw = max(sw),by = group)




usethis::create_package









library(cranlogs)
library(tidyfst)

end_date = "2020-04-09"

cran_downloads(package = "tidyfst", from = "2020-02-10",to = end_date) -> a

cran_downloads(package = "tidytable", from = "2020-02-10",to = end_date) -> b

a %>%
  inner_join_dt(b,by = "date") %>%
  filter_dt(count.x != 0 & count.y != 0) %>%
  summarise_dt(sum.x = sum(count.x),sum.y = sum(count.y))
