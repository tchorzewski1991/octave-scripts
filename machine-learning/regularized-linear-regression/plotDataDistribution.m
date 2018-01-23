function plotDataDistribution(X, y, plotLegend, plotStyle)

  % Creates plot with custom style.
  plot(X, y, plotStyle);

  % Sets descriptive axis labels.
  xlabel('Age in years');
  ylabel('Income in 1,000($)');

  % Resolve axis size dynamically.
  x_axis_ranges = [ 0.95 * min(X(:, 1)) 1.05 * max(X(:, 1)) ];
  y_axis_ranges = [ 0.95 * min(y(:, 1)) 1.05 * max(y(:, 1)) ];

  axis([ x_axis_ranges y_axis_ranges]);

  % Sets descriptive legend.
  legend(plotLegend);

  box off;
end
