function [spikes, aspike, aspike2,logic] = detection_algorithm(params,W,data,data2,sf)
% Modified/used by Sara Vanaki on 6/3/2024
% params = parameters for the spike detection (single channel)
% W      = window for capturing the spike waveform
% data   = the VSD trace (single channel)
% data2  = the VSD trace for a comparative channel (to see if another
%          neuron or nerve has coincident spike activity.
% sf     = sample frequency
% tplt   = threshold plot graphic object

dur1 = round(params.dur1/1000/sf);% convert from time to # indices
dur2 = round(params.dur2/1000/sf);% convert from time to # indices
gapdur = round(params.gapdur/1000/sf);% convert from time to # indices
ra = round(params.ra/1000/sf);% convert from time to # indices

gpdvdur = round(params.gpdvdur/1000/sf);% convert from time to # indices
if params.ckdv
    data = [zeros(1,gpdvdur-1) , data(gpdvdur:end) - data(1:end - gpdvdur+1)];
end

sdata = repelem('n',length(data));
stdata = std(data,"omitnan");
logic = int8(zeros(length(data),1));
if params.ck1
    if params.thr1>0
        sidx = data>params.thr1*stdata;% find all values > threshold
    else
        sidx = data<params.thr1*stdata;% find all values > threshold
    end
    sdata(sidx) = '1';
    logic(sidx) = 1;
    pattern = ['1{' num2str(dur1) ',}' ];
%     pattern = repelem('u',dur1);

end

if params.ck1 && params.ck1rej
    if params.rej1>0
        sidx = data>params.rej1*stdata;% find all values > threshold
    else
        sidx = data<params.rej1*stdata;% find all values > threshold
    end
    sdata(sidx) = 'r';
    logic(sidx) = 2;
    rpattern1 = ['r' pattern];
    rpattern2 = [pattern 'r'];

end

if params.ck2
    if params.thr2>0
        sidx = data>params.thr2*stdata;% find all values > threshold
    else
        sidx = data<params.thr2*stdata;% find all values > threshold
    end
    sdata(sidx) = '2';
    logic(sidx) = -1;
    pattern = ['2{' num2str(dur2) ',}' ];

end

if params.ck2 && params.ck2rej
    if params.rej2>0
        sidx = data>params.rej2*stdata;% find all values > threshold
    else
        sidx = data<params.rej2*stdata;% find all values > threshold
    end
    sdata(sidx) = 'r';
    logic(sidx) = -2;
    rpattern1 = ['r' pattern];
    rpattern2 = [pattern 'r'];

end

if params.ck1 && params.ck2
    if params.ck2rej || params.ck1rej
        warning('haven''t fixed this condition for rejection')
    end
    if gapdur>=0
        pattern = ['1{' num2str(dur1) '}' '[12n]{' num2str(gapdur-dur1) '}' '2{' num2str(dur2) '}'];
%         eval(['pattern = "' repelem('u',dur1) '"' repmat(' + ("u"|"d"|"n")',1,gapdur-dur1) ' + "' repelem('d',dur2) '";'])
    else
        pattern = ['2{' num2str(dur2) '}' '[12n]{' num2str(abs(gapdur)-dur2) '}' '1{' num2str(dur1) '}'];
%         eval(['pattern = "' repelem('d',dur2) '"' repmat(' + ("u"|"d"|"n")',1,abs(gapdur)-dur2) ' + "' repelem('u',dur1) '";'])
    end
end


spikes = regexp(sdata,pattern);

if params.ck2rej || params.ck1rej
    rej = regexp(sdata,rpattern1);
    rejlog = arrayfun(@(x) any(rej==x-1),spikes);
    spikes(rejlog) = [];
    rej = regexp(sdata,rpattern2);
    rejlog = arrayfun(@(x) any(rej==x),spikes);
    spikes(rejlog) = [];
end
% spikes = strfind(sdata,pattern);
aspike = [];
aspike2 = [];
if ~isempty(spikes)
    spikes = spikes([true, diff(spikes)>ra]);% remove values that are separated by < re-arm (prevents dection of same spike).  The value is idices;
    spikes(spikes+W(1)<0 | spikes+W(end)>length(data)) = [];
    aspike = zeros(length(spikes),length(W));
    aspike2 = zeros(length(spikes),length(W));% for averaging of channel2
    for i = 1:length(spikes)
        aspike(i,:) = data(W+spikes(i));
        if ~isempty(data2)
            aspike2(i,:) = data2(W+spikes(i));
        end
    end

end