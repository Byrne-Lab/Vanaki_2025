%% Load your data
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNContCombinedDataCells.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNYokeCombinedDataCells.mat');


%% Calculate peaks
% Calculate peak retraction times
contPeakTimesRetraction = arrayfun(@(x) find(max(NNContCombinedDataCells{x, 2}) == NNContCombinedDataCells{x, 2}) / 10000, 1:size(NNContCombinedDataCells, 1));
yokePeakTimesRetraction = arrayfun(@(x) find(max(NNYokeCombinedDataCells{x, 2}) == NNYokeCombinedDataCells{x, 2}) / 10000, 1:size(NNYokeCombinedDataCells, 1));

% Calculate peak protraction times
contPeakTimesProtraction = arrayfun(@(x) find(max(NNContCombinedDataCells{x, 1}) == NNContCombinedDataCells{x, 1}) / 10000, 1:size(NNContCombinedDataCells, 1));
yokePeakTimesProtraction = arrayfun(@(x) find(max(NNYokeCombinedDataCells{x, 1}) == NNYokeCombinedDataCells{x, 1}) / 10000, 1:size(NNYokeCombinedDataCells, 1));

%% Figure 1

% Create a figure for Retraction Module Peak Time
h1 = figure('Name', 'Retraction Module Peak Time');

