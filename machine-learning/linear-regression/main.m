% Linear Regression

% Linear Regression refers to model for modeling relationship
% between dependent output variable y (frequently called as a 'target')
% and one, or more explanatory variables or inputs called 'features'
% as a linear function.

% It turns out that linear dependency between input features and
% expected dependent output is not the best reflection of the
% 'real world' relationships. We call that as an example of
% underfitting or a 'high bias'. It is really rare case that
% linear model will generalize well on unseen data. It is always
% better to invent higher order polynomial model and try to
% regularize it. However, linear regression tends to be great
% starting point for adventure with machine learning.

% See https://en.wikipedia.org/wiki/Linear_regression for more reference.

% ========================================================================

% Clear current workspace.
  clear ; close all; clc

% Loads all given data as a matrix.
% This is the place where you can provide your own data.
  data = load('data.dat');

% ========================================================================

% Prepare training/test data for future model feed/examination.
%
% training_test_threshold -
%   Represents the percentage ratio of training data to test data.
%
% training_data -
%   Examples that we will use to train the model.
%
% test_data -
%   Examples that we will use to test overall accuracy of the
%   trained model.
%
  training_test_threshold = 0.75;

  training_data = data(
    1:(floor(size(data, 1) * training_test_threshold)), :
  );

  test_data = data(
    (ceil(size(data, 1) * training_test_threshold):size(data, 1)), :
  );

% ========================================================================

% Extracts features/labels with matrix specific operations.
%
% X -
%   This is a matrix, that represents combination of examples and
%   their associated features (vector in case of univariate linear
%   regression). It contains m x n dimensions, where:
%     m - is the total number of examples
%     n - is the total number of unique properties
%         (independent features) of examined entity
%         (e.x size of hause)
%
% y -
%   This is a vector with m x 1 dimensions where each dimension
%   refers to actual label value for corresponding example
%   (e.x price of house)
%
% Note:
%   Dimensions for X, y matricies are resolved dynamically,
%   so it will be possible to compute not only univariate, but
%   also multivariate linear regression.

  % Sets X, y, m for trainig data.
  temp = size(training_data, 2);

  tr_X = training_data(:, 1:(temp - 1));
  tr_y = training_data(:, temp);
  tr_m = size(tr_X, 1);

  % We don't need temp any more.
  clear temp;

  % Sets X, y, m for test data.
  temp = size(test_data, 2);

  te_X = test_data(:, 1:(temp - 1));
  te_y = test_data(:, temp);
  te_m = size(te_X, 1);

  % We don't need temp any more.
  clear temp;

  % Expands actual feature matricies with intercept term.
  % This step is also called as creation of 'design matrix'.
  % It is essential to correctly implement normal-equation and
  % gradient-descent techniques.
  dtr_X = [ones(tr_m, 1) tr_X];
  dte_X = [ones(te_m, 1) te_X];

% ========================================================================

% Technique - Normal Equation
%
% Computes parameter vector theta analytically.
% The Normal Equation solution is based on least squared solution
% for linear regression and it tends to be very effective, especially
% in case where we have small amount of featues.
% https://en.wikipedia.org/wiki/Linear_least_squares_(mathematics)

theta_from_normal_equation = normalEquation(dtr_X, tr_y);

% ========================================================================

% Technique - Gradient Descent
%
% Computes parameter vector theta iteratively.
% The Gradient Descent is an iterative optimization algorithm. That is
% to say, it finds a local minimum of a function by repeadly taking steps
% proportional to the negative of the gradient of the function at the
% current point. Intuitively we can think of this as repeadly taking steps
% in direction of steepest decent.

% Sets initial values for parameter vector theta.
theta = zeros((size(dtr_X, 2)), 1);

% Sets initial number of iterations.
% This value is customisable. It should be suited and adjusted due
% to analyzing 'cost-iterations' plot.
iterations = 50;

% Alpha refers to learning rate which is a gradient descent internal
% parameter. The best practise is to keep it in logarithmic scale and
% run your gradient for different values of alpha to choose one that
% reasons fastest convergence.
alphas = [0.01 0.03 0.1 0.3];

% Sets empty figure for 'cost-iterations' plot.
figure;

colors = ['k' 'r' 'g' 'b'];

% Runs gradient descent algorithm for each learning rate alpha,
% to resolve which is suited best for fastest convergence.
for i = 1:size(alphas, 2)
  [theta_from_gradient_descent, J_history] = gradientDescent(
    dtr_X, tr_y, theta, alphas(1, i), iterations
  );

  plot(1:numel(J_history), J_history, colors(1, i), 'LineWidth', 1);

  hold on;
