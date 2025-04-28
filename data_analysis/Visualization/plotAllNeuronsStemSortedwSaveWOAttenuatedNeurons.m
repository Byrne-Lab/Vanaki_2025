% 4/7/2024
% Sara Vanaki, we are going to build off of plotStemSortedFully.m and now
% keep all the neurons, even if they don't fire

function [h,sortedIndices, sortedW] = plotAllNeuronsStemSortedwSaveWOAttenuatedNeurons(X,H,W,BMPintervalTimes,BMPtypes,fullPath, power, CellOrder, mapofCells)
% returns h, this is a figure handle
% arguments - X,H,W
% a(1) - a heat map of neural activity X
% a(2) - a set of time courses H representing the activation of dif neural
%        patterns
% a(3) - a set of contributions w representing the weights or importance 
%        of dif neurons to these patterns
 

  H = H';
  downSampFac = size(X,1)/size(H,1);
  disp(downSampFac);
  disp("tests");
  % downsamples the matrix X by our factor, reducing the size for plotting
  X = X(1:downSampFac:end,:);

  % Initialize index lists
  proListIndices = [];
  retListIndices = [];
  % Iterate over each row
  for i = 1:size(W, 1)
      if W(i, 1) > W(i, 2)
          proListIndices = [proListIndices; i];
      else
          retListIndices = [retListIndices; i];
      end
  end
  % Sort proListIndices based on the values in column 1 of W (descending order)
  [~, sortedProIndices] = sort(W(proListIndices, 1), 'descend');
  proListIndices = proListIndices(sortedProIndices);
  % Sort retListIndices based on the values in column 2 of W (descending order)
  [~, sortedRetIndices] = sort(W(retListIndices, 2), 'descend');
  retListIndices = retListIndices(sortedRetIndices);
  % Concatenate all the proListIndices and retListIndices
  sortedIndices = [retListIndices; proListIndices];
  % Use the sorted indices to sort W
  sortedW = W(sortedIndices, :); 

  h = figure('Visible','off');
  % assigns h to the new figure window 
  ax(1) = axes; hold on
  % creates a set of axes in h for plotting and holds the axes for multiple
  % plots, this is the bottom graph (neurons v time and contribution)
  cmap = colormap('pink');
  clim = [0 max(X,[],'all')]; %[0 17];
  % sets the color limits for scaling the colormap. takes the max value 
  % over all elements in X as the upper limit

  sortedX = X(:, sortedIndices);

  imagesc(sortedX',clim)

  % displays the matrix X' as an image w color from clim
  
  ax(1).TickDir = 'out';
  % sets tick mark direction to point outwards
  xlabel('Time (s)')
  ylabel('Neurons')
  ax(1).XLim = [0.5 size(X,1)+0.5];
  ax(1).YLim = [0.5 size(X,2)+0.5];
  % sets the x and y axis limits of the first axes
  ax(1).YDir = 'reverse';
  % origin is at the top
  ax(1).XTick = 0:20000/downSampFac:size(X,1);
  ax(1).XTickLabels = (0:20000:size(X,1)*downSampFac)/1000;
  % sets the ticks and labels on x axis, scaling them to acc for downsampl
  % and converting to seconds
  ax(1).Position = [0.1 0.11 0.7 0.69];
  % sets the location of the first axes within h
  %maxHz = max(X,[],'all');
  cbar = colorbar('location','east','Ticks',[0 .001]);
  cbar.Label.String = 'Firing Rate (Hz)';
  cbar.Label.Rotation = 90;
  cbar.Label.VerticalAlignment = 'bottom';
  % add a colorbar to the right side of the axes w specific ticks
  cbar.Position = [0.8319    0.8500    0.0268    0.0857];
  
  cbar.TickDirection = 'out';
  cbar.TickLength = 0.1;
 
  pColors = colororder;
  %pColors = [.8500 .325 .098;0 .447 .741];
  % gets the default color order for plotting MATLAB preferences
  ax(2) = axes;
  % Plot the smoothed data

  for ii = 1:size(H, 2)
      patch([1, 1:size(H, 1), size(H, 1)], [0; H(:, ii); 0], pColors(ii, :), 'FaceAlpha', 0.8);
  end
  % Define a higher y-level for the intervals, above the existing plot
  yLevel = 0.01;  % Adjust this as needed to position the brackets above your graph
  
  % Loop through each row of H to plot the intervals
  hold on; % Keep existing plot
  for idx = 1:size(BMPintervalTimes, 1)
      xPoints = BMPintervalTimes(idx, :); % Time points from the row
      xPoints = xPoints * 100;
      % 12/9/2024 this is only to draw the bars for the 60 to 120 sec
      %xPoints = xPoints * 100; % Scale and shift time points
      %xPoints = xPoints - 6000; % Scale and shift time points



      % Determine the color based on the value of the column
      if BMPtypes(1, idx) == 1
          line_color = 'k'; % black color for col_idx = 1
      else
          line_color = 'g'; % green color for other values
      end

      % Plot the vertical lines
      for x = xPoints
          plot([x x], [yLevel - 0.002, yLevel + 0.002], [line_color, '-'], 'LineWidth', 2); % vertical lines
      end

      % Plot the horizontal lines between the vertical lines
      plot(xPoints, repmat(yLevel, 1, length(xPoints)), [line_color, '-'], 'LineWidth', 2); % horizontal lines
  end
  hold off;
  
  
  % colors for each
  ax(2).TickDir = 'out';
  ax(2).Position = [0.1 0.81 0.7 0.18];
  ax(2).XLim = ax(1).XLim;
  % matches the x-axis limits of the second axes to those of a(1)
  ax(2).XTick = [];
  % removes the x axis ticks
  ax(2).Box = 'off';
  % removes the box surrounding the second axes
  ax(2).YLabel.String = 'Magnitude';
  leg = legend({  'Retraction Module' 'Protraction Module' },'location','best');
  %leg = legend({ 'Protraction Module' 'Retraction Module'  },'location','best');
  % create a legend with 2 entries and places(for colors) in the best 
  % location automatically determined by MATLAB
  leg.Position(1:2) = [0.81 0.81];
 

  

  ax(3) = axes;
  % creates a third set of axes, this will be the contribution factor

  
  stem([1:size(W',2)],sortedW,'LineWidth',1,'LineStyle','-','Marker','o');
  % % Define MATLAB default colors for orange and blue
  % orangeColor = [0.8500, 0.3250, 0.0980];  % Default MATLAB orange
  % blueColor = [0, 0.4470, 0.7410];  % Default MATLAB blue
  % 
  % hold on; % Hold the plot to overlay different colors
  % % Loop through each row in W
  % for i = 1:size(W,1)
  % 
  %         % Plot first column with orange and second with blue (swapping colors)
  %         stem(i, sortedW(i, 1), 'Color', orangeColor, 'LineWidth', 1, 'LineStyle', '-', 'Marker', 'o');
  %         stem(i, sortedW(i, 2), 'Color', blueColor, 'LineWidth', 1, 'LineStyle', '-', 'Marker', 'o');
  % 
  % end
  % hold off;



  
  % create a stem plot for W
  ax(3).Position = [0.81 0.11 0.18 0.69];
  ax(3).XLim = ax(1).YLim;
  ax(3).YLabel.String = 'Contribution';
  ax(3).Box = 'off';
  ax(3).XTick = [];
  ax(3).TickDir = 'out';
  view(90,90);
  % rotates the view of the third axes to a vertical orientation, 90 deg
  
  % set the font of all axes to Arial
  set(ax,'FontName','Arial')
  % Deleting attenuated neurons on 2/3/2025
  newYLabels = mapofCells(sortedIndices)-17;
  % Set these labels to the Y-axis of your plot
  set(ax(1), 'YTick', 1:length(sortedIndices), 'YTickLabel', newYLabels);

   % Alternatively, save as a PNG image with a specific resolution
  % Set the PaperPositionMode to auto so that the saved file
  % will match the figure's on-screen appearance
  set(h, 'PaperPositionMode', 'auto');
  print(h, 'my_figure.png', '-dpng', '-r300'); % Adjust '-r300' for the desired resolution
  
  % Dynamic figure height calculation, added 8/26/24
  baseHeightPerLabel = 20;  % Adjust this value as needed
  figureHeight = baseHeightPerLabel * length(sortedIndices);
  % Set a minimum height to prevent the figure from being too small
  minHeight = 400;
  figureHeight = max(figureHeight, minHeight);
  % Adjust the figure size to fit all labels
  set(h, 'Position', [100, 100, 800, figureHeight]);

  % Save the figure
  if ~isempty(fullPath)
      saveas(h, fullfile(fullPath, 'NeuronActivityFigure.png'));
  end  
  % Assuming W is already defined
  sizeH = size(W); % Get the size of W

  % Print the size
  disp(['This is the size of H: ' num2str(sizeH(1)) ' x ' num2str(sizeH(2))]);

  %this is to plot the product of WH  
  plotproductWHwSave(sortedW, H', downSampFac,fullPath, power);
  

end