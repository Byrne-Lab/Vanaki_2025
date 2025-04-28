function [NNMFpost,NNMF] = run_nnmf(postSpTimes,numFac,numRuns)

%% Parameters


convSDs = 1000; % Standard deviation for Gaussian convolution

if nargin<3
    numRuns = 1;%6; % Number of times to run each algorithm
    numFac = 2;%1:7; % Number of factors for nnmf
end

% Parameters for Mackevicius algorithm.
L = 1; % Length of sequences in number of time bins.
lambda = 0; % Parameter for cross-orthogonality penalty.
downSampFac = 10; % Downsample factor to reduce computational time.
lambdaL1W = 0; % Sparsity constraint on neuron contributions
% Note: If sequence length is 1 and lambda is 0 the algorithm reduces to
% regular NNMF.

%%

postSpLogical = spikeTimes2Logical(postSpTimes);
%this is only to look at the first half
%postSpLogical = postSpLogical(1:60000, :);
%second half
%postSpLogical = postSpLogical(60001:end, :);



% Convolve spike trains with gaussian
if convSDs ~= 0
    post = ksGaussian(postSpLogical,convSDs);
else
    post = postSpLogical;
end

data = cat(1,post);
% Reorder neurons in pre, post and concatenated data based on
% overall firing rate
[~,cellOrderIdx] = sort(sum(data,1),'descend');
data = data(:,cellOrderIdx);
post = post(:,cellOrderIdx);



% Mackevicius algorithm (NNMF)
for ii = 1:numRuns
    for iii = 1:length(numFac)
        tic;
        %disp(L);
        [NNMF(ii,iii).W,NNMF(ii,iii).H,NNMF(ii,iii).cost, NNMF(ii,iii).loadings, NNMF(ii,iii).power]...
            = seqNMF(downsample(data,downSampFac)','K',numFac(iii),'L',L,'lambda',lambda,'showplot',0,'lambdaL1W',lambdaL1W);
        % If sequence length is 1 and lambda is 0 the algorithm reduces
        % to NNMF.
        disp("bruh");

        %good to use when you want to make sure H is correctly made
        %plotJustH(NNMF(ii,iii).H);

        NNMF(ii,iii).runNum = ii;
        NNMF(ii,iii).facNum = numFac(iii);
        NNMF(ii,iii).cellOrderIdx = cellOrderIdx;
        rTime = toc;
        if ii==1 && iii==1
            disp(['Mackevicius (NNMF) algorithm time per iteration is ' num2str(rTime) ' seconds.'])
            disp(['Estimated total run time for this algorithm is ' num2str(ceil(rTime*numRuns*length(numFac)/60)) ' minutes.'])
        end
    end
end

% Separate concatenated NNMF for each run.
NNMFpost = NNMF;
%for ii = 1:numel(NNMF)
%    NNMFpost(ii).H = NNMFpost(ii).H(:,size(NNMF(ii).H,2)/2+1:end);
%end