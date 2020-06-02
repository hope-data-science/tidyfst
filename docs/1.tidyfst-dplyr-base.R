
# https://cran.r-project.org/web/packages/dplyr/vignettes/base.html

library(pacman)
p_load(dplyr,tidyfst,reprex)

#arrange排序######################################################
# 顺序
mtcars %>% arrange_dt(cyl, disp)
# 倒序
mtcars %>% arrange_dt(-cyl, -disp)

#distinct去重######################################################
# tidyfst兼容tibble
df <- tibble(
  x = sample(10, 100, rep = TRUE),
  y = sample(10, 100, rep = TRUE)
)
# 只保留目标列
df %>% distinct_dt(x)
# 去重同时保留其他列
df %>% distinct_dt(x,.keep_all = T)

#filter筛选######################################################
starwars %>% filter_dt(species == "Human")
starwars %>% filter_dt(mass > 1000)
starwars %>% filter_dt(hair_color == "none" & eye_color == "black")

#mutate创建或转化######################################################
df %>% #如果要用新生成的变量需要再加一步
  mutate_dt(z = x + y) %>% 
  mutate_dt(z2 = z ^ 2)
# 分组转化
gf <- tibble(g = c(1, 1, 2, 2), x = c(0.5, 1.5, 2.5, 3.5))
gf %>%  #mutate_dt中自带分组参数by
  mutate_dt(x_mean = mean(x), x_rank = rank(x),by = g)

#pull获得单列内容######################################################
mtcars %>% pull_dt(1)
mtcars %>% pull_dt(cyl)

#relocate更改列顺序######################################################
# 把gear和carb移动到最前面
mtcars %>% relocate_dt(gear, carb) 
# 把gear和carb移动到最后面
mtcars %>% relocate_dt(mpg, cyl, where = "last") 

#renmae更改列名称####################################################
iris %>% #不支持根据位置更改列名，因为容易引起歧义
  rename_dt(sepal_length = Sepal.Length, sepal_width = Sepal.Width)
# 如果需要把所有变量名改为大写
iris %>% rename_with_dt(toupper)

#select选择列####################################################
iris %>% select_dt(1:3)
iris %>% select_dt(Species, Sepal.Length)
iris %>% select_dt("^Petal")
iris %>% select_dt(is.factor)

#summarise汇总####################################################
mtcars %>%  #分组汇总，不需要顾虑目前所在分组
  summarise_dt(mean = mean(disp), n = .N,by = cyl)

#slice根据位置选择行####################################################
slice_dt(mtcars, 25:.N)

#join连接###################################
band_members %>% semi_join_dt(band_instruments)
band_members %>% anti_join_dt(band_instruments)


