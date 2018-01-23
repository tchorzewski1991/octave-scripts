% Regularized Linear Regression

% Regularization -
%   Is a process of adding additional terms to the cost function,
%   often to introduce preference for simpler model. It turns out
%   that linear dependency between input features and dependent
%   output is really rare case in the 'real world' relationships.
%   Much more 'right' solution to the problem could be using higher
%   order polynomial model. It needs to be taken into consideration
%   that process of selecting higher order polynomial could be
%   involving and time consuming. It is not an easy task to pick in
%   advance which parameter is less unlikely to be relevant. The
%   'regularization' process refers to idea of shrinking them all.

%========================================================================

  % Clears current workspace
  clear; close all; clc;

  % Loads all given data as a matrix.
  % File 'data.dat' contains two columns:
  %   - first column represents age of employee
  %   - second column represents achieved income in 1000's $.

  data = load('data.dat');

% ========================================================================

  % We would like to implement Model Selection Algorithm, so dividing
  % our dataset is essential step. The mentioned algorithm refers to
  % process of automated selection of regularization parameter lambda,
  % as well, as the degree of polynomial, which describes data best.

  % We need to extract three separate datasets:
  %   - Trainig set.
  %   - Cross-validation set.
  %   - Test set.

  tr_X = []; tr_y = [];
  cv_X = []; cv_y = [];
  te_X = []; te_y = [];

  % We want to implement training - cross-validation - test sets in
  % relation 60% - 20% - 20%, so setting up correct divisor is required.
  divisor = 6

  for i = 1:(size(data, 1) / divisor)
    down = i * divisor - (divisor - 1);
    up   = i * divisor;

    for j = down:up
      rowData = data(j, 1);
      rowLabel    = data(j, 2);

      if j <= up - 2
        tr_X = [tr_X; rowData];
        tr_y = [tr_y; rowLabel];
      elseif j == up - 1
        cv_X = [cv_X; rowData];
        cv_y = [cv_y; rowLabel];
      else
        te_X = [te_X; rowData];
        te_y = [te_y; rowLabel];
      end
    end
  end

% ========================================================================
