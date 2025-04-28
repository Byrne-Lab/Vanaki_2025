function convFRMat = ksGaussian(spDataMat,varargin)
% Original code by Sagar Patwardhan
%% Gaussian convolve
gWinGain = 5000/2; %5000/2 default
if nargin==1
    gStdDev = 1000;%200 default %gWinGain*2/5;%500;
elseif nargin==2
    gStdDev = varargin{1};
end

gWin = gWinGain*-1:1*gWinGain;
gMean = 0;
gaussian = normpdf(gWin,gMean,gStdDev);
gaussian = gaussian/sum(gaussian);

numNeurons = size(spDataMat,2);
convFRMat = zeros(size(spDataMat));


for n=1:numNeurons
    data = spDataMat(:,n);
    

    convdata = conv(data, gaussian);

    
    phaseAdjConvData = convdata(gWinGain+1:end-gWinGain);
    convFRMat(:,n) = phaseAdjConvData;

end