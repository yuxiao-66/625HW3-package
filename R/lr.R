#'Fitting Linear Regression Models
#'
#'`lr()` serves the purpose of fitting linear regression models. It can be used for linear regression,
#'determination of confidence intervals for relevant parameters, computation of \eqn{R^2},
#'and facilitation of the F Test.
#'
#'@importFrom stats pf qt pt
#'@importFrom Rcpp evalCpp sourceCpp
#'
#'@import car ggplot2 bench
#'
#'@param Y a numeric vector, treated as outcome.
#'
#'@param X a numerical matrix, treated as predictors.
#'
#'@param CI logical, "TRUE" by default.
#'If "TRUE", the results will output the confidence interval of betas.
#'
#'@param Rcpp, "FALSE" by default.
#'If "TRUE", the function will use cpp code to speed up the computation.
#'
#'@param CI.level a numeric number specifying the alpha-level when calculate CIs of betas (0.95 by default).
#'Only use when "CI.beta = TRUE"
#'
#'@return A list contains statistics from the regression model
#'
#'@examples
#'  # fit a regression model
#'  lr(state.x77[, 4], state.x77[, c(1:3)], Rcpp = FALSE)
#'
#'@export
#'

lr <- function(Y, X, CI = TRUE, CI.level = 0.95, Rcpp = FALSE){
  ## define design matrix, outcome, dimensions ##
  X <- as.matrix(X)
  Y <- as.matrix(Y)
  n <- nrow(X)
  p <- ncol(X)

  X <- cbind(rep(1, n), X)  # add intercept to the design matrix
  p <- p + 1

  ## Estimation ##
  if (Rcpp == TRUE){
    fit <- LR_cpp(Y, X)
    betahat <- fit$beta
    se.beathat <- fit$se
    epsilonhat <- fit$epsilonhat
    sigma.squared <- fit$sigma.squared
    t.statistic <- fit$tstat
    p.value <- fit$pval
  } else {
    betahat <- solve(t(X) %*% X) %*% t(X) %*% Y
    Yhat <- X %*% betahat
    epsilonhat <- Y - Yhat # residual
    sigma.squared <- t(epsilonhat) %*% epsilonhat / (n-p) # estimated sigma^2 # MSE
    var.betahat <- diag(solve(t(X) %*% X)) * c(sigma.squared)
    se.beathat <- sqrt(var.betahat)
    ## Inference
    t.statistic <- c(betahat/se.beathat)
    p.value <- c(2 * (1 - pt(q = abs(t.statistic), df = n-p)))
  }

  coef.table <- as.data.frame(cbind(Estimate = c(betahat),
                                    Std_Err = se.beathat,
                                    t_statistic = t.statistic,
                                    p_value = p.value))
  colnames(coef.table) <- c("Estimate", "Std. Error", "t value", "Pr(>|t|)")
  output <- list(Coefficents = coef.table)

  ## Confidence Interval
  if (CI == TRUE){
    t <- qt(p = 1 - (1 - CI.level)/2, df = n-p)
    CI.upper <- betahat + t * se.beathat
    CI.lower <- betahat - t * se.beathat
    CI.table <- as.data.frame(cbind(CI.lower, CI.upper))
    colnames(CI.table) <- c("Lower", "Upper")
    output$Confidence_Interval <- CI.table
  }

  ## R^2 and adjusted R^2 ##
  SSY <- sum((Y - mean(Y))^2)
  SSE <- t(epsilonhat) %*% epsilonhat
  SSR <- SSY - SSE
  R.squared <- SSR/SSY
  Adjusted.R.squared <- 1 - (SSE/(n-p))/(SSY/(n-1))
  R.squared.tabel <- cbind(Multiple_R_squared = c(R.squared),
                           Adjusted_R_squared = c(Adjusted.R.squared))
  output$R_squared <- R.squared.tabel

  ## F statistics ##
  F.statistics <- (SSR/(p-1))/sigma.squared
  p.value <- 1 - pf(F.statistics, p-1, n-p)
  F.statistics.table <- cbind(F_statistics = F.statistics,
                              p_value = p.value,
                              df.ssr = p-1,
                              df.sse = n-p)
  colnames(F.statistics.table) <- c("F statistics", "p value", "df.ssr", "df.sse")
  output$F_statistics <- F.statistics.table
  return(output)
}
