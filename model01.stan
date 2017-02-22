data {
  int<lower=1> n;
  int<lower=1> npred;
  vector[n] y;
}

parameters {
  vector[n] mu;
  real<lower=0> sigma_level;
  real<lower=0> sigma_irreg;
}


transformed parameters {
  vector[n] yhat;
  yhat = mu;
}

model {
  for(t in 2:n)
    mu[t] ~ normal(mu[t-1], sigma_level);
  y ~ normal(yhat, sigma_irreg);
}

generated quantities{
vector[npred] ypred;
vector[npred+1] mupred;

mupred[1] = normal_rng(mu[n],sigma_level);
for(np in 1:npred){
  ypred[np] = normal_rng(mupred[np],sigma_irreg);
  mupred[np+1] = normal_rng(mupred[np],sigma_level);
}
}

