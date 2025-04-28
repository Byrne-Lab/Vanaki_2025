function isolatedBumps = extractBumps(H, intervals, timeStep)
    numIntervals = size(intervals, 1);
    isolatedBumps = cell(numIntervals * 2, 1); % Preallocate cell array for both datasets
    
    % Iterate over each interval
    for idx = 1:numIntervals
        % Start and end times to indices
        startIndex = floor(intervals(idx, 1) * timeStep) + 1;
        endIndex = floor(intervals(idx, 3) * timeStep) + 1;
        
        % Ensure indices do not exceed matrix dimensions
        endIndex = min(endIndex, size(H, 2));
        
        % Extract data for each dataset within the interval
        isolatedBumps{2*idx-1} = H(1, startIndex:endIndex); % Data from first dataset
        isolatedBumps{2*idx} = H(2, startIndex:endIndex);   % Data from second dataset
    end
end
