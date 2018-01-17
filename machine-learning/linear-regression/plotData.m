function plotData(x, y,
    labels = ['Undefined'; 'Undefined'],
    opts = ['rx';]
  )
  
  % Set empty figure.
  figure;

  % Create plot with additional 'rx' option which annotates
  % we want points visible as red crosses.
  plot(x, y, opts(1, :));
  
  % Set descriptive labels.
  xlabel(labels(1, :));
  ylabel(labels(2, :));

  % Resolve axis automatically.
  axis('auto');
end
