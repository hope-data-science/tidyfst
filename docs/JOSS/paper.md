---
title: 'tidyfst: Tidy Verbs for Fast Data Manipulation'
tags:

  - R

  - data.table

  - data aggregation

  - data manipulation

  - dplyr
 
  - tidyfst

authors:

  - name: Tian-Yuan Huang
    orcid: 0000-0002-4151-3764
    affiliation: "1" 
  - name: Bin Zhao
    orcid: 0000-0002-3530-2469
    affiliation: "1" 
affiliations:
    
 - name: School of Life Science, Fudan University
   index: 1
date: 3 June 2020
bibliography: paper.bib
---




# Summary

The tidyfst package [@Huang-488] is an R package [@R-Core-Team-479] for fast data manipulation in tidy syntax. The top-level design is inherited from tidy data structure proposed by Hadley Wickham [@Wickham-458], which are: (1) each variable is a column; (2) each observation is a row; (3) each type of observational unit is a table. Moreover, the function names as well as parameter settings are very much borrowed from dplyr [@WickhamFrancois-481] and tidyr [@WickhamHenry-490], reducing the learning cost for tidyverse [@WickhamAverick-493] users. At the bottom, tidyfst is backed by the high performance package data.table [@DowleSrinivasan-480], which is speedy, stable (with little dependency), memory efficient and feature rich.

Sharing similar goals, both data.table and dplyr have gained much popularity among R users. Their features have been compared widely in the community, with pros and cons suggested in ideas and tested in examples (e.g. <https://stackoverflow.com/questions/21435339/data-table-vs-dplyr-can-one-do-something-well-the-other-cant-or-does-poorly/27840349#27840349>). While some opinions might be objective, consensus could be made on at least two points: (1) data.table could handle data manipulation in less time than dplyr; (2) dplyr has a possibly more user-friendly syntax for learning and communication than data.table. The tidyfst package is designed to combine the merits of dplyr and data.table, so as to provide a suite of tidy verbs for fast data manipulation.

Note that tidyfst is neither the only nor the first package to make trade-offs between data.table and dplyr. Many similar works have been published on CRAN, including dtplyr [@Henry-482], maditr [@Demin-484], table.express [@Sarda-Espinosa-486], tidyfast [@Barrett-487], tidytable [@Fairbanks-491], etc. Nevertheless, tidyfst holds its unique features that no alternative compares so far. One important feature is the support of data manipulation on fst file supported by fst package [@Klik-483]. It means the users could parse the data frames stored in disk first and load the minimum needed subsets to compute on. Other features include convenient column selection in various forms (regular expression, index, etc.), more concise parameter settings and new verbs for frequently-used data operations. 

Furthermore, to save memory and lift speed to a higher level, tidyft has been designed, which utilizes modification by reference feature from data.table whenever possible. The tidyfst and tidyft share similar parameter settings, but function names of tidyft are even simpler (functions in tidyfst usually ends with “_dt”, which tidyft does not). Though tidyft [@Huang-489] has better performance than tidyfst, it is less robust and demands the users to have deeper understanding on the concepts of modification by reference in data.table. 

Hopefully, tidyfst could provide some reference for the design of dplyr and bring convenience to even data.table users by wrapping some complicated operations in concise steps.



# Acknowledgement

The author of [maditr](https://github.com/gdemin/maditr), [Gregory Demin](https://github.com/gdemin) and the author of [fst](https://github.com/fstpackage/fst), [Marcus Klik](https://github.com/MarcusKlik) have helped us a lot in the development of this work. It is so lucky to have them (and many other selfless contributors) in the same open source community of R.

# References
