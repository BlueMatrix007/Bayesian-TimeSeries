data {
  int<lower=1> n;
  int<lower=1> npred;
  vector[n] y;
}

parameters {
  vector[n] mu;
  vector[n-1] v;

  positive_ordered[3] sigma;
}
transformed parameters {
  vector[n] yhat;
  yhat = mu;
}
model {
  v[1] ~ normal(0, sigma[1]);
  for(t in 2:n-1)
    v[t] ~ normal(v[t-1], sigma[1]);

  mu[1] ~ normal(y[1], sigma[3]);
  for(t in 2:n)
    mu[t] ~ normal(mu[t-1] + v[t-1], sigma[3]);

  y ~ normal(yhat, sigma[2]);
  sigma ~ student_t(1, 0, 1);
}

generated quantities{
vector[npred] ypred;
vector[npred+1] mupred;
vector[npred+1] vpred;

vpred[1] = normal_rng(v[n-1],sigma[1]);
mupred[1] = normal_rng(mu[n]+v[n-1],sigma[3]);

for(np in 1:npred){
  ypred[np] = normal_rng(mupred[np],sigma[2]);
  mupred[np+1] = normal_rng(mupred[np]+vpred[np],sigma[3]);
  vpred[np+1] = normal_rng(vpred[np],sigma[1]);
}
}

