function fib = recursiveFibonacci(n)
  if ( n < 2 )
    fib = n;
  else
    fib = recursiveFibonacci(n-1) + recursiveFibonacci(n-2);
  end
end