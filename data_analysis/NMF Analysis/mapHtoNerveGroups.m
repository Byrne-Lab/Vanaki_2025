function flag = mapHtoNerveGroups(H, nerveActivity)
    % Assume the time vector for nerveActivity goes from 0 to 120000
    timeVectorNerve = linspace(0, 120000, size(nerveActivity, 1));
    timeVectorH = linspace(0, 120000, size(H, 2));
    
    % Interpolate H to match the nerveActivity time points
    H_interp = zeros(2, length(timeVectorNerve));
    for i = 1:2
        H_interp(i, :) = interp1(timeVectorH, H(i, :), timeVectorNerve, 'linear', 'extrap');
    end

    % Normalize H to [0, 1] - if necessary, depending on the range of H values
    H_normalized = (H_interp - min(H_interp, [], 2)) ./ (max(H_interp, [], 2) - min(H_interp, [], 2));

    % Identify columns that are not all false
    validCols = any(nerveActivity, 1);  % Columns with any true values

    % Define groups
    group1Columns = [2, 6]; % Bn1
    group2Columns = [3, 7]; % Bn2 ONLY, if you want Bn3 - 4,8 need to be added

    % Filter valid columns for each group
    validGroup1Columns = group1Columns(validCols(group1Columns));
    validGroup2Columns = group2Columns(validCols(group2Columns));

    % Average activities for each group, excluding invalid columns
    if ~isempty(validGroup1Columns)
        group1Activity = mean(nerveActivity(:, validGroup1Columns), 2);
    else
        group1Activity = zeros(size(nerveActivity, 1), 1);  % Default to zeros if no valid columns
    end

    if ~isempty(validGroup2Columns)
        group2Activity = mean(nerveActivity(:, validGroup2Columns), 2);
    else
        group2Activity = zeros(size(nerveActivity, 1), 1);  % Default to zeros if no valid columns
    end

    % Calculate correlation coefficients
    corrCoeff = zeros(2, 2);
    corrCoeff(1, :) = [corr(H_normalized(1, :)', group1Activity), corr(H_normalized(1, :)', group2Activity)];
    corrCoeff(2, :) = [corr(H_normalized(2, :)', group1Activity), corr(H_normalized(2, :)', group2Activity)];

    % Determine mapping based on the forced choice mechanism
    if abs(corrCoeff(1,1) - corrCoeff(1,2)) > abs(corrCoeff(2,1) - corrCoeff(2,2))
        [value1, index1] = max(corrCoeff(1, :));
        index2 = 3 - index1;
    else
        [value2, index2] = max(corrCoeff(2, :));
        index1 = 3 - index2;
    end

    % Display results and determine flag
    flag = 0; % Default flag value if Row 1 of H does not map to Group 1
    if index1 == 1
        flag = 1;
        fprintf('Row 1 of H maps to Group 1\n');
    else
        fprintf('Row 1 of H maps to Group %d\n', index1);
    end
    fprintf('Correlation of H Row 1 with Group 1 Activity: %.4f\n', corrCoeff(1, 1));
    fprintf('Correlation of H Row 1 with Group 2 Activity: %.4f\n', corrCoeff(1, 2));
    
    fprintf('Row 2 of H maps to Group %d\n', index2);
    fprintf('Correlation of H Row 2 with Group 1 Activity: %.4f\n', corrCoeff(2, 1));
    fprintf('Correlation of H Row 2 with Group 2 Activity: %.4f\n', corrCoeff(2, 2));

    % % Diagnostic Plots to compare how each row of H matches the groups
    % figure;
    % subplot(3,1,1);
    % plot(timeVectorNerve, H_normalized(1, :), 'r', 'DisplayName', 'H Row 1');
    % hold on;
    % plot(timeVectorNerve, group1Activity, 'b', 'DisplayName', 'Group 1 Activity');
    % plot(timeVectorNerve, group2Activity, 'k', 'DisplayName', 'Group 2 Activity');
    % legend show;
    % title('Comparison of H Row 1 to Group Activities');
    % 
    % subplot(3,1,2);
    % plot(timeVectorNerve, H_normalized(2, :), 'r', 'DisplayName', 'H Row 2');
    % hold on;
    % plot(timeVectorNerve, group1Activity, 'b', 'DisplayName', 'Group 1 Activity');
    % plot(timeVectorNerve, group2Activity, 'k', 'DisplayName', 'Group 2 Activity');
    % legend show;
    % title('Comparison of H Row 2 to Group Activities');
    % 
    % subplot(3,1,3);
    % plot(timeVectorNerve, group1Activity, 'b', 'DisplayName', 'Group 1 Activity');
    % hold on;
    % plot(timeVectorNerve, group2Activity, 'k', 'DisplayName', 'Group 2 Activity');
    % legend show;
    % title('Overlay of Group 1 and Group 2 Activities');
end
