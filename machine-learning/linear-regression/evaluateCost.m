function cost = evaluateCost(X, y, theta)
  cost = (1 / ( 2 * size(X, 1))) * (X * theta - y)' * (X * theta - y);
end