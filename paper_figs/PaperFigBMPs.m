ibmps_cont = [4, 2, 2, 3, 5, 2, 1, 7, 3, 3, 0];
ibmps_yoke  = [0, 0, 1, 2, 0, 3, 1, 0, 4, 1, 1];

rbmps_cont = [0, 0, 2, 2, 3, 0, 5, 1, 2, 2, 5];
rbmps_yoke  = [5, 5, 7, 1, 5, 1, 5, 1, 1, 4, 6];



% Total BMPs per pair
total_bmps_cont = [4, 2, 4, 5, 8, 2, 6, 8, 5, 5, 5];
total_bmps_yoke = [5, 5, 8, 3, 5, 4, 6, 1, 5, 5, 7];

% Wilcoxon signed-rank test
[p, h, stats] = signrank(total_bmps_cont, total_bmps_yoke);

% Display results
fprintf('Median (Contingent): %.3f\n', median(total_bmps_cont));
fprintf('Median (Yoke): %.3f\n', median(total_bmps_yoke));
fprintf('Wilcoxon signed-rank p-value: %.3f\n', p);
fprintf('Signed Rank Statistic: %f\n', stats.signedrank);

% Create box and whisker plot with connecting lines
figure;
h = boxplot([total_bmps_cont', total_bmps_yoke'], ...
            'Labels', {'Contingent', 'Yoke'}, 'Colors', 'k', 'Symbol','');
set(h, {'LineStyle'}, {'-'});
set(h, {'LineWidth'}, {1.5});
set(findobj(gca,'Tag','Box'), 'Color', 'k');
set(findobj(gca,'Tag','Median'), 'Color', 'k');
set(findobj(gca,'Tag','Whisker'), 'Color', 'k');
set(findobj(gca,'Tag','Outliers'), 'MarkerEdgeColor', 'k');

% Color the boxes
boxes = findobj(gca, 'Tag', 'Box');
patch(get(boxes(2), 'XData'), get(boxes(2), 'YData'), [0, 100/255, 0], 'FaceAlpha', 0.7);  % Dark green for contingent
patch(get(boxes(1), 'XData'), get(boxes(1), 'YData'), [0.5, 0.5, 0.5], 'FaceAlpha', 0.7);  % Grey for yoke

% Add connecting lines for each pair
hold on;
for i = 1:length(total_bmps_cont)
    plot([1, 2], [total_bmps_cont(i), total_bmps_yoke(i)], ...
         'Color', [0.8, 0.8, 0.8], 'LineWidth', 1);
end
hold off;

% Set y-axis limit
ylim([0, max([total_bmps_cont total_bmps_yoke]) + 2]);

% Labels and formatting
ylabel('Total BMPs (iBMP + rBMP)', 'FontSize', 20);
set(gca, 'FontSize', 20);
set(gca, 'XTickLabelRotation', 0);
set(gca, 'Box', 'off');
set(gca, 'LineWidth', 2);


% Calculate medians and IQRs
med_cont = median(total_bmps_cont);
iqr_cont = iqr(total_bmps_cont);

med_yoke = median(total_bmps_yoke);
iqr_yoke = iqr(total_bmps_yoke);

% Display results as median ± IQR
fprintf('Contingent: Median ± IQR = %.2f ± %.2f\n', med_cont, iqr_cont);
fprintf('Yoke: Median ± IQR = %.2f ± %.2f\n', med_yoke, iqr_yoke);

exportgraphics(gcf, 'C:\Sara\rice\freshman year\uthealth\paperfigs\testingallbmps.pdf', 'ContentType', 'vector');