% Retraction Module Peak Time
h = boxplot([contPeakTimesRetraction', yokePeakTimesRetraction'], 'Labels', {'Contingent', 'Yoked'}, 'Colors', 'k','Symbol','');
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
for i = 1:length(contPeakTimesRetraction)
    plot([1.3, 1.7], [contPeakTimesRetraction(i), yokePeakTimesRetraction(i)], 'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end
hold off;
ylim([0 1]); % Set y-axis limits
ylabel('Peak time (normalized)', 'FontSize', 20);
set(gca, 'FontSize', 20); % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness


title('');

% Save the first figure
savePath1 = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL', 'BoxPlotsRetractionTime04152025.png');
saveas(h1, savePath1);
exportgraphics(gcf, 'C:\Sara\rice\freshman year\uthealth\paperfigs\05212025retractiontime.pdf', 'ContentType', 'vector');
close(h1); % Close the first figure


%% figure 2
% Create a figure for Protraction Module Peak Time
h2 = figure('Name', 'Protraction Module Peak Time');

% Protraction Module Peak Time
h = boxplot([contPeakTimesProtraction', yokePeakTimesProtraction'], 'Labels', {'Contingent', 'Yoked'}, 'Colors', 'k','Symbol','');
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
for i = 1:length(contPeakTimesProtraction)
    plot([1.3, 1.7], [contPeakTimesProtraction(i), yokePeakTimesProtraction(i)], 'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end
hold off;
ylim([0 1]); % Set y-axis limits
ylabel('Peak time (normalized)', 'FontSize', 20);
set(gca, 'FontSize', 20); % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness


title('');

% Save the second figure
savePath2 = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL', 'BoxPlotsProtractionTime04152025.png');
saveas(h2, savePath2);
exportgraphics(gcf, 'C:\Sara\rice\freshman year\uthealth\paperfigs\05212025protractiontime.pdf', 'ContentType', 'vector');
close(h2); % Close the second figure

%% 3rd figure

% Create a figure for Retraction Module Peak Magnitude
h3 = figure('Name', 'Retraction Module Peak Magnitude');

% Calculate peak retraction magnitudes
contPeakMagnitudesRetraction = arrayfun(@(x) max(NNContCombinedDataCells{x, 2}), 1:size(NNContCombinedDataCells, 1));
yokePeakMagnitudesRetraction = arrayfun(@(x) max(NNYokeCombinedDataCells{x, 2}), 1:size(NNYokeCombinedDataCells, 1));

% Calculate peak protraction magnitudes
contPeakMagnitudesProtraction = arrayfun(@(x) max(NNContCombinedDataCells{x, 1}), 1:size(NNContCombinedDataCells, 1));
yokePeakMagnitudesProtraction = arrayfun(@(x) max(NNYokeCombinedDataCells{x, 1}), 1:size(NNYokeCombinedDataCells, 1));
% Retraction Module Peak Magnitude
h = boxplot([contPeakMagnitudesRetraction', yokePeakMagnitudesRetraction'], 'Labels', {'Contingent', 'Yoked'}, 'Colors', 'k','Symbol','');
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
for i = 1:length(contPeakMagnitudesRetraction)
    plot([1.3, 1.7], [contPeakMagnitudesRetraction(i), yokePeakMagnitudesRetraction(i)], 'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end
hold off;
ylim([0 .05]); % Set y-axis limits
ylabel('Peak Magnitude', 'FontSize', 20);
set(gca, 'FontSize', 20); % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness


title('');

% Save the third figure
savePath3 = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL', 'BoxPlotsRetractionMagnitude04152025.png');
saveas(h3, savePath3);
exportgraphics(gcf, 'C:\Sara\rice\freshman year\uthealth\paperfigs\05212025retractionmag.pdf', 'ContentType', 'vector');

close(h3); % Close the third figure

%% 4th figure

% Create a figure for Protraction Module Peak Magnitude
h4 = figure('Name', 'Protraction Module Peak Magnitude');

% Protraction Module Peak Magnitude
h = boxplot([contPeakMagnitudesProtraction', yokePeakMagnitudesProtraction'], 'Labels', {'Contingent', 'Yoked'}, 'Colors', 'k','Symbol','');
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
for i = 1:length(contPeakMagnitudesProtraction)
    plot([1.3, 1.7], [contPeakMagnitudesProtraction(i), yokePeakMagnitudesProtraction(i)], 'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end
hold off;
ylim([0 .05]); % Set y-axis limits
ylabel('Peak Magnitude', 'FontSize', 20);
set(gca, 'FontSize', 20); % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness


title('');

% Save the fourth figure
savePath4 = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL', 'BoxPlotsProtractionMagnitude04152025.png');
saveas(h4, savePath4);
exportgraphics(gcf, 'C:\Sara\rice\freshman year\uthealth\paperfigs\05212025protractionmag.pdf', 'ContentType', 'vector');
close(h4); % Close the fourth figure


%% Running Wilcoxon test
% % Performing Wilcoxon signed-rank test for retraction peak times
[pRetraction, hRetraction, statsRetraction] = signrank(contPeakTimesRetraction, yokePeakTimesRetraction);
% Display results for retraction peak times
fprintf('Wilcoxon signed-rank test for retraction peak times:\n');
fprintf('p-value: %f\n', pRetraction);
fprintf('Test decision (h): %d\n', hRetraction);
disp('Test statistics:');
disp(statsRetraction);
% % Performing Wilcoxon signed-rank test for protraction peak times
[pProtraction, hProtraction, statsProtraction] = signrank(contPeakTimesProtraction, yokePeakTimesProtraction);
% Display results for protraction peak times
fprintf('Wilcoxon signed-rank test for protraction peak times:\n');
fprintf('p-value: %f\n', pProtraction);
fprintf('Test decision (h): %d\n', hProtraction);
disp('Test statistics:');
disp(statsProtraction);

% % Performing Wilcoxon signed-rank test for retraction peak magnitudes
[pRetraction, hRetraction, statsRetraction] = signrank(contPeakMagnitudesRetraction, yokePeakMagnitudesRetraction);
% Display results for retraction peak magnitudes
fprintf('Wilcoxon signed-rank test for retraction peak magnitudes:\n');
fprintf('p-value: %f\n', pRetraction);
fprintf('Test decision (h): %d\n', hRetraction);
disp('Test statistics:');
disp(statsRetraction);
% % Performing Wilcoxon signed-rank test for protraction peak magnitudes
[pProtraction, hProtraction, statsProtraction] = signrank(contPeakMagnitudesProtraction, yokePeakMagnitudesProtraction);
% Display results for protraction peak magnitudes
fprintf('Wilcoxon signed-rank test for protraction peak magnitudes:\n');
fprintf('p-value: %f\n', pProtraction);
fprintf('Test decision (h): %d\n', hProtraction);
disp('Test statistics:');
disp(statsProtraction);

%% get the mean +- stnd error
% Retraction Time
mean_contRet = mean(contPeakTimesRetraction);
mean_yokeRet = mean(yokePeakTimesRetraction);
se_contRet = std(contPeakTimesRetraction)/sqrt(length(contPeakTimesRetraction));
se_yokeRet = std(yokePeakTimesRetraction)/sqrt(length(yokePeakTimesRetraction));

% Protraction Time
mean_contPro = mean(contPeakTimesProtraction);
mean_yokePro = mean(yokePeakTimesProtraction);
se_contPro = std(contPeakTimesProtraction)/sqrt(length(contPeakTimesProtraction));
se_yokePro = std(yokePeakTimesProtraction)/sqrt(length(yokePeakTimesProtraction));

% Retraction Magnitude
mean_contMagRet = mean(contPeakMagnitudesRetraction);
mean_yokeMagRet = mean(yokePeakMagnitudesRetraction);
se_contMagRet = std(contPeakMagnitudesRetraction)/sqrt(length(contPeakMagnitudesRetraction));
se_yokeMagRet = std(yokePeakMagnitudesRetraction)/sqrt(length(yokePeakMagnitudesRetraction));

% Protraction Magnitude
mean_contMagPro = mean(contPeakMagnitudesProtraction);
mean_yokeMagPro = mean(yokePeakMagnitudesProtraction);
se_contMagPro = std(contPeakMagnitudesProtraction)/sqrt(length(contPeakMagnitudesProtraction));
se_yokeMagPro = std(yokePeakMagnitudesProtraction)/sqrt(length(yokePeakMagnitudesProtraction));

% Display
fprintf('\n--- Retraction Time ---\n');
fprintf('Contingent: %.3f ± %.3f\n', mean_contRet, se_contRet);
fprintf('Yoked:      %.3f ± %.3f\n', mean_yokeRet, se_yokeRet);

fprintf('\n--- Protraction Time ---\n');
fprintf('Contingent: %.3f ± %.3f\n', mean_contPro, se_contPro);
fprintf('Yoked:      %.3f ± %.3f\n', mean_yokePro, se_yokePro);

fprintf('\n--- Retraction Magnitude ---\n');
fprintf('Contingent: %.3f ± %.3f\n', mean_contMagRet, se_contMagRet);
fprintf('Yoked:      %.3f ± %.3f\n', mean_yokeMagRet, se_yokeMagRet);

fprintf('\n--- Protraction Magnitude ---\n');
fprintf('Contingent: %.3f ± %.3f\n', mean_contMagPro, se_contMagPro);
fprintf('Yoked:      %.3f ± %.3f\n', mean_yokeMagPro, se_yokeMagPro);

%% get the median ± IQR
% Retraction Time
median_contRet = median(contPeakTimesRetraction);
median_yokeRet = median(yokePeakTimesRetraction);
iqr_contRet = iqr(contPeakTimesRetraction);
iqr_yokeRet = iqr(yokePeakTimesRetraction);

% Protraction Time
median_contPro = median(contPeakTimesProtraction);
median_yokePro = median(yokePeakTimesProtraction);
iqr_contPro = iqr(contPeakTimesProtraction);
iqr_yokePro = iqr(yokePeakTimesProtraction);

% Retraction Magnitude
median_contMagRet = median(contPeakMagnitudesRetraction);
median_yokeMagRet = median(yokePeakMagnitudesRetraction);
iqr_contMagRet = iqr(contPeakMagnitudesRetraction);
iqr_yokeMagRet = iqr(yokePeakMagnitudesRetraction);

% Protraction Magnitude
median_contMagPro = median(contPeakMagnitudesProtraction);
median_yokeMagPro = median(yokePeakMagnitudesProtraction);
iqr_contMagPro = iqr(contPeakMagnitudesProtraction);
iqr_yokeMagPro = iqr(yokePeakMagnitudesProtraction);

% Display
fprintf('\n--- Retraction Time ---\n');
fprintf('Contingent: %.3f ± %.3f\n', median_contRet, iqr_contRet);
fprintf('Yoked:      %.3f ± %.3f\n', median_yokeRet, iqr_yokeRet);

fprintf('\n--- Protraction Time ---\n');
fprintf('Contingent: %.3f ± %.3f\n', median_contPro, iqr_contPro);
fprintf('Yoked:      %.3f ± %.3f\n', median_yokePro, iqr_yokePro);

fprintf('\n--- Retraction Magnitude ---\n');
fprintf('Contingent: %.3f ± %.3f\n', median_contMagRet, iqr_contMagRet);
fprintf('Yoked:      %.3f ± %.3f\n', median_yokeMagRet, iqr_yokeMagRet);

fprintf('\n--- Protraction Magnitude ---\n');
fprintf('Contingent: %.3f ± %.3f\n', median_contMagPro, iqr_contMagPro);
fprintf('Yoked:      %.3f ± %.3f\n', median_yokeMagPro, iqr_yokeMagPro);
