% Data
contingent = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
ibmp_percentage_cont = [1, 1, 0.5, 0.6, 0.625, 1, 0.167, 0.875, 0.6, 0.6, 0];
yoke = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
ibmp_percentage_yoke = [0, 0, 0.125, 0.667, 0, 0.75, 0.167, 0, 0.8, 0.2, 0.143];

% Calculate averages and standard errors
avg_ibmp_percentage_cont = mean(ibmp_percentage_cont);
avg_ibmp_percentage_yoke = mean(ibmp_percentage_yoke);
std_err_cont = std(ibmp_percentage_cont) / sqrt(length(ibmp_percentage_cont));
std_err_yoke = std(ibmp_percentage_yoke) / sqrt(length(ibmp_percentage_yoke));

% Perform a two-tailed t-test
[h, p, ci, stats] = ttest2(ibmp_percentage_cont, ibmp_percentage_yoke);

% Degrees of freedom
df = length(ibmp_percentage_cont) + length(ibmp_percentage_yoke) - 2;

% Print results rounded to 3 decimal places
fprintf('Mean (Contingent): %.3f\n', avg_ibmp_percentage_cont);
fprintf('Mean (Yoke): %.3f\n', avg_ibmp_percentage_yoke);
fprintf('T-statistic: %.3f\n', stats.tstat);
fprintf('Degrees of Freedom: %d\n', df);
fprintf('P-value: %.3f\n', p);

% Create bar graph with error bars
labels = {'Contingent', 'Yoke'};
averages = [avg_ibmp_percentage_cont, avg_ibmp_percentage_yoke];
errors = [std_err_cont, std_err_yoke];

figure;
hold on;
bar(1, averages(1), 'FaceColor', [0, 100/255, 0], 'FaceAlpha', 0.7);  % Dark green for contingent
bar(2, averages(2), 'FaceColor', [0.5, 0.5, 0.5], 'FaceAlpha', 0.7);  % Grey for yoke
errorbar(1, averages(1), errors(1), 'k', 'CapSize', 5, 'LineWidth', 2);
errorbar(2, averages(2), errors(2), 'k', 'CapSize', 5, 'LineWidth', 2);


% Set y-axis limit
ylim([0, 1]);

% Add labels
ylabel('iBMPs / (iBMPs + rBMPs)', 'FontSize', 20);
set(gca, 'FontSize', 20);  % Adjust the number to your desired font size
set(gca, 'XTick', [1, 2], 'XTickLabel', labels, 'FontSize', 20);  % Ensure labels are horizontal
set(gca, 'Box', 'off');  % Remove the top and right lines
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness

hold off;

% Create box and whisker plot with connecting lines
figure;
h = boxplot([ibmp_percentage_cont', ibmp_percentage_yoke'], 'Labels', {'Contingent', 'Yoke'}, 'Colors', 'k');
set(h, {'LineStyle'}, {'-'});
set(h, {'LineWidth'}, {1.5});
set(findobj(gca,'Tag','Box'), 'Color', 'k');
set(findobj(gca,'Tag','Median'), 'Color', 'k');
set(findobj(gca,'Tag','Whisker'), 'Color', 'k');
set(findobj(gca,'Tag','Outliers'), 'MarkerEdgeColor', 'k');

% Color the boxes
boxes = findobj(gca, 'Tag', 'Box');
patch(get(boxes(2), 'XData'), get(boxes(2), 'YData'), [0, 100/255, 0], 'FaceAlpha', 0.7);  % Dark green fill for contingent
patch(get(boxes(1), 'XData'), get(boxes(1), 'YData'), [0.5, 0.5, 0.5], 'FaceAlpha', 0.7);  % Grey fill for yoke

% Add connecting lines for each pair of cont percentage and yoke percentage
hold on;
for i = 1:length(contingent)
    plot([1.1, 2], [ibmp_percentage_cont(i), ibmp_percentage_yoke(i)], 'Color', [0.8, 0.8, 0.8], 'LineWidth', 1);
end
hold off;

% Set y-axis limit
ylim([0, 1]);

% Add labels
ylabel('iBMPs / (iBMPs + rBMPs)', 'FontSize', 20);
set(gca, 'FontSize', 20);  % Adjust the number to your desired font size
set(gca, 'XTickLabelRotation', 0); % Ensure labels are horizontal
set(gca, 'Box', 'off'); % Remove the top and right lines
set(gca, 'LineWidth', 2);  % Adjust the number to your desired thickness

title('');

