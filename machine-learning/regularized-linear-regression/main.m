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
