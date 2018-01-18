function plotData(x, y,
    labels = ['Undefined'; 'Undefined'],
    opts = ['rx';]
  )
  
  % Initializes empty figure.
  figure;

  % Creates plot for data.
  % Formatting for plot is customisable.
  plot(x, y, opts(1, :));
  
  % Sets descriptive labels.
  % Labels for plot are customisable.
  xlabel(labels(1, :));
  ylabel(labels(2, :));

  % Resolve axis dynamically.
  x_axis_ranges = [ 0.75 * min(x(:, 1)) 1.25 * max(x(:, 1)) ];
  y_axis_ranges = [ 0.75 * min(y(:, 1)) 1.25 * max(y(:, 1)) ];

  axis([ x_axis_ranges y_axis_ranges]);

  box off;
end
