function theta = normalEquation(X, y)
  % Computes values of parameter vector theta with
  % normal equation formula. 
  theta = pinv(X' * X) * X' * y;
end