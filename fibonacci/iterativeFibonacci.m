function fib = iterativeFibonacci(n)
  numbers = [0 1];

  n = n + 1;
  
  if n > 2
    for i = 3:n
      numbers(:, i) = numbers(:, i - 2) + numbers(:, i - 1);
    end
  end

  fib = numbers(:, n);
end
