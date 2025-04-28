function [h1,h2,kWImg, W,kern_center, kernel_size]=labelNeuronsNNMFwSave(NNMF_W,order,gImage,det,color, fullPath,identifier)
% This function labels the neurons and colors them according to the vector
% of contributions to an NNMF factor.
% "folder" -- Full path to folder in which .tif and .det files are placed.
% "NNMF_W" -- Vector array of the contributions of each neuron to a factor.
% "order"  -- Vector array specifying the order of the kernels in the NNMF_W
%             array relative to the order in the .det file. By default NNMF
%             reorders the cells, so an order array must be provided.
% "color"  -- Color to use to plot contributions. Can be red, green or blue,
%             or an RGB triplet within the range 0 to 1. Default color is red.

if nargin < 7
    identifier = '';  % Default identifier is empty
else
    identifier = ['_' num2str(identifier)];  % Convert number to string and prepend with _
end

if nargin<5
    color = 'red';
end
if ~isnumeric(color)
    switch color
        case {'r','red'}
            color = [1 0 0];
        case {'g','green'}
            color = [0 1 0];
        case {'b','blue'}
            color = [0 0 1];
        otherwise
            color = [1 0 0];
    end
end
colorMap = [linspace(1,color(1),256)', linspace(1,color(2),256)', linspace(1,color(3),256)'];
%color = logical(color);

drawKCircles = 1; % Whether or not to draw kernel circles

%%

%picture
pic=gImage;
pic=repmat(pic,[1 1 3])/max(pic(:));

%read det variable
[pixels,kern_center,kernel_size,kernpos]=readdet_var(det);


% Reorder .det output to match NNMF_W array
kern_center = kern_center(order,:);
kernel_size = kernel_size(order,:);
kernpos = kernpos(order,:);

%% Normalize NNMF contributions

W = NNMF_W;
W = W./max(W,[],'all');
%% make figure

%close(findobj(0,'Name', 'Ganglia Picture'))
h1 = figure('Name','Ganglia Picture','NumberTitle','off','Visible','off');

%colors(:,1,:)=colorit(opacity);
%colors=repmat(colors,[ceil(length(kernpos)/length(colors)) 1 1]);
kernelColors = interp1(linspace(0,1,size(colorMap,1)),colorMap,W); % This interpolation samples the colormap for accurate colors for each of the values in W.
kernelColors = permute(kernelColors,[1 3 2]);
kernAlpha = 0.5;
%if strcmpi(color_style,'arbitrary')
%end

for b=1:length(kernpos) 
    for c=kernpos(b)+1:kernpos(b)+kernel_size(b)
            pic(pixels(c,2),pixels(c,1),:)=(1-W(b)*0.7)*pic(pixels(c,2),pixels(c,1),:)+W(b)*0.7*permute(color,[1 3 2]);
    end
end

%alignedKCenter = alignKernels();

crop = 3;
pic(1:crop,:,:)=[];pic(:,1:crop,:)=[];%pic(end+1:end+crop,:,:)=0;pic(:,end+1:end+crop,:)=0;
kern_center = kern_center - crop;
%alignedKCenter = alignedKCenter - crop;
pixels = pixels - crop;
ax(1)=axes;
image(pic); hold on

% for b=1:length(kernpos)
%     
%     kernPix = pixels(kernpos(b)+1:kernpos(b)+kernel_size(b),:);
%     kernBoundaryIdx = boundary(kernPix,1);
%     kernBoundary = kernPix(kernBoundaryIdx,:);
%     
%     patch(kernBoundary(:,1),kernBoundary(:,2),color,'FaceAlpha',W(b)*0.7); 
% end

%count = 0; %% count added temporarily
% After the first figure (h1) is fully prepared:
if ~isempty(fullPath)
    filename = fullfile(fullPath, ['Ganglia_Picture_' identifier '.png']);
    saveas(h1, filename);
end


h2 = figure('Visible','off');
ax(2) = axes;
th = 0:pi/180:2*pi;
for b=1:size(kern_center,1)
    %count = count + 1;%% count added temporarily
   tx=text(kern_center(b,1),kern_center(b,2),num2str(b)); %% count added temporarily should be 'b'
     tx.HorizontalAlignment='center';
     tx.VerticalAlignment='middle';
     tx.Color='none';
     tx.FontSize=12;
%      scatter(K(b,2),K(b,1),10,'k','filled');hold on

    if drawKCircles 
        scale_factor = 0.5;  % Adjust this value as needed, smaller values make the circles smaller
        pH(b) = patch(scale_factor * sqrt(kernel_size(b)/pi) * cos(th) + kern_center(b,1), ...
            scale_factor * sqrt(kernel_size(b)/pi) * sin(th) + kern_center(b,2), W(b));

        %pH(b) = patch(sqrt(kernel_size(b)/pi)*cos(th)+alignedKCenter(b,1),sqrt(kernel_size(b)/pi)*sin(th)+alignedKCenter(b,2),W(b));        
    end
     %disp(alignedKCenter);    
     text(kern_center(b,1), kern_center(b,2), num2str(order(b)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'FontSize', 10, 'Color', 'k');  % Adjust font size and color as needed
end



    set(ax,'Visible','off');
    axis(ax,'image')
    colormap(colorMap);
    caxis([0 1]);
    colorbar;
    ax(2).YDir = 'reverse';    
    ax2ylim = ax(2).YLim;
    ax2xlim = ax(2).XLim;
    
    % Temporarily modify plot before grabbing frame.
    ax(2).YLim = [-128 128];
    ax(2).XLim = [-128 128];    
    set(pH,'EdgeColor','none');
    set(gcf,'color','w');
    kWImg = getframe(ax(2)); % Grab frame.
    kWImg = double(rgb2gray(kWImg.cdata)); 
    kWImg = (kWImg-min(kWImg(:)))/max(kWImg(:));
        
    set(pH,'EdgeColor','k'); 
    ax(2).YLim = ax2ylim;
    ax(2).XLim = ax2xlim;
    if ~isempty(fullPath)
        filename = fullfile(fullPath, ['Neurons_labeled_' identifier '.png']);
        saveas(h2, filename);
    end
    


%set(gcf,'Position',[round(MP(monitor,1)*.75) MP(monitor,2)+MP(monitor,2)*0.01  figure_size.*MP(monitor,4)-MP(monitor,4)*0.08   figure_size.*MP(monitor,4)-MP(monitor,4)*0.08]);

    function alignedKCenter = alignKernels()
        sizeThr = 75; % Size threshold in percentile
        kernIdx = kernel_size>prctile(kernel_size,sizeThr); % Large kernel index.
        pixIdx = [];
        for ii = find(kernIdx)'
            pixIdx = [pixIdx kernpos(ii)+1:kernpos(ii)+kernel_size(ii)];
        end
        
        % Find regression line for larger cells (i.e., ventral cluster).
        regressionModel = fitlm(pixels(pixIdx,1),pixels(pixIdx,2));
        bRM = regressionModel.Coefficients.Estimate(1); % Intercept.
        aRM = regressionModel.Coefficients.Estimate(2); % Slope.
        slope = atan(aRM); % Slope in radians.
        
        % Generate affine transform for alignment.
        tformMat = [cos(-slope) sin(-slope) 0;
            -sin(-slope) cos(-slope) 0;
            -bRM -bRM 1]; % Transform matrix.
        tform = affine2d(tformMat);
        
        % Apply alignment transform.
        [alignedKCenter(:,1),alignedKCenter(:,2)] = transformPointsForward(tform,kern_center(:,1),kern_center(:,2));
        
        %alignedKCenter = [kern_center(:,1)*aRM kern_center(:,2)-bRM];        
        
    end

end