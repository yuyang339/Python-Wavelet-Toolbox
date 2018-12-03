%% Audio Denoising
% In this demo, we use the same algorithm that was used in signal denoising
% to denoise an audio clip.  We introduce some artificial noise to
% illustrate the effectiveness of the algorithm.
%
% It is helpful to review the Signal Denoising demo prior to viewing
% this demo.

%% Import an Audio File
% Our first step is to load one of the audio clips included with the
% DiscreteWavelets Toolbox.  To do this, we use the AudioList function to
% list all the files and the AudioNames function to create absolute paths
% to each audio file.

AudioList();
d=AudioNames();

% Let's choose the second clip (bark.wav).

%%
% Since the second clip is an audio file in wav format, we use wavread to
% import it as a vector.  We also trim some elements off the end of the
% vector to ensure that the length of the resulting vector is divisible by
% 2^4.

[data,srate]=wavread(d{2});
data=ChopVector(data,4);
N=length(data);

disp(sprintf('The length of the audio clip is %i.',N));
disp(sprintf('The sampling rate for the clip is %i.',srate));

%% Play the Audio Clip
% In this cell, we play the audio clip and plot it.

plot(data);
title('Bark.wav');

wavplay(data,srate);

%% Add White Noise to the Clip
% We next add some white noise to the clip.  We can use the Matlab function
% randn to assist in this task.

noise=randn(N,1);

% Pick a noise level.
sigma = .1;

% Create the noisy audio clip.
v=data+sigma*noise;

% Plot the noisy vector.
clf;
plot(v);

wavplay(v,srate);

%% Compute the Discrete Wavelet Transformation
% We now compute four iterations of the discrete wavelet transformation of
% v.  We will use the Coif(1) filter for this task.

its=4;
h=Coif(1);
wt=WT1D(v,h,its);

% Plot the transformation.
clf;
WaveletVectorPlot(wt,its);
title(sprintf('Wavelet Transformation - %i Iterations',its));

%% Estimate the Noise
% The next step in the denoising process is to estimate the noise.  Of
% course, we know the noise level, but it is good to see how well our
% estimator works.  We use the formula sigma ~ MAD(hp(1))/.6745 (see 
%Section 9.1 of the text).

% First we split the wavelet transform into various parts.
wtlist=WaveletVectorToList(wt,its);

% We compute the MAD of the first highpass portion and divide by .6745.
sigmahat=MAD(wtlist(1).hp)/.6745;

disp(sprintf('The noise is estimated to be %f.',sigmahat));

%% Use SureShrink to Denoise
% We will use SureShrink to denoise the audio clip.  

for j=1:its
    % The highpass portions must have variance 1.
    wtlist(j).hp=wtlist(j).hp/sigmahat;
    % Find the SureShrink tolerance
    lambda=DonohoSure(wtlist(j).hp);
    % Perform the quantization
    wtlist(j).hp=ShrinkageFunction(wtlist(j).hp,lambda);
    % Rescale the highpass portions.
    wtlist(j).hp=wtlist(j).hp*sigmahat;
end

%%
% Plot the modified wavelet transformation

% First reconstruct the modified wavelet transform vector.
newwt=WaveletListToVector(wtlist,its);

% Plot the modified wavelet transformation.
clf;
WaveletVectorPlot(newwt,its);
title('Modified Wavelet Transformation');

%% Compute the Inverse Wavelet Transform 
% To obtain the denoised audio clip, we perform four iterations of the
% inverse wavelet transformation.

denoised=IWT1D(newwt,Coif(1),its);

% Plot the denoised audio clip.
plot(denoised);
title('Denoised Audio Clip');

% Play the denoised audio clip.
wavplay(denoised,srate);

%%
% Play the noisy clip.

wavplay(v,srate);

%%
% Play the original clip.

wavplay(data,srate);

%% Things to Try
% Make a copy of this demo and :
%
% * try different wavelet filters
% * change the value of iterations to any integer 1, 2,..., 8
% * try other values for lambda
% 

%%
close all;
displayEndOfDemoMessage(mfilename)
