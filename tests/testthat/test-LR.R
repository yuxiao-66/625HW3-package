
# use simulation data
test_that("lr works", {
  X <- matrix(rnorm(500), ncol = 5)
  beta <- c(1, 2, 3, 4, 5)
  Y <- X %*% beta + rnorm(100, sd = 0.1)
  coefs.actual <- as.vector(lr(Y, X)$Coefficents[, 1])
  coefs.expected <- as.vector(lm(Y ~ X)$coefficients)
  expect_equal(coefs.actual, coefs.expected)
})

# use real data
test_that("lr works", {
  X <- as.matrix(state.x77[, c(1:3)])
  Y <- state.x77[, 4]
  coefs.actual <- as.vector(lr(Y, X)$Coefficents[, 1])
  coefs.expected <- as.vector(lm(Y ~ X)$coefficients)
  expect_equal(coefs.actual, coefs.expected)
})

# check the CI
test_that("lr works", {
  X <- as.matrix(state.x77[, c(1:3)])
  Y <- state.x77[, 4]
  CI.actual.upper <- as.vector(lr(Y, X)$Confidence_Interval[, 1])
  CI.actual.lower <- as.vector(lr(Y, X)$Confidence_Interval[, 2])
  CI.expected.upper <- as.vector(confint(lm(Y ~ X))[, 1])
  CI.expected.lower <- as.vector(confint(lm(Y ~ X))[, 2])
  expect_equal(CI.actual.upper, CI.expected.upper)
  expect_equal(CI.actual.lower, CI.expected.lower)
})


# check the R squared
test_that("lr works", {
  X <- as.matrix(state.x77[, c(1:3)])
  Y <- state.x77[, 4]
  R.squared.actual <- as.vector(lr(Y, X)$R_squared[, 1])
  R.squared.expected <- as.vector(summary(lm(Y ~ X))$r.squared)
  expect_equal(R.squared.actual, R.squared.expected)
})


# check the adjusted R squared
test_that("lr works", {
  X <- as.matrix(state.x77[, c(1:3)])
  Y <- state.x77[, 4]
  Adjusted.R.squared.actual <- as.vector(lr(Y, X)$R_squared[, 2])
  Adjusted.R.squared.expected <- as.vector(summary(lm(Y ~ X))$adj.r.squared)
  expect_equal(Adjusted.R.squared.actual, Adjusted.R.squared.expected)
})

# check the F statistics
test_that("lr works", {
  X <- as.matrix(state.x77[, c(1:3)])
  Y <- state.x77[, 4]
  F.statistics.actual <- as.numeric(lr(Y, X)$F_statistics[1])
  F.statistics.expected <- as.numeric(summary(lm(Y ~ X))$fstatistic[1])
  expect_equal(F.statistics.actual, F.statistics.expected)
})

#check the cpp function
test_that("lr works", {
  X <- as.matrix(state.x77[, c(1:3)])
  Y <- state.x77[, 4]
  coefs.actual <- as.vector(lr(Y, X, Rcpp = T)$Coefficents[, 1])
  coefs.expected <- as.vector(lr(Y, X, Rcpp = F)$Coefficents[, 1])
  expect_equal(coefs.actual, coefs.expected)
})


