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
% test_data - data that we use to test overall accuracy of the model
%
  training_test_threshold = 0.75;

  training_data = data(
    1:(floor(size(data, 1) * training_test_threshold)), :
  );

  test_data = data(
    (ceil(size(data, 1) * training_test_threshold):size(data, 1)), :
  );
