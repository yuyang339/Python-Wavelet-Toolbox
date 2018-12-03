%% Signal Denoising
% Signal and Image denoising is one of the primary areas where discrete
% wavelet transformations have made an impact.  The idea of wavelet
% shrinkage, due to David Donoho and Iain Johnstone at Stanford University
% is the primary tool used to perform denoising with wavelet
% transformations.  
%
% The wavelet shrinkage process is described in Section 9.1 of the book.
% The basic algorithm consists of (1) computing the discrete wavelet
% transform of an input signal or image, (2) quantizing the highpass
% portions of the transform via the so-called shrinkage function with a
% prescribed tolerance, and (3) inverting the modified transform to obtain
% the denoised image/signal.
%
% In this demo, we will consider the task of denoising samples from an
% experiment performed by a group of engineering students and professors at
% the University of St. Thomas.  The reference to their paper is
%
% M. Hennessey, J. Jalkio, C. Greene, and C. Sullivan, "Optimal Routing of
% a Sailboat in Steady Winds", preprint, May 2007.
%
% The group recorded the speed of a sailboats (in knots) each second for
% almost 72 minutes.  Their measurements where corrupted by a variety of
% factors: current, wind changes, and sail configuration.  
%
% We will import the data set and use wavelet shrinkage to denoise the boat
% speeds.

%% Import the Boat Speed Data
% Our first step is to import the boat speeds.  This data set comes with
% the Discrete Wavelets package and we can find the absolute path to the
% file name by using the DataNames command.

% Get the file name (it's the first one in DataNames).
dt=DataNames();
v=textread(dt{1});

% Chop some values off the end of the data so that its length is divisible
% by 2^4.
v=ChopVector(v,4);
N=length(v);
disp(sprintf('The length of v is %i.',N));

% Plot the boat speeds.
plot(v);
title('Sailboat Speeds (in knots)');

%% Compute the Discrete Wavelet Transformation
% We next compute the discrete wavelet transformation of the input.  We
% will use the Coif(1) filter and compute 4 iterations.

% Compute the transform.
its=4;
h=Coif(1);
wt=WT1D(v,h,its);

%Plot the transformation.
clf;
WaveletVectorPlot(wt,its);

%% Estimate the Noise
% The next step in the denoising process is to estimate the noise.  We use
% the formula sigma ~ MAD(hp(1))/.6745 (see Section 9.1 of the text).

% First we split the wavelet transform into various parts.
wtlist=WaveletVectorToList(wt,its);

% We compute the MAD of the first highpass portion and divide by .6745.
sigma=MAD(wtlist(1).hp)/.6745;

disp(sprintf('The noise is estimated to be %f.',sigma));

%% Construct the Universal Threshold
% Now that we have an estimate of the noise, we can use it to find the
% universal threshold lambda.

% We need the total length of the highpass portions.  We can compute this
% by subtracting the length of the lowpass portion from the length of v.
n=N-numel(wtlist(1).lp);

% Now compute lambda.
lambda=sigma*sqrt(2*log(n));

disp(sprintf('The universal threshold is lambda = %f.',lambda));

%% Apply the Shrinkage Function to the Highpass Portions
% We now apply the shrinkage function with the universal threshold lambda
% to the highpass portions of the transform.
%
% We plot the modified wavelet transform - note the change between it and
% the original wavelet transform.

for k=1:its
    wtlist(k).hp = ShrinkageFunction(wtlist(k).hp,lambda);
end

% Reconstruct the transform as a vector.
newwt=WaveletListToVector(wtlist,its);

% Plot the modified transform.
clf;
WaveletVectorPlot(newwt,its);
title('Modified Wavelet Transformation');

%% Invert the Modified Transform
% To arrive at the denoised version of the input boat speeds, we compute
% the inverse wavelet transform of newwt.

y=IWT1D(newwt,h,its);

% Plot the denoised vector y.
clf;
plot(y);
title('Denoised Boat Speeds');

% Plot the original signal for comparison.
figure;
plot(v);
title('Original Boat Speeds');

%% Things to Try
% Make a copy of this demo and :
%
% * choose different filters - you can try a biorthogonal filter as well
% * change the value of iterations to any integer 1, 2,..., 8
% * try other tolerance values for lambda
% * try the SureShrink method (see Section 9.3 of the book)
% 

%%
close all;
displayEndOfDemoMessage(mfilename)