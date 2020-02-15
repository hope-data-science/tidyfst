
# for develop

library(pacman)
p_load(devtools,usethis,roxygen2,pkgdown,badger)
p_load(fst,stringr,data.table)

## general
as_dt = function(data){
  if(!is.data.frame(data)) stop("Only a data.frame could be received.")
  as.data.table(data)
}

# use_r("global_setting")
# use_r("select_dt")
# use_r("filter_dt")
# use_r("arrange_dt")

document()
install(upgrade = "never",dependencies = F)
#install(quick = T)
.rs.restartR()
rm(list = ls())
library(tidyfst)

library(tidydt)

options(pkgdown.internet = F)
build_site()

submit_cran()

# https://github.com/GuangchuangYu/badger
badge_devel("guangchuangyu/ggtree", "blue")
badge_devel("hope-data-science/tidydt", "blue")

a = "dl-keras-tf"
stringr::str_glue("wget -c \"https://codeload.github.com/rstudio-conf-2020/{a}/zip/master\" -O {a}")

use_logo(file.choose())
use_vignette(name = "Introduction",title = "Using data.table the tidy way")

iris %>%
  mutate_dt(group = Species,sl = Sepal.Length,sw = Sepal.Width) %>%
  select_dt(group,sl,sw) %>%
  filter_dt(sl > 5) %>%
  arrange_dt(group,sl) %>%
  distinct_dt(sl,keep_all = T) %>%
  summarise_dt(sw = max(sw),by = group)
