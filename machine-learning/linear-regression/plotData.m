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

  % Resolve axis automatically.
  axis('auto');

  box off;
end
