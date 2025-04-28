function spLogical = spikeTimes2Logical(spTimes)
%spTimes = round(spTimes/10);
% Parameters
acqRate = 1000; % Hz
duration = 120; % seconds
% disp("these are sp times");
% disp(spTimes);
spLogical = false(acqRate*duration,size(spTimes,2));
for ii = 1:size(spTimes,2)
    tempSpTimes = spTimes(:,ii);
    tempSpTimes(tempSpTimes==0) = [];
    tempSpTimes(isnan(tempSpTimes)) = [];
    
    spLogical(tempSpTimes,ii) = true;
end