function dataCells = plotIsolatedBumpswSave(isolatedBumps, intervals, fullPath)
    
    % % Define the new colors
    % facColors = [85 136 198;... % Color for factor 1 (retraction) 
    %              247 147 29]/256; % Color for factor 2 (protraction)

     % 4/2/25, apparently my colors were wrong
    % Define the MATLAB colors
    facColors = [0, 0.4470, 0.7410;... % MATLAB blue
             0.8500, 0.3250, 0.0980]; % MATLAB orange

    % Number of plots will be half the number of rows in isolatedBumps
    numPlots = length(isolatedBumps) / 2;
    h = figure('Visible', 'off', 'Position', [100, 100, 1200, 800]); % Create a new figure window without specifying size to use default
    dataCells = cell(numPlots * 2, 1); % Initialize a cell array for y-values

    % Initialize array of graphic objects for subplots and line handles
    hSub = gobjects(numPlots, 1);
    handleArray = gobjects(2, 1); % Array to store two relevant plot handles for the legend

    plotIndex = 1;  % Initialize index for storing in cell array
    for i = 1:numPlots  % Iterate over the number of subplots
        hSub(i) = subplot(numPlots, 1, i); % Organize plots in a vertical layout
        hold on;

        % Plot each pair from isolatedBumps (2 rows per plot)
        for j = 1:2  % Two lines per subplot
            dataIndex = 2*(i-1) + j;  % Calculate the data index from isolatedBumps
            if j == 1
                plotColor = facColors(1,:);  % Red for the first dataset
            else
                plotColor = facColors(2,:);  % Blue for the second dataset
            end

            % Normalize the x-axis from 0 to 1
            normalizedX = linspace(0, 1, length(isolatedBumps{dataIndex}));

            % Plot the data with normalized x-axis and store the handle
            handle = plot(normalizedX, isolatedBumps{dataIndex}, 'Color',plotColor);
            if i == 1  % Store only the first subplot's handles for the legend
                handleArray(j) = handle;
            end

            % Store only the y-values (magnitudes) in the corresponding cell
            dataCells{plotIndex} = isolatedBumps{dataIndex}';  % Transpose if necessary to match orientation
            plotIndex = plotIndex + 1;  % Increment index for next data set
        end

        % Interval time calculation using the actual interval start and end times
        intervalStart = intervals(i, 1);
        intervalEnd = intervals(i, 3);
        intervalMiddle = intervals(i, 2);
        normalizedIntervalTime = (intervalMiddle - intervalStart) / (intervalEnd - intervalStart);
        
        xline(normalizedIntervalTime, '--k', 'LineWidth', 1.5);  % Plotting the line for this specific interval
        % Set labels and titles depending on the subplot index
        ylabel('Magnitude','FontSize',16);
        if i == 1
            title('Each BMP & its modules','FontSize',22);
        end
        if i ~= numPlots
            set(hSub(i), 'XTick', []);
        else
            xlabel('Time (Normalized)', 'FontSize', 22);
        end
    end
    % Adjust subplot spacing and setup legend
    if all(isgraphics(handleArray))
        % Add the legend using the handles of the first two plotted lines
        legend(handleArray, {'Retraction Mode', 'Protraction Mode'}, 'Location', 'southoutside', 'Orientation', 'horizontal');
    end

    % Save and close operations
    if ~isempty(fullPath)
        saveas(h, fullfile(fullPath, 'AllBMPs.png'));
    end
    close(h);
    
    return; % Return the cell array with y-values
end
