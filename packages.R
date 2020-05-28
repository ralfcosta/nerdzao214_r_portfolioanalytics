install.packages(c("PortfolioAnalytics",
                   "quantmod",
                   "ROI", 
                   "ROI.plugin.glpk", 
                   "ROI.plugin.quadprog",
                   "tidyquant",
                   "tidiverse",
                   "timetk"))

library(tidyverse, warn.conflicts = F)
library(tbl2xts, warn.conflicts = F)
library(timetk, warn.conflicts = F)

library(tidyquant, warn.conflicts = F)
library(quantmod, warn.conflicts = F)

library(PortfolioAnalytics, warn.conflicts = F)
library(ROI, warn.conflicts = F)
library(ROI.plugin.glpk, warn.conflicts = F)
library(ROI.plugin.quadprog, warn.conflicts = F)