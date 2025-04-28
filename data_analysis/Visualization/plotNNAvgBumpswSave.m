function finalCells = plotNNAvgBumpswSave(dataCells, fullPath)
    
    % % Define the new colors
    % facColors = [85 136 198;... % Color for factor 1 (retraction) 
    %              247 147 29]/256; % Color for factor 2 (protraction)

     % 4/2/25, apparently my colors were wrong
    % Define the MATLAB colors
    facColors = [0, 0.4470, 0.7410;... % MATLAB blue
             0.8500, 0.3250, 0.0980]; % MATLAB orange

    % Initialize matrices to hold the even (retraction) and odd (protraction) indexed cells
    evenData = [];
    oddData = [];

    % Loop through dataCells, extracting retraction (even) and protraction (odd) data
    for i = 1:length(dataCells)
        currentData = dataCells{i};
        yData = currentData(2, :);

        if mod(i, 2) == 0  % Even indexed cells (retraction)
            if isempty(evenData)
                evenData = yData;
            else
                % Ensure all data have the same length for averaging
                evenData = padWithNaNs(evenData, length(yData));
                yData = padWithNaNs(yData, size(evenData, 2));
                evenData = [evenData; yData];
            end
        else  % Odd indexed cells (protraction)
            if isempty(oddData)
                oddData = yData;
            else
                % Ensure all data have the same length for averaging
                oddData = padWithNaNs(oddData, length(yData));
                yData = padWithNaNs(yData, size(oddData, 2));
                oddData = [oddData; yData];
            end
        end
    end

    % Calculate the averages of the even (retraction) and odd (protraction) data
    meanEvenData = mean(evenData, 1, 'omitnan'); % Averaging across rows, ignoring NaNs
    meanOddData = mean(oddData, 1, 'omitnan'); % Averaging across rows, ignoring NaNs

    % Normalize the x-axis properly
    maxDataLength = max(length(meanEvenData), length(meanOddData));
    normalizedX = linspace(0, 1, maxDataLength);

    % Create a plot of the average data
    h = figure; % Save the figure handle
    hold on;
    plot(normalizedX, meanEvenData, 'Color', facColors(2,:), 'LineWidth', 2);
    plot(normalizedX, meanOddData, 'Color',facColors(1,:), 'LineWidth', 2);
    title('Averaged Norm BMPs');
    xlabel('Time (Normalized)');
    ylabel('Magnitude');
    legend('Protraction Mode', 'Retraction Mode');
    grid on;

    % Ensure the x-axis is set from 0 to 1
    xlim([0 1]); % Explicitly setting x-axis limits

    % Save and close operations
    if ~isempty(fullPath)
        saveas(h, fullfile(fullPath, 'AveragedNormBMPs.png'));
    end
    close(h);

    % Return finalCells containing the magnitudes of y-values
    finalCells = {meanEvenData, meanOddData};
end

% Function to pad a vector or matrix with NaNs to a specified length
function paddedData = padWithNaNs(data, targetLength)
    currentLength = size(data, 2);
    if currentLength < targetLength
        padSize = targetLength - currentLength;
        paddedData = [data, nan(size(data, 1), padSize)];
    else
        paddedData = data;
    end
end
