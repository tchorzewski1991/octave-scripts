function fib = iterativeFibonacci(n)
  % Setup initial values for fibonacci numbers as a two dimensional vector.
  numbers = [0 1];

  % Reassign given n as we need to take into account that octave vectors
  % are indexed from 1, rather than 0.
  n = n + 1;
  
  if n > 2
    for i = 3:n
      numbers(:, i) = numbers(:, i - 2) + numbers(:, i - 1);
    end
  end

  % Return last element of vector v
  fib = numbers(:, n);
end
