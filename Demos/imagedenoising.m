%% Image Denoising
% In this demo we used the denoising functions WaveletShrinkage (VisuShrink
% with the universal threshold) and SureShrink to denoise a digital image.

%% Import a Digital Image
% We begin by importing a digital image. We will use one of the images that
% comes, courtesy of Radka Tezaur, with the DiscreteWavelets Toolbox.  The 
% command ShowThumbnails can be used to see what choices are available.
ShowThumbnails('ImageType','GrayScale');

%Let's use Gray 1.

%% 
% The code below reads this image from disk and plots it.
% ImageNames gives the absolute path to all included image files.
gry=ImageNames('ImageType','GrayScale');

% Use ImageRead to read the image and store it in matrix A.
A=ImageRead(gry{1});

% Use ImagePlot to plot the image.
clf;
ImagePlot(A);
title('A Digital Image');

%% Add White Noise to the Image
% We next add some white noise to the image.  We can use the Matlab function
% randn to assist in this task.

[r c]=size(A);
noise=randn(r,c);

% Pick a noise level.
sigma = 25;

% Create the noisy audio clip.
noisyA=A+sigma*noise;

% Plot the noisy image.
figure;
ImagePlot(noisyA);
title('A Noisy Image');

%% Denoise Using the VisuShrink Method
% We will first use the VisuShrink method to denoise the image.  We compute
% the universal threshold and then call WaveletShrinkage to do the job.  We
% will compute four iterations of the transform and use the 12-term Coif(2)
% filter for the demonstration.

% Compute the universal threshold.
its=4;
lambdauniv=UniversalThreshold(noisyA,Coif(2),its);

% Perform VisuShrink
Visu=WaveletShrinkage(noisyA,Coif(2),its,lambdauniv);

% Plot the denoised image
figure;
ImagePlot(Visu);
title('Denoised Image Using VisuShrink');

%% Denoise Using the SureShrink Method
% We next use the SureShrink method to denoise the image.

Sure=SureShrink(noisyA,Coif(2),its);

% Plot the denoised image
figure;
ImagePlot(Sure);
title('Denoised Image Using SureShrink');

%% Compare the PSNRs
% As a way to test the effectiveness of each method, we compute the PSNR of
% each denoised matrix against the original.

% The PSNR of A vs. Visu
PSNR1=PSNR(A,Visu);
disp(sprintf('The PSNR of A vs. the VisuShrink method is %f.',PSNR1));

% The PSNR of A vs. Sure
PSNR2=PSNR(A,Sure);
disp(sprintf('The PSNR of A vs. the SureShrink method is %f.',PSNR2));

%% Things to Try
% Make a copy of this demo and :
%
% * try different wavelet filters
% * change the value of iterations to any integer 1, 2,..., 8
% * try different images
% * try other values for lambda 
% * for WaveletShrinkage, you can enter a list of lambdas - one for each
%   highpass portion of the transform.  
% 

%%
close all;
displayEndOfDemoMessage(mfilename)