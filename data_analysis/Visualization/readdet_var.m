function [pixels,kern_center,kernel_size,kernpos]=readdet_var(det)
% Defines a function named "readdet_var" that takes one input (det)
% and returns four outputs (pixels, kern_center, kernel_size, kernpos).
% Kernels: These are groups or clusters of pixels within the image (a 
% single neuron). Each group of pixels (kernel) is used for some specific
% processing or analysis purpose.

% Function for reading kernel coordinates from det VARIABLE. Modified from
% readdet function, which reads kernel coordinates from .det file and
% generates the variable ("det") used as input here.
% "det" --  Nx1 double variable containing linear indexes of pixels
%           belonging to each kernel. Kernels are separated by zeros. This
%           variable is created by the "readdet" function.
 
% Parameters

pixSz = 128; % Size of the acquired image on which kernels were drawn. Currently assumes X and Y dimensions are the same.

pixels = mod(det,pixSz);
% Computes the X coordinates of the pixels in 'det' by taking the modulus
% with respect to 'pixSz'.

pixels(:,2) = ceil(det/pixSz);
% Computes the Y coordinates of the pixels in 'det' by dividing by 'pixSz'
% and rounding up to the nearest integer.

pixels(pixels(:,1)==0,1) = pixSz;
% Corrects X coordinates that are calculated as 0 to be 'pixSz'
% (assumes the indexing starts from 1, not 0).


kernpos = find(~det);
% Finds indices in 'det' where the value is zero, which indicates the
% separation between different kernels.

kernel_size = diff(kernpos)-1;
% Calculates the number of pixels in each kernel by computing the 
% difference between consecutive kernel positions and subtracting one.

kernpos(end) = [];
% Removes the last position from 'kernpos' as it is not needed for 
% further calculations.

kern_center = zeros(length(kernpos),2);
% Initializes an array to store the X and Y coordinates of the centers 
% of each kernel.

for a=1:length(kernpos)
% Starts a loop over all kernel positions.

    if a<length(kernpos) 
        B = pixels(kernpos(a)+1:kernpos(a+1)-1,:);
    else
        B = pixels(kernpos(a)+1:end-1,:);
    end
    % In each iteration, selects the pixel coordinates for the current
    % kernel from 'pixels'. Handles the last kernel by taking all
    % remaining pixels.

    kern_center(a,:) = mean(B);
    % Calculates the mean of the selected pixel coordinates,
    % thereby determining the center of the kernel.

end

end