function [Xnorm, mu, sigma] = featureNormalize(X)
  mu = mean(X);

  Xnorm = bsxfun(@minus, X, mu);

  sigma = std(Xnorm);

  Xnorm = bsxfun(@rdivide, Xnorm, sigma);
end
