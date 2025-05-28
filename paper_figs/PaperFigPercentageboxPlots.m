%% Load the variables
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNContCombinedKernelSizeALL.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNContCombinedPositionsAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNContCombinedWAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNYokeCombinedWAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNYokeCombinedPositionsAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNYokeCombinedKernelSizeALL.mat');

% Initialize variables
numExperiments = size(NNContCombinedKernelSizeALL, 1);

% Initialize arrays to store percentages
percentagesContRetraction = zeros(1, numExperiments);
percentagesContProtraction = zeros(1, numExperiments);
percentagesYokeRetraction = zeros(1, numExperiments);
percentagesYokeProtraction = zeros(1, numExperiments);

% Calculate total neurons for contingent and yoke conditions
totalNeuronsCont = cellfun(@numel, NNContCombinedWAll(:, 1));
totalNeuronsYoke = cellfun(@numel, NNYokeCombinedWAll(:, 1));

%% Calculate percentages for each experiment
for exp = 1:numExperiments
    % Identify neurons with contribution factor of 0.4 or higher
    numNeuronsContHighContribution = cellfun(@(x) sum(x >= 0.4), NNContCombinedWAll(exp, :));
    numNeuronsYokeHighContribution = cellfun(@(x) sum(x >= 0.4), NNYokeCombinedWAll(exp, :));
    
    percentagesContRetraction(exp) = (numNeuronsContHighContribution(1) / totalNeuronsCont(exp)) * 100;
    percentagesContProtraction(exp) = (numNeuronsContHighContribution(2) / totalNeuronsCont(exp)) * 100;
    percentagesYokeRetraction(exp) = (numNeuronsYokeHighContribution(1) / totalNeuronsYoke(exp)) * 100;
    percentagesYokeProtraction(exp) = (numNeuronsYokeHighContribution(2) / totalNeuronsYoke(exp)) * 100;
end

% Perform Wilcoxon signed-rank test
[p_retraction, h_retraction, stats_retraction] = signrank(percentagesContRetraction, percentagesYokeRetraction);
[p_protraction, h_protraction, stats_protraction] = signrank(percentagesContProtraction, percentagesYokeProtraction);

% Display Wilcoxon test results
disp('Retraction:');
disp(['Wilcoxon signed-rank test p-value: ', num2str(p_retraction)]);
if p_retraction < 0.05
    disp('The percentages for retraction are significantly different between contingent and yoke conditions.');
    disp('Test statistics:');
    disp(stats_retraction);
else
    disp('The percentages for retraction are not significantly different between contingent and yoke conditions.');
end

disp('Protraction:');
disp(['Wilcoxon signed-rank test p-value: ', num2str(p_protraction)]);
if p_protraction < 0.05
    disp('The percentages for protraction are significantly different between contingent and yoke conditions.');
else
    disp('The percentages for protraction are not significantly different between contingent and yoke conditions.');
    disp('Test statistics:');
    disp(stats_protraction);
end

%% Create a figure for Retraction Module Percentages
h1 = figure('Name', 'Retraction Module Percentages');
h = boxplot([percentagesContRetraction', percentagesYokeRetraction'], 'Labels', {'Contingent', 'Yoked'}, 'Colors', 'k','Symbol','');
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
for i = 1:length(percentagesContRetraction)
    plot([1.3, 1.7], [percentagesContRetraction(i), percentagesYokeRetraction(i)], 'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end
hold off;
ylim([0 60]); % Set y-axis limits
ylabel('% of neurons', 'FontSize', 20);
set(gca, 'FontSize', 20); % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness

title('');

% Save the first figure
savePath1 = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL', 'BoxPlotsRetractionPercentages03272025.png');
saveas(h1, savePath1);
exportgraphics(gcf, 'C:\Sara\rice\freshman year\uthealth\paperfigs\05212025retractionpercentage.pdf', 'ContentType', 'vector');

close(h1); % Close the first figure

%% Create a figure for Protraction Module Percentages
h2 = figure('Name', 'Protraction Module Percentages');
h = boxplot([percentagesContProtraction', percentagesYokeProtraction'], 'Labels', {'Contingent', 'Yoked'}, 'Colors', 'k','Symbol','');
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
for i = 1:length(percentagesContProtraction)
    plot([1.3, 1.7], [percentagesContProtraction(i), percentagesYokeProtraction(i)], 'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end
hold off;
ylim([0 60]); % Set y-axis limits
ylabel('% of neurons', 'FontSize', 20);
set(gca, 'FontSize', 20); % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness

title('');

% Save the second figure
savePath2 = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL', 'BoxPlotsProtractionPercentages03272025.png');
saveas(h2, savePath2);
exportgraphics(gcf, 'C:\Sara\rice\freshman year\uthealth\paperfigs\05212025protractionpercentage.pdf', 'ContentType', 'vector');

close(h2); % Close the second figure

% %% addding code for printing mean +- stnd error
% 
% % Calculate and display mean ± standard error for percentages
% 
% % Retraction
% meanContRetraction = mean(percentagesContRetraction);
% stderrContRetraction = std(percentagesContRetraction) / sqrt(length(percentagesContRetraction));
% disp(['Contingent Retraction: ', num2str(meanContRetraction, '%.2f'), ' ± ', num2str(stderrContRetraction, '%.2f'), '%']);
% 
% meanYokeRetraction = mean(percentagesYokeRetraction);
% stderrYokeRetraction = std(percentagesYokeRetraction) / sqrt(length(percentagesYokeRetraction));
% disp(['Yoked Retraction: ', num2str(meanYokeRetraction, '%.2f'), ' ± ', num2str(stderrYokeRetraction, '%.2f'), '%']);
% 
% % Protraction
% meanContProtraction = mean(percentagesContProtraction);
% stderrContProtraction = std(percentagesContProtraction) / sqrt(length(percentagesContProtraction));
% disp(['Contingent Protraction: ', num2str(meanContProtraction, '%.2f'), ' ± ', num2str(stderrContProtraction, '%.2f'), '%']);
% 
% meanYokeProtraction = mean(percentagesYokeProtraction);
% stderrYokeProtraction = std(percentagesYokeProtraction) / sqrt(length(percentagesYokeProtraction));
% disp(['Yoked Protraction: ', num2str(meanYokeProtraction, '%.2f'), ' ± ', num2str(stderrYokeProtraction, '%.2f'), '%']);

%% Adding code for printing median ± IQR

% Calculate and display median ± IQR for percentages

% Retraction
medianContRetraction = median(percentagesContRetraction);
iqrContRetraction = iqr(percentagesContRetraction);
disp(['Contingent Retraction: ', num2str(medianContRetraction, '%.2f'), ' ± ', num2str(iqrContRetraction, '%.2f'), '%']);

medianYokeRetraction = median(percentagesYokeRetraction);
iqrYokeRetraction = iqr(percentagesYokeRetraction);
disp(['Yoked Retraction: ', num2str(medianYokeRetraction, '%.2f'), ' ± ', num2str(iqrYokeRetraction, '%.2f'), '%']);

% Protraction
medianContProtraction = median(percentagesContProtraction);
iqrContProtraction = iqr(percentagesContProtraction);
disp(['Contingent Protraction: ', num2str(medianContProtraction, '%.2f'), ' ± ', num2str(iqrContProtraction, '%.2f'), '%']);

medianYokeProtraction = median(percentagesYokeProtraction);
iqrYokeProtraction = iqr(percentagesYokeProtraction);
disp(['Yoked Protraction: ', num2str(medianYokeProtraction, '%.2f'), ' ± ', num2str(iqrYokeProtraction, '%.2f'), '%']);
