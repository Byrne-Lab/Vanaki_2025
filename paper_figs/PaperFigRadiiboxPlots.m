%% Load the variables
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNContCombinedKernelSizeALL.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNContCombinedPositionsAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNContCombinedWAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNYokeCombinedWAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNYokeCombinedPositionsAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNYokeCombinedKernelSizeALL.mat');

% Initialize variables
numExperiments = size(NNContCombinedKernelSizeALL, 1);
averageRadiiCont = zeros(2, numExperiments); % Average Contingent radii
averageRadiiYoke = zeros(2, numExperiments); % Average Yoke radii

%% Function to calculate the radius from kernel size
calculateRadius = @(kernelSize) sqrt(kernelSize / pi);

% Loop through each experiment for contingent and yoke conditions
for exp = 1:numExperiments
    for col_index = 1:2 % Retraction and protraction columns
        % Get the weights and kernel sizes for contingent and yoked conditions
        WCont = NNContCombinedWAll{exp, col_index};
        kernelSizesCont = NNContCombinedKernelSizeALL{exp, col_index};
        WYoke = NNYokeCombinedWAll{exp, col_index};
        kernelSizesYoke = NNYokeCombinedKernelSizeALL{exp, col_index};

        % Identify neurons with contribution factor of 0.4 or higher
        topCont = find(WCont >= 0.4);
        topYoke = find(WYoke >= 0.4);

        % Calculate the average radii for the top weighted neurons
        radiiCont = calculateRadius(kernelSizesCont(topCont));
        radiiYoke = calculateRadius(kernelSizesYoke(topYoke));
        
        averageRadiiCont(col_index, exp) = mean(radiiCont); % Regular average
        averageRadiiYoke(col_index, exp) = mean(radiiYoke); % Regular average
    end
end

% Combine radii across all experiments for retraction and protraction
combinedRadiiContRetraction = reshape(averageRadiiCont(1, :), [], 1);
combinedRadiiContProtraction = reshape(averageRadiiCont(2, :), [], 1);
combinedRadiiYokeRetraction = reshape(averageRadiiYoke(1, :), [], 1);
combinedRadiiYokeProtraction = reshape(averageRadiiYoke(2, :), [], 1);

%% Create a figure for Retraction Module Radii
h1 = figure('Name', 'Retraction Module Radii');
h = boxplot([combinedRadiiContRetraction, combinedRadiiYokeRetraction], 'Labels', {'Contingent', 'Yoked'}, 'Colors', 'k');
set(h, {'LineStyle'}, {'-'});
set(h, {'LineWidth'}, {1.5});
set(findobj(gca,'Tag','Box'), 'Color', 'k');
set(findobj(gca,'Tag','Median'), 'Color', 'k');
set(findobj(gca,'Tag','Whisker'), 'Color', 'k');
set(findobj(gca,'Tag','Outliers'), 'MarkerEdgeColor', 'k');
boxes = findobj(gca, 'Tag', 'Box');
patch(get(boxes(2), 'XData'), get(boxes(2), 'YData'), [0, 100/255, 0], 'FaceAlpha', 0.7);  % Dark green fill for contingent
patch(get(boxes(1), 'XData'), get(boxes(1), 'YData'), [0.5, 0.5, 0.5], 'FaceAlpha', 0.7);  % Grey fill for yoked
hold on;
for i = 1:length(combinedRadiiContRetraction)
    plot([1.3, 1.7], [combinedRadiiContRetraction(i), combinedRadiiYokeRetraction(i)], 'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end
hold off;
ylim([0 15]); % Set y-axis limits
ylabel('Avg Radius', 'FontSize', 20);
set(gca, 'FontSize', 20); % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
title('');

% Save the first figure
savePath1 = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL', 'BoxPlotsRetractionRadii03172025.png');
saveas(h1, savePath1);
close(h1); % Close the first figure

%% Create a figure for Protraction Module Radii
h2 = figure('Name', 'Protraction Module Radii');
h = boxplot([combinedRadiiContProtraction, combinedRadiiYokeProtraction], 'Labels', {'Contingent', 'Yoked'}, 'Colors', 'k');
set(h, {'LineStyle'}, {'-'});
set(h, {'LineWidth'}, {1.5});
set(findobj(gca,'Tag','Box'), 'Color', 'k');
set(findobj(gca,'Tag','Median'), 'Color', 'k');
set(findobj(gca,'Tag','Whisker'), 'Color', 'k');
set(findobj(gca,'Tag','Outliers'), 'MarkerEdgeColor', 'k');
boxes = findobj(gca, 'Tag', 'Box');
patch(get(boxes(2), 'XData'), get(boxes(2), 'YData'), [0, 100/255, 0], 'FaceAlpha', 0.7);  % Dark green fill for contingent
patch(get(boxes(1), 'XData'), get(boxes(1), 'YData'), [0.5, 0.5, 0.5], 'FaceAlpha', 0.7);  % Grey fill for yoked
hold on;
for i = 1:length(combinedRadiiContProtraction)
    plot([1.3, 1.7], [combinedRadiiContProtraction(i), combinedRadiiYokeProtraction(i)], 'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end
hold off;
ylim([0 15]); % Set y-axis limits
ylabel('Avg Radius', 'FontSize', 20);
set(gca, 'FontSize', 20); % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
title('');

% Save the second figure
savePath2 = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL', 'BoxPlotsProtractionRadii03172025.png');
saveas(h2, savePath2);
close(h2); % Close the second figure

%% Wilcoxon test
% Perform the Wilcoxon signed-rank test for retraction and protraction
[p_retraction, h_retraction, stats_retraction] = signrank(combinedRadiiContRetraction, combinedRadiiYokeRetraction);
[p_protraction, h_protraction, stats_protraction] = signrank(combinedRadiiContProtraction, combinedRadiiYokeProtraction);

% Display the results
disp('Retraction:');
disp(['Wilcoxon signed-rank test p-value: ', num2str(p_retraction)]);
if p_retraction < 0.05
    disp('The radii for retraction are significantly different between contingent and yoke conditions.');
else
    disp('The radii for retraction are not significantly different between contingent and yoke conditions.');
end

disp('Protraction:');
disp(['Wilcoxon signed-rank test p-value: ', num2str(p_protraction)]);
if p_protraction < 0.05
    disp('The radii for protraction are significantly different between contingent and yoke conditions.');
else
    disp('The radii for protraction are not significantly different between contingent and yoke conditions.');
end