end

% Sets descriptive labels for 'cost-iterations' plot.
xlabel('Number of iterations');
ylabel('Cost function J');

% Adds necessary metrics for 'cost-iterations' plot.
legend('alpha - 0.01', 'alpha - 0.03', 'alpha - 0.1', 'alpha - 0.3');

% Saves 'cost-iterations' plot for future analyze.
print -dpng './images/cost_iterations_gradient_descent.png'

% ========================================================================

% Technique - Advanced Gradient Descent (BFGS, Conjugate)

% Computes parameter vector theta by solving an unconstrained
% optimization problem defined by the given function.
% It turns out, that Octave has built-in highly optimized function
% called fminunc(), which can help us resolve problem of
% minimization of our cost function in a very easily manner.
% Type 'help fminunc' in octave console for more reference about
% input parameters and return values.

% Sets initial values for parameter vector theta.
theta = zeros((size(dtr_X, 2)), 1);

% Creates options structure for optimization functions.
% Type 'help optimset' in octave console for more reference about
% available options.
options = optimset('GradObj', 'on', 'MaxIter', 400);

% Calls fminunc() with:
%   - anonymous function with one argument (Parameter vector
%     theta will be inserted here when fminunc() call happens)
%   - Initial value for parameter vector theta
%   - Custom options structure
%
% Note:
%   function result = add(fn, x)
%     fn(x) + x
%   end
%
%   add(@(x) x + 1, 1) => 3
%
%   @(argument-list) expression -
%     Refers to the syntax for defining anonymous functions
%     in octave.

[theta_from_advenced_gradient_descent, cost, status, output] = ...
  fminunc( ...
    @(t)(advancedEvaluateCost(dtr_X, tr_y, t)),
    theta,
    options
  );

% ========================================================================

% Creating plots to visualise data is very important step to understanding
% what is the problem which we stand in front of.
% Unfortunately this step always appears problematic for distributions
% with more than 2 input properties, so I decided to leave it in case of
% modeling multivariate linear regressions.

% I decided to skip plots for linear fit resolved by advenced gradient
% descent technique. It turns out that resolved parameters vector theta
% is exactly the same as parameter vector from normal equation technique.

if !(size(tr_X, 2) > 2)
  % Initializes subplot space to allow for multi figures co-existing.
  % Type help 'subplot' in octave console to see more details.
  subplot(2,1,1);

  % Sets labels for plotting training/test datasets.
  % This labels are customisable and this is the place where you can
  % customise them.
  labels = [
    'Size of a house in 1,000(ft^2)';
    'Price of a house in 1,000($)'
  ];

  % Plots training data distribution.
  % Type 'help plot' in octave console for more reference about available
  % formatting for two-dimenisional plots. (e.x 'rx' annotates red crosses.)
  plotData(tr_X, tr_y, labels, 'rx', 'Training data');

  % Prevents current figure from closing to allow for adding another plots
  % in the future. In case of univariate linear regression we will
  % want to show best possible fit line resolved by normal equation and
  % gradient descent.
  hold on;

  % Plots line based on theta from normal-equation on training data.
  plot(tr_X, dtr_X * theta_from_normal_equation, 'b-');

  % Plots line based on theta from gradient descent on training data.
  plot(tr_X, dtr_X * theta_from_gradient_descent, 'g-');

  % Adds necessary metrics for legend on training subplot.
  legend('Training data', 'Normal equation', 'Gradient descent');

  % Switches subplot slot to generate new figure on co-existing space.
  subplot(2,1,2);

  % Plots test data distribution.
  plotData(te_X, te_y, labels, 'rx', 'Test data');

  hold on;

  % Plots line based on theta from normal-equation on test data.
  plot(te_X, dte_X * theta_from_normal_equation, 'b-');

  % Plots line based on theta from gradient descent on test data.
  plot(te_X, dte_X * theta_from_gradient_descent, 'g-');

  % Adds necessary metrics for legend on test subplot.
  legend('Test data', 'Normal equation', 'Gradient descent');

  % Saves plot for univariate regression fitting from both techniques.
  print -dpng './images/univariate_fit.png' '-S800,600'
end

% Displays normal equation's result.
fprintf('Theta computed from the normal equations: \n');
fprintf(' %f \n', theta_from_normal_equation);
fprintf('\n');

% Displays gradient descent result.
fprintf('Theta computed from the gradient descent: \n');
fprintf(' %f \n', theta_from_gradient_descent);
fprintf('\n');
