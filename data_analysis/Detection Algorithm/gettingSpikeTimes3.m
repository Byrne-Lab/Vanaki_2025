% verision 3 of getting spike times so now that we have reset the threshold
% we know how to get the new spike times.
% Sara Vanaki, 6/3/2024
function spikeMatrix = gettingSpikeTimes3(filteredIdx, spikes, time)

    % Find indices of all channels starting with 'V-'
    %vch = find(contains(props.ch, 'V-'));
    %disp("this is where my vch are");
    %disp(vch);
    Idx = 1:length(filteredIdx);
    
    % Intersect with showidx to get only those neurons starting with 'V-' that are also in showidx
    %filteredIdx = intersect(vch, props.showidx);
    %disp(filteredIdx);
    % Initialize cell array to store spike times for each neuron in filteredIdx
    spikeTimesByNeuron = cell(1, numel(filteredIdx)); 
    
    % Initialize active neurons count
    activeNeuronsCount = 0;
    
    for i = 1:numel(filteredIdx)
        neuronIndex = Idx(i);
        %disp(neuronIndex);
        sp = spikes{neuronIndex};
        activeNeuronsCount = activeNeuronsCount + 1; % Increment if neuron is active
        x = time(sp); % x-coordinates (time points) of spikes
        
        % Store the spike times in the corresponding cell
        spikeTimesByNeuron{i} = x;
    end
    
    % Find the maximum number of spikes in any single neuron
    maxSpikes = max(cellfun(@numel, spikeTimesByNeuron));
    
    % Initialize a matrix of NaNs
    spikeMatrix = zeros(maxSpikes, numel(spikeTimesByNeuron));
    
    % Fill the matrix with spike times
    for i = 1:numel(spikeTimesByNeuron)
        numSpikes = numel(spikeTimesByNeuron{i});
        %if numSpikes >= 0  % Check if the neuron has 10 or more spikes
        spikeMatrix(1:numSpikes, i) = spikeTimesByNeuron{i};
        %else
            %spikeMatrix(:, i) = 0; % Clear the column if fewer than 10 spikes
        %end    
    end
    % Optional rounding of spike times, if necessary
    % spikeMatrix = round(spikeMatrix);
end
