# LR

  <!-- badges: start -->
  [![R-CMD-check](https://github.com/yuxiao-66/625HW3-package/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yuxiao-66/625HW3-package/actions/workflows/R-CMD-check.yaml)
  <!-- badges: end -->
  
  <!-- badges: start -->
  [![codecov](https://codecov.io/gh/yuxiao-66/625HW3-package/graph/badge.svg?token=XKW936O9D0)](https://codecov.io/gh/yuxiao-66/625HW3-package)
  <!-- badges: end -->


## Introduction

### *1.What is linear regression?

[Linear Regression](https://en.wikipedia.org/wiki/Linear_regression) is a technique to study the linear association between two or more variables. In linear regression, the relationships are modeled using linear predictor functions whose unknown model parameters are estimated from the data. Such models are called [linear models](https://en.wikipedia.org/wiki/Linear_model). We can use linear model to do estimation, hypothesis testing and predictions. The most commonly used method of estimation is the [least squares](https://en.wikipedia.org/wiki/Least_squares) approach.

### *2."lm" function

The existing `stats::lm` in `R` is a powerful function that can fit linear models. It can be used to carry out regression, single stratum analysis of variance and analysis of covariance.

### *3. What can "LR" package do?

We develop a R package `LR`, which can provide some extra results of linear regression.

Users can obtain the following results easily by using `LR` package:

* Fit a linear regression model.
* Obtain the point estimates and standard errors of $\hat{\beta}$.
* Obtain the confidence interval(CI) of $\hat{\beta}$.
* Obtain the $R^2$ and adjusted-$R^2$.
* Obtain the $t$-statistics and $F$-statistics from hypothesis tests, and the corresponding $p$-value.

Furthermore, we include C++ functions in our package to improve computational efficiency.

## Installation

Install `LR` package with vignettes from github:

```
devtools::install_github("yuxiao-66/625HW3-package", build_vignettes = T)
```

Load package by:
```
library("LR")
```
