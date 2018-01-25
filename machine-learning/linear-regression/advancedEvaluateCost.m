function [cost, gradient] = advancedEvaluateCost(X, y, theta)
  cost = evaluateCost(X, y, theta);
  gradient = (1 / size(X, 1)) * (X' * (X * theta - y));
end