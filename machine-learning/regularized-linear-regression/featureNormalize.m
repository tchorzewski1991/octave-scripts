function [Xnorm, mu, sigma] = featureNormalize(X)
  % Computes mean for given dataset.
  mu = mean(X);

  % Applies binary minus() function to each element in dataset.
  Xnorm = bsxfun(@minus, X, mu);

  % Computes standard deviations for given dataset.
  sigma = std(Xnorm);

  % Applies binary rdivide() function to each element in dataset.
  Xnorm = bsxfun(@rdivide, Xnorm, sigma);
end
