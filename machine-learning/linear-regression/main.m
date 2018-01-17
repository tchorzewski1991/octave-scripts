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
% data to test data.
%
% training_data - data that we use to train model.
%
% test_data - data that we use to test overall accuracy of the model.
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
% X - represents matrix (vector in case of univariate linear regression)
%     with m x n dimensions, where:
%     m - is total numbers of training examples
%     n - refers to each unique property (independent feature) of
%         examined entity (e.x size of hause)
%
% y - represents vector with m x 1 dimensions where each dimension
%     refers to actual label value for our independent feature
%     (e.x price of house for training example)
%
% Note: Dimensions for X, y matricies are resolved dynamically
%       so it will be possible to compute not only univariate, but
%       also multivariate linear regression.

  temp = size(training_data, 2);

  X = training_data(:, 1:(temp - 1));
  y = training_data(:, temp);
  m = size(X, 1);

  % We don't need temp any more.
  clear temp;

% Creates plot with markers to better visualise actual data distribution.
% Unfortunately this step always appears problematic for distributions
% with more than 2 input properties, so I decided to leave it in case of
% modeling multivariate linear regressions.

if !(size(X, 2) > 2)
  labels = [
    'Size of a house in squared ft';
    'Price of a house in 1,000$'
  ];

  plotData(X, y, labels);

  % Prevent figure from closing to allow for adding another plot in the
  % future. In case of univariate linear regression we will want to show
  % best possible fit line resolved by our model.
  hold on;
end
