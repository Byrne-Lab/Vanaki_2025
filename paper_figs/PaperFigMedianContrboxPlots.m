%% Load the variables
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNContCombinedKernelSizeALL.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNContCombinedPositionsAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNContCombinedWAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNYokeCombinedWAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNYokeCombinedPositionsAll.mat');
load('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL\NNYokeCombinedKernelSizeALL.mat');

% Initialize variables
numExperiments = size(NNContCombinedKernelSizeALL, 1);
medianContributionsCont = zeros(2, numExperiments); % Median contributions for Contingent
medianContributionsYoke = zeros(2, numExperiments); % Median contributions for Yoke

%% Loop through each experiment for contingent and yoke conditions
for exp = 1:numExperiments
    for col_index = 1:2 % Retraction and protraction columns
        % Get the weights for contingent and yoked conditions
        WCont = NNContCombinedWAll{exp, col_index};
        WYoke = NNYokeCombinedWAll{exp, col_index};

        % Calculate median contributions
        medianContributionsCont(col_index, exp) = median(WCont);
        medianContributionsYoke(col_index, exp) = median(WYoke);
    end
end

%% Create a figure for Retraction Module Median Contributions
h1 = figure('Name', 'Retraction Module Median Contributions');
h = boxplot([medianContributionsCont(1, :)', medianContributionsYoke(1, :)'], 'Labels', {'Contingent', 'Yoked'}, 'Colors', 'k');
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
for i = 1:length(medianContributionsCont(1, :))
    plot([1.3, 1.7], [medianContributionsCont(1, i), medianContributionsYoke(1, i)], 'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end
hold off;
ylim([0 0.6]); % Set y-axis limits
ylabel('Median Contribution', 'FontSize', 20);
set(gca, 'FontSize', 20); % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness

title('');

% Save the first figure
savePath1 = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL', 'BoxPlotsRetractionMedian0to.6Contributions05212025.png');
saveas(h1, savePath1);
exportgraphics(gcf, 'C:\Sara\rice\freshman year\uthealth\paperfigs\05212025retractionmedian.pdf', 'ContentType', 'vector');

close(h1); % Close the first figure

%% Create a figure for Protraction Module Median Contributions
h2 = figure('Name', 'Protraction Module Median Contributions');
h = boxplot([medianContributionsCont(2, :)', medianContributionsYoke(2, :)'], 'Labels', {'Contingent', 'Yoked'}, 'Colors', 'k');
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
for i = 1:length(medianContributionsCont(2, :))
    plot([1.3, 1.7], [medianContributionsCont(2, i), medianContributionsYoke(2, i)], 'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end
hold off;
ylim([0 0.6]); % Set y-axis limits
ylabel('Median Contribution', 'FontSize', 20);
set(gca, 'FontSize', 20); % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness

title('');

% Save the second figure
savePath2 = fullfile('C:\Sara\rice\freshman year\uthealth\Completed (spike analyzed) recordings\results03172025rec2HL', 'BoxPlotsProtractionMedian0to.6Contributions05212025.png');
saveas(h2, savePath2);
exportgraphics(gcf, 'C:\Sara\rice\freshman year\uthealth\paperfigs\05212025protractionmedian.pdf', 'ContentType', 'vector');

close(h2); % Close the second figure

%% Perform the Wilcoxon signed-rank test for retraction and protraction
[p_retraction, h_retraction, stats_retraction] = signrank(medianContributionsCont(1, :), medianContributionsYoke(1, :));
[p_protraction, h_protraction, stats_protraction] = signrank(medianContributionsCont(2, :), medianContributionsYoke(2, :));

% Display the results
disp('Retraction:');
disp(['Wilcoxon signed-rank test p-value: ', num2str(p_retraction)]);
if p_retraction < 0.05
    disp('The median contributions for retraction are significantly different between contingent and yoke conditions.');
    disp(stats_retraction);
else
    disp('The median contributions for retraction are not significantly different between contingent and yoke conditions.');
end

disp('Protraction:');
disp(['Wilcoxon signed-rank test p-value: ', num2str(p_protraction)]);
if p_protraction < 0.05
    disp('The median contributions for protraction are significantly different between contingent and yoke conditions.');
    disp(stats_protraction);

else
    disp('The median contributions for protraction are not significantly different between contingent and yoke conditions.');
    disp(stats_protraction);
end

% Compute and display median ± IQR
fprintf('\nRetraction (Contingent): Median = %.2f, IQR = %.2f\n', median(medianContributionsCont(1,:)), iqr(medianContributionsCont(1,:)));
fprintf('Retraction (Yoked):      Median = %.2f, IQR = %.2f\n', median(medianContributionsYoke(1,:)), iqr(medianContributionsYoke(1,:)));
fprintf('Protraction (Contingent): Median = %.2f, IQR = %.2f\n', median(medianContributionsCont(2,:)), iqr(medianContributionsCont(2,:)));
fprintf('Protraction (Yoked):      Median = %.2f, IQR = %.2f\n', median(medianContributionsYoke(2,:)), iqr(medianContributionsYoke(2,:)));
