## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----robustness-demo----------------------------------------------------------
library(robscale)

x_clean <- c(2.1, 2.3, 2.0, 2.4, 2.2, 2.1, 2.3, 1.9)
x_contaminated <- c(x_clean, 200)   # one recording error

sd(x_clean)
sd(x_contaminated)   # collapses

gmd(x_clean)
gmd(x_contaminated)  # unaffected

qn(x_clean)
qn(x_contaminated)   # unaffected

## ----quick-demo---------------------------------------------------------------
library(robscale)

set.seed(42)
x <- c(rnorm(20), 50)   # 20 clean observations + one outlier

scale_robust(x)              # auto-selects best strategy
scale_robust(x, ci = TRUE)   # with confidence interval

data.frame(
  estimator = c("sd", "sd_c4", "gmd", "qn", "mad_scaled"),
  value = round(c(sd(x), sd_c4(x), gmd(x), qn(x), mad_scaled(x)), 4)
)

## ----ensemble-----------------------------------------------------------------
set.seed(1)
x_small <- rnorm(12)
scale_robust(x_small)              # ensemble (n = 12 < 20)
scale_robust(x_small, ci = TRUE)   # BCa bootstrap CI

## ----auto-switch--------------------------------------------------------------
x_large <- rnorm(500)
scale_robust(x_large)   # equivalent to gmd(x_large)

## ----explicit-method----------------------------------------------------------
scale_robust(x_small, method = "qn")       # force Qn
scale_robust(x_small, method = "robScale") # force M-scale
scale_robust(x_small, auto_switch = FALSE) # keep ensemble at any n

## ----sd-c4--------------------------------------------------------------------
x <- c(1.2, 0.8, 1.5, 0.9, 1.1)
sd_c4(x)              # unbiased under normality
sd(x)                 # biased downward for small n
sd_c4(x, ci = TRUE)

## ----gmd----------------------------------------------------------------------
gmd(c(1, 2, 3, 5, 7, 8))
gmd(c(1, 2, 3, 5, 7, 8), ci = TRUE)

## ----adm----------------------------------------------------------------------
adm(c(1, 2, 3, 5, 7, 8))

## ----qn-----------------------------------------------------------------------
qn(c(1, 2, 3, 5, 7, 8))
qn(c(1, 2, 3, 5, 7, 8), ci = TRUE)

## ----sn-----------------------------------------------------------------------
sn(c(1, 2, 3, 5, 7, 8))
sn(c(1, 2, 3, 5, 7, 8), ci = TRUE)

## ----iqr-mad------------------------------------------------------------------
iqr_scaled(c(1, 2, 3, 5, 7, 8))
mad_scaled(c(1, 2, 3, 5, 7, 8))

## ----robloc-------------------------------------------------------------------
robLoc(c(1, 2, 3, 5, 7, 8))
robLoc(c(1, 2, 3), scale = 1.5)   # known scale enables n = 3

## ----robscale-----------------------------------------------------------------
robScale(c(1, 2, 3, 5, 7, 8))
robScale(c(5, 5, 5, 5, 6), fallback = "na")   # revss compatibility
robScale(c(1, 2, 3, 5, 7, 8), ci = TRUE)

## ----ci-----------------------------------------------------------------------
# Analytical CI (chi-squared for sd_c4, ARE-based for others)
sd_c4(c(1, 2, 3, 5, 7, 8), ci = TRUE)
gmd(c(1, 2, 3, 5, 7, 8), ci = TRUE)

# BCa bootstrap CI for scale_robust() ensemble
set.seed(42)
x_small <- rnorm(10)
scale_robust(x_small, ci = TRUE, n_boot = 500)

## ----revss-compat, eval = requireNamespace("revss", quietly = TRUE)-----------
x <- c(1.2, 2.4, 3.1, 5.5, 7.0)
revss::robScale(x)
robscale::robScale(x)   # same value

