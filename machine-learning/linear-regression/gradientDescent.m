function [theta, J_history] = gradientDescent(
    X, y, theta, alfa, iterations
)
  % Setup empty vector to keep track of how our
  % cost function changes due to continiously update
  % to parameter vector theta.
  J_history = zeros(iterations, 1);

  for i = 1:iterations
    % Repeadetly update value of parmeter vector theta by vectorized
    % version of gradient descent formula.
    theta = theta - (alfa / size(X, 1)) * (X' * (X * theta - y));

    % Memoize cost for current value of parameter vector theta.
    J_history(i) = evaluateCost(X, y, theta); 
  end
end
