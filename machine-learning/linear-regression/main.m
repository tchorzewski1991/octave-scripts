% Linear Regression

% Linear Regression refers to model for modeling relationship
% between dependent variable y (frequently called as a target) and
% one, or more explanatory input variables called features.
% See https://en.wikipedia.org/wiki/Linear_regression for more reference.

% ========================================================================

% Clear current workspace.
  clear ; close all; clc

% Load all given data as a matrix.
% This is the place where you can provide your own data.
  data = load('data.dat');

% ========================================================================

% Extract training/test data for future model examination.
%
% training_test_threshold - represents the percentage ratio of training
%                           data to test data.
%
% training_data - data that we will use to train the model.
%
% test_data - data that we will use to test overall accuracy of the
%             trained model.
%
  training_test_threshold = 0.75;

  training_data = data(
    1:(floor(size(data, 1) * training_test_threshold)), :
  );

  test_data = data(
    (ceil(size(data, 1) * training_test_threshold):size(data, 1)), :
  );

% ========================================================================

% Extract features/labels with matrix specific operations.
%
% X - is a matrix, that represents combination of examples and their
%     associated features (vector in case of univariate linear
%     regression). It contains m x n dimensions, where:
%     m - is the total number of examples
%     n - is the total number of unique properties
%         (independent features) of examined entity
%         (e.x size of hause)
%
% y - is a vector with m x 1 dimensions where each dimension
%     refers to actual label value for corresponding example
%     (e.x price of house)
%
% Note: Dimensions for X, y matricies are resolved dynamically,
%       so it will be possible to compute not only univariate, but
%       also multivariate linear regression.

  % X, y, m for trainig data.
  temp = size(training_data, 2);

  tr_X = training_data(:, 1:(temp - 1));
  tr_y = training_data(:, temp);
  tr_m = size(tr_X, 1);

  % We don't need temp any more.
  clear temp;

  % X, y, m for test data.
  temp = size(test_data, 2);

  te_X = test_data(:, 1:(temp - 1));
  te_y = test_data(:, temp);
  te_m = size(te_X, 1);

  % We don't need temp any more.
  clear temp;

  % Expands actual feature matricies with intercept term to apply
  % correctly normal-equation and gradient-descent techniques.
  % This step refers to creating design matricies.
  dtr_X = [ones(tr_m, 1) tr_X];
  dte_X = [ones(te_m, 1) te_X];

% ========================================================================

% Technique - Normal Equation
%
% Compute parameter vector theta analytically with Normal Equation.
% The Normal Equation solution is based on least squared solution
% for linear regression and it tends to be very effective, especially
% in case where we have small amount of featues.
% https://en.wikipedia.org/wiki/Linear_least_squares_(mathematics)
theta_from_normal_equation = normalEquation(dtr_X, tr_y);

% ========================================================================

% Technique - Gradient Descent
%
% Computes parameter vector theta by Gradient Descent.
% The Gradient Descent is an iterative optimization algorithm. That is
% to say, it finds a local minimum of a function by repeadly taking steps
% proportional to the negative of the gradient of the function at the
% current point. Intuitively we can think of this as taking steps in
% direction of steepest decent.

% Sets initial values for parameter vector theta.
theta = zeros((size(dtr_X, 2)), 1);

% Sets initial number of iterations.
% This value is customisable. It should be suited and adjusted due
% to analyzing plot of cost function J and related number of iterations.
iterations = 50;

% Alpha refers to learning rate which is a gradient descent internal
% parameter. The best practise is to keep it in logarithmic scale and
% run your gradient for different values of alpha to choose one that
% reasons fastest convergence.
alphas = [0.01 0.03 0.1 0.3];

% Sets empty figure for plot of cost function J to number of
% iterations.
figure;

colors = ['k' 'r' 'g' 'b'];

% Runs gradient descent algorithm for each learning rate alpha
% to resolve which is suited best for fastest convergence.
for i = 1:size(alphas, 2)
  [theta_from_gradient_descent, J_history] = gradientDescent(
    dtr_X, tr_y, theta, alphas(1, i), iterations
  );

  plot(1:numel(J_history), J_history, colors(1, i), 'LineWidth', 1);

  hold on;
end

% Sets descriptive labels.
xlabel('Number of iterations');
ylabel('Cost function J');

% Adds necessary metrics for 'cost - iterations' plot.
legend('alpha - 0.01', 'alpha - 0.03', 'alpha - 0.1', 'alpha - 0.3');

% Saves plot of 'cost - iterations' for future analyze.
print -dpng './images/cost_iterations_gradient_descent.png'

% ========================================================================

% Creating plots to visualise data is very important step to understanding
% what is the problem which we stand in front of.
% Unfortunately this step always appears problematic for distributions
% with more than 2 input properties, so I decided to leave it in case of
% modeling multivariate linear regressions.

if !(size(tr_X, 2) > 2)
  % Initializes subplot space to allow for multi figures co-existing.
  % Type help 'subplot' in octave console to see more details.
  subplot(2,1,1);

  % Labels for plotting training/test datasets are customisable.
  % This is the place where you should customise them.
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

  % Fits and plots line based on normal-equation parameters into training data.
  plot(tr_X, dtr_X * theta_from_normal_equation, 'b-');

  % Fits and plots line based on gradient descent parameters into training data.
  plot(tr_X, dtr_X * theta_from_gradient_descent, 'g-');

  % Adds necessary metrics for legend on training subplot.
  legend('Training data', 'Normal equation', 'Gradient descent');

  % Switches subplot slot to generate new figure on co-existing space.
  subplot(2,1,2);

  % Plots test data distribution.
  plotData(te_X, te_y, labels, 'rx', 'Test data');

  hold on;

  % Fits and plots line based on normal-equation parameters into test data.
  plot(te_X, dte_X * theta_from_normal_equation, 'b-');

  % Fits and plots line based on gradient descent parameters into test data.
  plot(te_X, dte_X * theta_from_gradient_descent, 'g-');

  % Adds necessary metrics for legend on test subplot.
  legend('Test data', 'Normal equation', 'Gradient descent');

  % Saves plot for univariate regression fit.
  print -dpng './images/univariate_fit.png' '-S800,600'
end
