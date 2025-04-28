function dataCells = plotNewNormBumps(isolatedBumps, intervals, fullPath)
    
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

    % Define new uniformly spaced x-values
    newX = linspace(0, 1, 10000); % Adjust 10000 to desired resolution

    plotIndex = 1;  % Initialize index for storing in cell array
    for i = 1:numPlots  % Iterate over the number of subplots
        subplot(numPlots, 1, i); % Organize plots in a vertical layout
        hold on;

        % Interval time calculation using the actual interval start and end times
        intervalStart = intervals(i, 1);
        intervalMiddle = intervals(i, 2);
        intervalEnd = intervals(i, 3);

        % Normalize each segment separately
        protractionLength = intervalMiddle - intervalStart;
        retractionLength = intervalEnd - intervalMiddle;

        for j = 1:2  % Two lines per subplot, for protraction and retraction
            dataIndex = 2*(i-1) + j;  % Calculate the data index from isolatedBumps
            dataLength = length(isolatedBumps{dataIndex});
            protractionEndIndex = round(protractionLength / (protractionLength + retractionLength) * dataLength);
            
            % Create a combined normalized X axis for interpolation
            originalX = [linspace(0, 0.5, protractionEndIndex), linspace(0.5, 1, dataLength - protractionEndIndex)];
            
            % Ensure originalX and yData have the same length
            yData = isolatedBumps{dataIndex};
            if length(originalX) > length(yData)
                originalX = originalX(1:length(yData));
            elseif length(originalX) < length(yData)
                yData = yData(1:length(originalX));
            end

            % Remove duplicate x-values
            [originalX, uniqueIdx] = unique(originalX);
            yData = yData(uniqueIdx);

            % Interpolate yData to new uniformly spaced x-values
            newY = interp1(originalX, yData, newX, 'linear');

            % % Debugging statements
            % if i == 1 && j == 1  % Print the first dataset for verification
            %     disp(['Data index: ', num2str(dataIndex)]);
            %     disp('First few new X values:');
            %     disp(newX(1:10));  % Display first few new X values
            %     disp('First few new Y values:');
            %     disp(newY(1:10));  % Display first few new Y values
            %     disp('Middle few new X values:');
            %     disp(newX(floor(end/2)-5:floor(end/2)+5));  % Display middle few new X values
            %     disp('Middle few new Y values:');
            %     disp(newY(floor(end/2)-5:floor(end/2)+5));  % Display middle few new Y values
            %     disp('Last few new X values:');
            %     disp(newX(end-9:end));  % Display last few new X values
            %     disp('Last few new Y values:');
            %     disp(newY(end-9:end));  % Display last few new Y values
            % end

            if j == 1
                plotColor = facColors(1,:);  % Red for the 1st dataset (Retraction Mode)
            else
                plotColor = facColors(2,:);  % Blue for the 2nd dataset (Protraction Mode)
            end
            
            plot(newX, newY, 'Color', plotColor); % Plot the data with new normalization
            
            % Store both the new x-values and y-values in the corresponding cell
            dataCells{plotIndex} = [newX; newY];  % Ensure y-values are row vectors
            plotIndex = plotIndex + 1;  % Increment index for next data set
        end

        xline(0.5, '--k', 'LineWidth', 1.5);  % Visual delimiter between phases
        ylabel('Magnitude', 'FontSize',16);
        if i == 1
            title('New Norm BMPs & its modules','FontSize',22);
        end
        if i ~= numPlots
            set(gca, 'XTick', []);
        else
            xlabel('Time (Normalized) ', 'FontSize',22);
        end
    end
    % Adjust subplot spacing and add legend
    legend({'Retraction Mode', 'Protraction Mode'}, 'Location', 'southoutside', 'Orientation', 'horizontal');

    % Save and close operations
    if ~isempty(fullPath)
        saveas(h, fullfile(fullPath, 'NewNormBMPs.png'));
    end
    close(h);
    
    return; % Return the cell array with new x and y-values
end
