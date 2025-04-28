% Sara Vanaki
% 6/10/2024, updated 10/2/2024
% Testing if our detection algo is able to save imgs

% on 11/15/2024 I want to just send back dataMatrix (each ind BMP values
% for the entire experiment bc i want to print all individual BMPs
%function dataMatrix = testDetectionAlgo06102024(FilePath, FolderPath)

function [NNfinalCells, W_all, positions_all, kernel_size_all] = testDetectionAlgo06102024(FilePath, FolderPath)

% % Define constant parameters to be used for spike detection
% constantParams.ckdv = 1;
% constantParams.gapdur = 3.9;
% constantParams.gpdvdur = 3.5;
% constantParams.ra = 15;
% constantParams.ck1 = 1;
% constantParams.dur1 = 1.5000;
% constantParams.thr1 = -3;
% constantParams.ck1rej = 0;
% constantParams.rej1 = 10;
% constantParams.ck2 = 1;
% constantParams.dur2 = 2;
% constantParams.thr2 = 2.7500;
% constantParams.ck2rej = 0;
% constantParams.rej2 = -4;

% % Define constant parameters to be used for spike detection
% % iteration 3 of params
% constantParams.ckdv = 1;
% constantParams.gapdur = -7;
% constantParams.gpdvdur = 7;
% constantParams.ra = 15;
% constantParams.ck1 = 1;
% constantParams.dur1 = .8000;
% constantParams.thr1 = 2.5;
% constantParams.ck1rej = 0;
% constantParams.rej1 = 10;
% constantParams.ck2 = 1;
% constantParams.dur2 = 1.3000;
% constantParams.thr2 = -2.5000;
% constantParams.ck2rej = 0;
% constantParams.rej2 = -4;


% Define constant parameters to be used for spike detection
% iteration 4 of params, 1/20/2025
constantParams.ckdv = 1;
constantParams.gapdur = 18;
constantParams.gpdvdur = 18;
constantParams.ra = 15;
constantParams.ck1 = 1;
constantParams.dur1 = 2;
constantParams.thr1 = -2.2;
constantParams.ck1rej = 0;
constantParams.rej1 = 10;
constantParams.ck2 = 1;
constantParams.dur2 = 2;
constantParams.thr2 = 2.2;
constantParams.ck2rej = 0;
constantParams.rej2 = -4;


% Define the path to the data file
dataPath =FilePath;
% Define the base path and date folder
basePath = FolderPath;

dateFolder = '04-02-2025rec2iter4';
fullPath = fullfile(basePath, dateFolder);

% Ensure the directory exists
if ~exist(fullPath, 'dir')
    mkdir(fullPath);
end

% Load the data with the full path
load(dataPath);
% Convert and scale the data
vdata = double(props.data) ./ repmat(props.d2uint, 1, size(props.data, 2)) + repmat(props.min, 1, size(props.data, 2));

% Find indices of channels to be analyzed
filteredIdx = find(contains(props.ch, 'V-'));
% added 2/3/2025 to get rid of attenuated neurons
attenuateFlag = 1;
if strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\23-05-30\04-02-2025rec2iter4')
    valuesToRemove = [28];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\23-06-06\04-02-2025rec1iter4')
    valuesToRemove = [6,15,16,21,22];  
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\23-12-01-1\04-02-2025rec1iter4')
    valuesToRemove = [17,18,21,22,23,25,28,30];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\23-12-01-1\04-02-2025rec2iter4')
    valuesToRemove = [2,18,58];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\23-12-01-2\04-02-2025rec2iter4')
    valuesToRemove = [21,84];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\23-12-15-1\04-02-2025rec2iter4')
    valuesToRemove = [17];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\23-12-15-2\04-02-2025rec2iter4')
    valuesToRemove = [4,9,10];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-03-08\04-02-2025rec1iter4')
    valuesToRemove = [16,17,18,20];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-04-26\04-02-2025rec2iter4')
    valuesToRemove = [1, 2, 7, 16, 17, 18, 19, 59, 102];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-05-03\04-02-2025rec1iter4')
    valuesToRemove = [24,25,26,28];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-05-03\04-02-2025rec2iter4')
    valuesToRemove = [10,11,12];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-05-24\04-02-2025rec2iter4')
    valuesToRemove = [12,13];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-05-30\04-02-2025rec1iter4')
    valuesToRemove = [32,33,34,35,36,37,38,39,41,42,43,46,47,58,64];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-05-30\04-02-2025rec2iter4')
    valuesToRemove = [9,16,17,22];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-06-06\04-02-2025rec1iter4')
    valuesToRemove = [21];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-06-07\04-02-2025rec1iter4')
    valuesToRemove = [16,17,66];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-07-19-1\04-02-2025rec1iter4')
    valuesToRemove = [10,14,16,17,18,19,21];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-08-15\04-02-2025rec1iter4')
    valuesToRemove = [27,28,29,30,31,32,33,34,35,41,42,122];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-08-15\04-02-2025rec2iter4')
    valuesToRemove = [8,9,15,16,17];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-08-20\04-02-2025rec1iter4')
    valuesToRemove = [13,19];
elseif strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-08-20\04-02-2025rec2iter4')
    valuesToRemove = [5,9,10];

else
    attenuateFlag = 0;
    disp(attenuateFlag);
end
    
if attenuateFlag == 1
    valuesToRemove = valuesToRemove +17;
    filteredIdx = setdiff(filteredIdx, valuesToRemove);
end
% Initialize structures to store results from each channel
allSpikes = cell(length(filteredIdx), 1);
allAspike = cell(length(filteredIdx), 1);
allAspike2 = cell(length(filteredIdx), 1);
allLogic = cell(length(filteredIdx), 1);

% Define the sample frequency
tm = props.tm;
sf = diff(tm(1:2)); % Assuming tm represents time points and is uniform
% Define a window for spike extraction
ourW = -1000:1000;
total = 1;
% Loop over each channel index in filteredIdx
for k = 1:length(filteredIdx)
    idx = filteredIdx(k);
    data = vdata(idx, :);  % Primary channel data
    % Optional: If you want to compare with a fixed secondary channel or another from filteredIdx
    idx2 = filteredIdx(mod(k, length(filteredIdx)) + 1);  % Just an example strategy
    data2 = vdata(idx2, :);  % Secondary channel data for comparison
    % Call the detection algorithm
    [spikes, aspike, aspike2, logic] = detection_algorithm(constantParams, ourW, data, data2, sf);
    % Store results
    allSpikes{k} = spikes;
    allAspike{k} = aspike;
    allAspike2{k} = aspike2;
    allLogic{k} = logic;
    total = total +1;
    disp(idx);
end

%grab just the nerves we want (is always going to be 8)
startIndex = find(strcmp(props.ch, 'A08-Rn')); % Finds the index of 'V-001'
props.ch(8,1) = "A15-Bn3";
endIndex = find(strcmp(props.ch, 'A15-Bn3')); % Finds the index of 'V-052'
nerveIdx = startIndex:endIndex;



% %call to get the nerve times
% nerveMatrix = gettingSpikeTimes3(nerveIdx,props.spikedetection.spikes,tm);
% nerveMatrix = round(nerveMatrix*1000);
% nerveX = spikeTimes2Logical(nerveMatrix);

spikeMatrix3 = gettingSpikeTimes3(filteredIdx, allSpikes',tm);
spikeMatrix3 = round(spikeMatrix3*1000);

X_a = spikeTimes2Logical(spikeMatrix3);
% disp("this is the size of x_A");
% disp(size(X_a));
%x_a_trimmed = X_a(1:60000, :);
%x_a_trimmed = X_a(60001:end, :);

%disp(size(x_a_trimmed)); % Displays [60000 68]
BMPintervalTimes = props.BMP_analysis.BMP;

X_b = ksGaussian(X_a);
%only use this if u r looking at the first half or second, 12/6/2024
%X_b = ksGaussian(x_a_trimmed);

[NNMFpost, ~] = run_nnmf(spikeMatrix3);
X = X_b(:, NNMFpost.cellOrderIdx);
if attenuateFlag ==1
    mappedCellOrderIdx = filteredIdx(NNMFpost.cellOrderIdx);
end
W = NNMFpost.W;
H = NNMFpost.H;

if ~isempty(fullPath)
    % Specify the filename
    filename = 'NNMFpost.mat';
    % Save the NNMFpost variable to a .mat file at the specified path
    save(fullfile(fullPath, filename), 'NNMFpost');
end

BMPtypes = props.BMP_analysis.btype;
if iscolumn(BMPtypes) % Check if BMPtypes is a column vector
    BMPtypes = BMPtypes'; % Transpose it to a row vector
end


% 10/21/2024 workaround for negative sptimes, idk why
if strcmp(fullPath, 'C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\24-06-07\10-21-2024rec3')
    flag = 1;
    disp("coming in here??????????")

else
    %call to get the nerve times
    nerveMatrix = gettingSpikeTimes3(nerveIdx,props.spikedetection.spikes,tm);
    nerveMatrix = round(nerveMatrix*1000);
    nerveX = spikeTimes2Logical(nerveMatrix);
    flag = mapHtoNerveGroups(H,nerveX);
end

% flag = mapHtoNerveGroups(H,nerveX);
% 
fprintf('The flag is a %d\n', flag);
% Check if the flag equals 1
H_flipped = H;
W_flipped = W;
if flag == 1
   % Flip row 1 with row 2 in matrix H
   H_flipped([1, 2], :) = H([2, 1], :);
   % Flip column 1 with column 2 in matrix W
   W_flipped(:, [1, 2]) = W(:, [2, 1]);
end
power = NNMFpost.power;

if attenuateFlag ==1
    [h,sortedcellIndicies,sortedW] = plotAllNeuronsStemSortedwSaveWOAttenuatedNeurons(X,H_flipped,W_flipped, BMPintervalTimes,BMPtypes, fullPath, power, NNMFpost.cellOrderIdx, mappedCellOrderIdx);
else
    [h,sortedcellIndicies,sortedW] = plotAllNeuronsStemSortedwSave(X,H_flipped,W_flipped, BMPintervalTimes,BMPtypes, fullPath, power, NNMFpost.cellOrderIdx);
end
% running the labeling of the neurons to have our images be pretty
rgbImage = props.imadj.imback;
greyImage = rgb2gray(rgbImage);
resizedImage = imresize(greyImage, [128 128]);

%making new det
originalSize = 256;
newSize = 128;
numElements = numel(props.det);

% Initialize the new indices array
newDet = zeros(size(props.det));

for i = 1:numElements
    if props.det(i) ~= 0  % Assuming 0s are separators or similar and should be preserved
        [y, x] = ind2sub([originalSize, originalSize], props.det(i));  % Get (x, y) coordinates for the old size
        newX = ceil(x / 2);
        newY = ceil(y / 2);
        newDet(i) = sub2ind([newSize, newSize], newY, newX);  % Convert to new linear index
    end
end
% Now `newDet` contains adjusted indices for a 128x128 image.

facLabels = ["retraction" "protraction"];
facColors = [85 136 198;... % Color for factor 1 (retraction) 
247 147 29]/256; % Color for factor 2 (protraction)

%added 2/7/2025, i'm going to try and send back my W and pixels so that I
%can try to overlap them when I return both of these back to main_pipline
W_all = {};
positions_all ={};
kernel_size_all ={};

for iii = 1:2
% loop through twice, for pro and ret    
    facIdx = strcmp(facLabels,facLabels(iii));
    W = sortedW(:,facIdx);
    if attenuateFlag ==1
        order = mappedCellOrderIdx(sortedcellIndicies) -17;
    else
        order = NNMFpost.cellOrderIdx;
    end
    gImage = resizedImage;
    det = newDet;
    color = facColors(iii,:);
    %labelNeuronsNNMFwSave(W,order,gImage,det,color, fullPath, iii);
    %added 2/7/2025 to test sending back normalized w and the pixels
    [~,~,~, W_temp, positions_temp,kernel_size_temp] = labelNeuronsNNMFwSave(W,order,gImage, det, color, fullPath, iii);
    W_all{iii} = W_temp;
    positions_all{iii} = positions_temp;
    kernel_size_all{iii} = kernel_size_temp;
end

%now let's try to isolate the BMPS, timestep is 100.
isolatedBumps = extractBumps(H_flipped,BMPintervalTimes, 100);

dataMatrixOG = plotIsolatedBumpswSave(isolatedBumps, BMPintervalTimes,fullPath);
% this saves the avg using the og data and not moving dashed line, aka
% normalizing the data
finalCells = plotNNProBumpswSave(dataMatrixOG, fullPath);

% After running plotNewNormBumps, this plots individual NN bmps and saves
dataMatrix = plotNewNormBumps(isolatedBumps, BMPintervalTimes, fullPath);

%this plots the average of normalized BMPs per experiment
NNfinalCells = plotNNAvgBumpswSave(dataMatrix,fullPath);

% %this plot individual average bumps, not normalized tho, i don't need this
% %tbh
% plotRetBumpswSave(isolatedBumps,fullPath);
% plotProBumpswSave(isolatedBumps,fullPath);

end