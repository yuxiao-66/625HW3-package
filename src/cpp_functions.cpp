#define Check_Headers
#include <RcppArmadillo.h>
#include <cmath>
#include <RcppArmadilloExtensions/sample.h>

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::plugins(cpp11)]]
using namespace Rcpp;
using namespace std;
using namespace arma;


//' Multiplies two doubles
//'
//' @param Y outcome vector
//' @param X predictors matrix
//' @return Regression results
// [[Rcpp::export]]
List LR_cpp(arma::vec &Y, arma::mat &X) {
  int n = X.n_rows;
  int p = X.n_cols;
  arma::mat XTX = X.t() * X;
  arma::mat XTY = X.t() * Y;
  arma::mat beta = inv(XTX) * XTY;
  arma::mat Yhat = X * beta;
  arma::mat res = Y - Yhat;
  double sigma2 = as_scalar(res.t() * res / (n - p));
  arma::mat se = sqrt(sigma2 * diagvec(inv(XTX)));
  arma::mat tstat = beta / se;
  arma::mat pval = 2 * (1 - normcdf(abs(tstat)));
  return List::create(Named("beta") = beta,
                      Named("epsilonhat") = res,
                      Named("sigma.squared") = sigma2,
                      Named("se") = se,
                      Named("tstat") = tstat,
                      Named("pval") = pval);
}
