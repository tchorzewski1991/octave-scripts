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
  divisor = 6;

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

  % Plotting data is always essential step to understand what is the
  % problem which we stand in front of. Unfortunately it is quite hard
  % to visualize data distribution in more then two-dimenisional vector
  % space.

  if !(size(data, 2) > 2)

    % Sets distinguishable styles for plots.
    styles  = ['rx'; 'kx'; 'bx'];

    % Sets dictionary structure to keep all datasets accessible
    % under one variable.
    dataTree = struct (
      'tr', struct (
        'features', tr_X, 'labels', tr_y, 'legend', 'Training set'
      ),
      'cv', struct (
        'features', cv_X, 'labels', cv_y, 'legend', 'Cross-v set'
      ),
      'te', struct (
        'features', te_X, 'labels', te_y, 'legend', 'Test set'
      )
    );

    % Sets identifiers for accessing dataTree.
    identifiers = ['tr'; 'cv'; 'te'];

    for i = 1:length(identifiers)
      % Switch specific slot on subplot space.
      subplot(3, 1, i);

      % References to specific data from dataTree.
      node = dataTree.(identifiers(i, :));

      % Calls function responsible for plotting specific data.
      plotDataDistribution( ...
        node.('features'),
        node.('labels'),
        node.('legend'),
        styles(i, :)
      );

      % Prevents current figure from closing to allow for adding another plots
      % in future iterations.
      hold on;

      % Saves image file with actual subplot space.
      if i == 3
        print('./images/data-distribution.png', '-S800,600');
      end
    end
  end

% ========================================================================

  % Model selection algorithm refers to the process of automatic choose
  % of regularization parameter lambda and order of polynomial for our
  % hypothesis.

  % Sets empty container for regularization parameters lambda.
  lambdas = zeros(20, 1);

  lambdasLength = length(lambdas);

  % Iteration will cover set of 20 different values for regularization
  % parameter lambda. Good practise is to use multiples of 0.02
  % up to bigger values.
  for i = 1:lambdasLength
    lambdas(i, :) = lambdas(i, :) .+ 2 ^ i / 100;
  end

  % Sets maximum value of degree for hypothesis polynomial.
  degree = 8;

  % Sets initial histogram for current lambda - degree cost.
  histogramForLambdasDegreeCost = zeros(lambdasLength, degree);

  % Sets options structure for specialized fminunc() function.
  options = optimset('GradObj', 'on', 'MaxIter', 400);

  % Sets annonymous function responsible for creating design matrix.
  designMatrix = @(data) ( [ ones(size(data, 1), 1), data ] );

  % Sets annonymous function responsible for creating initial vector theta.
  initialTheta = @(data) ( zeros(size(data, 2), 1) );

  for i = 1:lambdasLength
    for j = 1:degree

      poly_tr_X = producePolynomial(tr_X, tr_y, j);

      [poly_tr_X, mu, sigma] = featureNormalize(poly_tr_X);

      poly_tr_X = designMatrix(poly_tr_X);

      lambda = lambdas(i, 1);
      theta = initialTheta(poly_tr_X);

      [optTheta, cost, status] = ...
        fminunc(
          @(t)(regularizedCost(poly_tr_X, tr_y, t, lambda)),
          theta,
          options
        );

      poly_cv_X = producePolynomial(cv_X, cv_y, j);

      poly_cv_X = bsxfun(@minus, poly_cv_X, mu);
      poly_cv_X = bsxfun(@rdivide, poly_cv_X, sigma);

      poly_cv_X = designMatrix(poly_cv_X);

      cv_cost = evaluateCost(poly_cv_X, cv_y, optTheta);

      histogramForLambdasDegreeCost(i, j) = cv_cost;
    end
  end
