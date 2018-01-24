function cost = evaluateCost(X, y, theta)
  m = size(X, 1);
  cost = 1 / (2 * m) * (X * theta - y)' * (X * theta - y);
end
