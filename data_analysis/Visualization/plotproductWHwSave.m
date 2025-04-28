function h = plotproductWHwSave( W, H, downSampFac,fullPath,power)
    % This function plots the product of matrices W and H as a heatmap.
   if nargin < 5
     power = '';  % Default identifier is empty
   else
     power = ['_' num2str(power)];  % Convert number to string and prepend with _
   end
    % Compute the product
    WH = W * H;

    % Create a heatmap
    h = figure('Visible','off');
    imagesc(WH); % Plot WH as a heatmap
    colorbar; % Show a colorbar
    
    ax = gca;
    
    % Calculate ticks based on actual size of WH
    numXTicks = 7; % How many ticks you want
    tickSpacing = size(WH, 2) / (numXTicks - 1);
    ax.XTick = 0:tickSpacing:size(WH, 2);
    ax.XTickLabels = (ax.XTick * downSampFac) / 1000; % Adjust labels for downsampling and unit conversion

    % Set x-axis limits to ensure all ticks are visible
    xlim([0 size(WH, 2)]);

    % Label axes
    xlabel('Time (s)');
    ylabel('Neurons');
    title('Heatmap of WH');

    if ~isempty(fullPath)
      filename = fullfile(fullPath, ['Reconstruction' power '.png']);
      saveas(h, filename);
    end
end
