% 5/24/2024, updated 10/2/2024 main pipeline
% Sara Vanaki - Iterative adjustment of spike detections
% going to be making a script that goes through all our current spiking
% data and thresholds them

% Define the main directory containing the subfolders
baseDir = "C:\yourName\ your (spike analyzed) recordings"; % Change this to your directory path

% Get a list of all subfolders
d = dir(baseDir);
isub = [d(:).isdir]; % Returns logical vector
subFolders = {d(isub).name}';
subFolders(ismember(subFolders,{'.','..'})) = []; % Remove '.' and '..' directories

% Define the lists of dates
cont_dates = [
    "23-05-30",
    "23-08-25",
    "23-12-01-1",
    "23-12-08-1",
    "23-12-15-1",
    "24-03-01",
    "24-04-26",
    "24-05-24",
    "24-06-06",
    "24-07-19-1",
    "24-08-15"
];

yoke_dates = [
    "23-06-06",
    "23-09-01",
    "23-12-01-2",
    "23-12-08-2",
    "23-12-15-2",
    "24-03-08",
    "24-05-03",
    "24-05-30",
    "24-06-07",
    "24-08-09",
    "24-08-20"
];


% Initialize global storage for combined data, 
combinedDataCells = {};
combinedWAll = [];
combinedPositionsAll = [];
combinedKernelSizeALL = [];

% Check each subfolder for the file, only if it is in the dates_list
for i = 1:length(subFolders)
    if any(strcmp(subFolders{i}, redo_dates))
        folderPath = fullfile(baseDir, subFolders{i});
        filePath = fullfile(folderPath, '002_filtered.mat');
        if exist(filePath, 'file') == 2
            fprintf('File found in: %s\n', folderPath);
            [finalCells, WAll, positionsAll, kernel_sizeALL] = testDetectionAlgo06102024(filePath, folderPath);
            
            if iscell(finalCells)
                combinedDataCells = [combinedDataCells; finalCells];
            else
                warning('finalCells is not a cell array. Skipping this folder: %s\n', folderPath);
            end
            
            combinedWAll = [combinedWAll; WAll];
            combinedPositionsAll = [combinedPositionsAll; positionsAll];
            combinedKernelSizeALL = [combinedKernelSizeALL; kernel_sizeALL];
        else
            fprintf('File not found in: %s\n', folderPath);
        end
    end
end

% Display the combined results
disp('Combined Data Cells:');
disp(combinedDataCells);
disp('Combined WAll:');
disp(combinedWAll);
disp('Combined Positions All:');
disp(combinedPositionsAll);
disp('Combined Kernel Size ALL:');
disp(combinedKernelSizeALL);

% Debug print to check the structure of combinedDataCells
disp('Structure of combinedDataCells:');
disp(combinedDataCells);

