%% Step 1: gather data

% Initialize combined data arrays for all folders2H
combinedContEven = [];
combinedContOdd = [];
combinedYokeEven = [];
combinedYokeOdd = [];

% Define list of folders
folders = {'results02192025rec2HL'};
% Loop through each folder to load and concatenate data
for i = 1:length(folders)
    folder = folders{i};

    % Construct paths to contingent and yoked data files
    contPath = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\', folder, 'NNContCombinedDataCells.mat');
    yokePath = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\', folder, 'NNYokeCombinedDataCells.mat');

    % Load contingent and yoked data
    load(contPath);
    load(yokePath);

    % Concatenate data across folders
    combinedContEven = [combinedContEven; cell2mat(NNContCombinedDataCells(:, 2))];
    combinedContOdd = [combinedContOdd; cell2mat(NNContCombinedDataCells(:, 1))];
    combinedYokeEven = [combinedYokeEven; cell2mat(NNYokeCombinedDataCells(:, 2))];
    combinedYokeOdd = [combinedYokeOdd; cell2mat(NNYokeCombinedDataCells(:, 1))];
end

% Define the smoothing window size
windowSize = 200;

% Calculate mean and standard error for Cont and Yoke datasets
smoothedContEven = smoothData(nanmean(combinedContEven, 1), windowSize);
smoothedContOdd = smoothData(nanmean(combinedContOdd, 1), windowSize);
contStdErrorEven = nanstd(combinedContEven, 0, 1) ./ sqrt(sum(~isnan(combinedContEven), 1));
contStdErrorOdd = nanstd(combinedContOdd, 0, 1) ./ sqrt(sum(~isnan(combinedContOdd), 1));

smoothedYokeEven = smoothData(nanmean(combinedYokeEven, 1), windowSize);
smoothedYokeOdd = smoothData(nanmean(combinedYokeOdd, 1), windowSize);
yokeStdErrorEven = nanstd(combinedYokeEven, 0, 1) ./ sqrt(sum(~isnan(combinedYokeEven), 1));
yokeStdErrorOdd = nanstd(combinedYokeOdd, 0, 1) ./ sqrt(sum(~isnan(combinedYokeOdd), 1));


%% Step 2: graph retraction module

% Plot the combined data with standard error shading
h = figure;
hold on;

% Plot Retraction (solid) with shading for Contingent
fill([linspace(0, 1, size(combinedContEven, 2)), fliplr(linspace(0, 1, size(combinedContEven, 2)))], ...
     [smoothedContEven + contStdErrorEven, fliplr(smoothedContEven - contStdErrorEven)], ...
     [0, 0.4470, 0.7410], 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Light red shading
plot(linspace(0, 1, size(combinedContEven, 2)), smoothedContEven, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 2);



% Plot Retraction (dashed) with shading for Yoked
fill([linspace(0, 1, size(combinedYokeEven, 2)), fliplr(linspace(0, 1, size(combinedYokeEven, 2)))], ...
     [smoothedYokeEven + yokeStdErrorEven, fliplr(smoothedYokeEven - yokeStdErrorEven)], ...
     [0.5, 0.5, 0.5], 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Grey shading
plot(linspace(0, 1, size(combinedYokeEven, 2)), smoothedYokeEven,  'Color', [0, 0.4470, 0.7410],  'LineWidth', 2, 'LineStyle', '--');



% Set the y-axis limits and ticks
ylim([0 0.018]);
yticks(0:0.005:0.02);
xline(0.5, '--', 'Color', [0,0,0], 'HandleVisibility', 'off');

% Add labels and legend
xlabel('Time (Normalized)'); % Adjust the number to your desired font size
ylabel('Magnitude'); % Adjust the number to your desired font size

legend('Cont. Error', 'Cont. Avg',  ...
       'Yoke Error', 'Yoke Avg',  ...
       'Location', 'northwest');

ax = gca;
ax.XLabel.FontSize = 14; % Adjust the number to your desired font size
ax.YLabel.FontSize = 14; % Adjust the number to your desired font size
ax.XAxis.FontSize = 14; % Adjust the number to your desired font size
ax.YAxis.FontSize = 14; % Adjust the number to your desired font size

hold off;
%grid on;
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness


% Save the figure
savePath = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results02192025rec2HL', '03282025Onlyretraction.png');
saveas(h, savePath);
close(h);


%% Step 2: graph retraction module

% Plot the combined data with standard error shading
h = figure;
hold on;


% Plot Protraction (solid) with shading for Contingent
fill([linspace(0, 1, size(combinedContOdd, 2)), fliplr(linspace(0, 1, size(combinedContOdd, 2)))], ...
     [smoothedContOdd + contStdErrorOdd, fliplr(smoothedContOdd - contStdErrorOdd)], ...
     [0.8500, 0.3250, 0.0980], 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Light blue shading
plot(linspace(0, 1, size(combinedContOdd, 2)), smoothedContOdd, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2);


%Plot Protraction (dashed) with shading for Yoked
fill([linspace(0, 1, size(combinedYokeOdd, 2)), fliplr(linspace(0, 1, size(combinedYokeOdd, 2)))], ...
     [smoothedYokeOdd + yokeStdErrorOdd, fliplr(smoothedYokeOdd - yokeStdErrorOdd)], ...
     [0.5, 0.5, 0.5], 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Grey shading
plot(linspace(0, 1, size(combinedYokeOdd, 2)), smoothedYokeOdd, 'Color', [0.8500, 0.3250, 0.0980],  'LineWidth', 2, 'LineStyle', '--');

% Set the y-axis limits and ticks
ylim([0 0.02]);
yticks(0:0.005:0.02);
xline(0.5, '--', 'Color', [0,0,0], 'HandleVisibility', 'off');

% Add labels and legend
xlabel('Time (Normalized)');
ylabel('Magnitude');

%2/24/2025 this is just to plot pro
legend('Cont. Error', 'Cont. Avg',  ...
       'Yoke Error', 'Yoke Avg',  ...
       'Location', 'northeast');

ax = gca;
ax.XLabel.FontSize = 14; % Adjust the number to your desired font size
ax.YLabel.FontSize = 14; % Adjust the number to your desired font size
ax.XAxis.FontSize = 14; % Adjust the number to your desired font size
ax.YAxis.FontSize = 14; % Adjust the number to your desired font size
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness

hold off;
%grid on;

% Save the figure
savePath = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results02192025rec2HL', '03272025Onlyprotraction.png');
saveas(h, savePath);
close(h);

%% Function to smooth the data

function smoothedData = smoothData(data, windowSize)
    if windowSize > length(data)
        windowSize = length(data); % Ensure the window size is not greater than the data length
    end
    smoothedData = movmean(data, windowSize);
end