% Linear Regression

% Linear Regression refers to model for modeling relationship
% between dependent variable y (frequently called as a target) and
% one, or more explanatory input variables called features.
% See https://en.wikipedia.org/wiki/Linear_regression for more reference.

% ======================================================================

% Clear current workspace.
  clear ; close all; clc

% Load all given data as a matrix.
  data = load('data.dat');

% Extract training/test data for future model examination.
%
% training_test_threshold - represents the percentage ratio of training
%                           data to test data.
%
% training_data - data that we use to train model.
%
% test_data - data that we will use to test overall accuracy of the
%             trainedmodel.
%
  training_test_threshold = 0.75;

  training_data = data(
    1:(floor(size(data, 1) * training_test_threshold)), :
  );

  test_data = data(
    (ceil(size(data, 1) * training_test_threshold):size(data, 1)), :
  );

% Extract features/labels with matrix specific operations.
%
% X - is a matrix, that represents combination of training examples and
%     their associated features (vector in case of univariate linear
%     regression). It contains m x n dimensions, where:
%     m - is the total number of training examples
%     n - is the total number of unique properties
%         (independent features) of examined entity
%         (e.x size of hause)
%
% y - is a vector with m x 1 dimensions where each dimension
%     refers to actual label value for corresponding training
%     example (e.x price of house)
%
% Note: Dimensions for X, y matricies are resolved dynamically,
%       so it will be possible to compute not only univariate, but
%       also multivariate linear regression.

  temp = size(training_data, 2);

  X = training_data(:, 1:(temp - 1));
  y = training_data(:, temp);
  m = size(X, 1);

  % We don't need temp any more.
  clear temp;

% Create plot with markers to better visualise actual data distribution.
% Unfortunately this step always appears problematic for distributions
% with more than 2 input properties, so I decided to leave it in case of
% modeling multivariate linear regressions.

if !(size(X, 2) > 2)
  labels = [
    'Size of a house in 1,000(ft^2)';
    'Price of a house in 1,000($)'
  ];

  % Type 'help plot' in octave console for more reference about available
  % formatting for two-dimenisional plots. (e.x 'rx' annotates red crosses.)
  plotData(X, y, labels, 'rx');

  % Prevent figure from closing to allow for adding another plot in the
  % future. In case of univariate linear regression we will want to show
  % best possible fit line resolved by our model.
  hold on;
end
