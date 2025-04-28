function finalCells = plotNNProBumpswSave(dataCells, fullPath)
    % Check if the input cell array is not empty
    if isempty(dataCells)
        error('Input cell array is empty.');
    end

    % Initialize matrices to hold the even and odd indexed cells
    evenCellData = [];
    oddCellData = [];

    % Loop through the cell array, processing both even and odd indexed cells
    for i = 1:length(dataCells)
        currentData = dataCells{i};
        if mod(i, 2) == 0  % Even indexed cells
            if isempty(evenCellData)
                evenCellData = currentData;
            else
                maxLength = max(size(evenCellData, 1), length(currentData));
                paddedEvenCellData = padWithAdjacentValues(evenCellData, maxLength);
                paddedCurrentData = padWithAdjacentValues(currentData, maxLength);
                evenCellData = [paddedEvenCellData, paddedCurrentData];
            end
        else  % Odd indexed cells
            if isempty(oddCellData)
                oddCellData = currentData;
            else
                maxLength = max(size(oddCellData, 1), length(currentData));
                paddedOddCellData = padWithAdjacentValues(oddCellData, maxLength);
                paddedCurrentData = padWithAdjacentValues(currentData, maxLength);
                oddCellData = [paddedOddCellData, paddedCurrentData];
            end
        end
    end

    % Calculate the averages of the even and odd cells
    meanEvenData = mean(evenCellData, 2); % Using mean since there are no NaNs
    meanOddData = mean(oddCellData, 2); % Using mean since there are no NaNs

    % Normalize the x-axis properly
    maxDataLength = max(length(meanEvenData), length(meanOddData));
    normalizedX = linspace(0, 1, maxDataLength);

    % Create a plot of the average data
    h = figure; % Save the figure handle
    hold on;
    plot(normalizedX, meanEvenData, 'b', 'LineWidth', 2);
    plot(normalizedX, meanOddData, 'r', 'LineWidth', 2);
    title('OG averages');
    xlabel('Time (Normalized)');
    ylabel('Magnitude');
    legend('Protraction', 'Retraction');
    grid on;

    % Ensure the x-axis is set from 0 to 1
    xlim([0 1]); % Explicitly setting x-axis limits

    % Save and close operations
    if ~isempty(fullPath)
        saveas(h, fullfile(fullPath, 'OGAvg.png'));
    end
    close(h);

    % Return finalCells containing the magnitudes of y-values
    finalCells = {meanEvenData, meanOddData};
end

% Function to pad a vector or matrix with adjacent values instead of NaNs
function paddedData = padWithAdjacentValues(data, maxLength)
    [rows, cols] = size(data);
    paddedData = nan(maxLength, cols);
    paddedData(1:rows, :) = data;
    
    % Pad each column with the last value in that column
    for col = 1:cols
        padValues = repmat(data(end, col), maxLength - rows, 1);
        paddedData(rows+1:end, col) = padValues;
    end
end
