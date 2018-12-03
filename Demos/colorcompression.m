%% Color Image Compression
% We can use discrete wavelet transformations to perform naive image
% compression.  The process is very similar to that used to compress
% grayscale images with the only difference being that the color image is
% imported as three channels (R,G,B) and then must be converted to Y,Cb,Cr
% space.  The process used to compress grayscale images is then applied to
% each of Y, Cb, and Cr.  The compressed versions of Y, Cb, and Cr are
% converted back to RGB space to obtain the compressed color image.
%
% It is helpful to review the Naive Edge Detection demo prior to viewing
% this demo.

%% Import a Digital Image
% We begin by importing a digital image. We will use one of the images that comes, courtesy of Radka Tezaur, with 
% the DiscreteWavelets Toolbox.  The command ShowThumbnails can be used to see what choices are available.
ShowThumbnails('ImageType','Color');

%Let's use Color 3.

%% 
% The code below reads this image from disk and plots it.
% ImageNames gives the absolute path to all included image files.
clr=ImageNames('ImageType','Color');

% Use ImageRead to read the image and store it in matrix A.  Note that A is
% actually a 3-dimensional array.
A=ImageRead(clr{3});

% Use ImagePlot to plot the image.
clf;
ImagePlot(A);
title('Bath Toys');

%% Convert to YCbCr Space
% The first step in the compression process is to convert the image from
% RGB space to the more compression-conducive YCbCr space.  We use the
% function RGBToYCbCr to complete this task.

% Convert from RGB to YCbCr
B=RGBToYCbCr(A,'DisplayMode','True');
[Y,Cb,Cr]=Split3D(B);

% Plot each channel
clf;
ImagePlot(Y);
title('Channel Y');

figure
ImagePlot(Cb);
title('Channel Cb');

figure;
ImagePlot(Cr);
title('Channel Cr');

%% Compute the Discrete Wavelet Transformation
% We will use the discrete Haar wavelet transformation for this demo.   We next compute three iterations
% of the modified HWT.  The transforation is modified by multiplying the
% filter [sqrt(2)/2, sqrt(2)/2] by sqrt(2).  In this way the filter will
% map integers to integers and improve the performance of
% the Huffman coder.  We need to remember to divide the inverse transform
% by sqrt(2) when we view the compressed image.

% Compute the HWTs of Y,Cb,Cr and store in Ywt,Cbwt,Crwt, respectively.
its=3;
h=sqrt(2)*Haar();
Ywt=WT2D(Y,h,its);
Cbwt=WT2D(Cb,h,its);
Crwt=WT2D(Cr,h,its);
 
% Plot the HWTs - first close other figures;
close all;

WaveletDensityPlot(Ywt,its,'DivideLinesColor',[1 0 0],...
    'DivideLinesThickness',[2 2 2])
title(sprintf('Haar Wavelet Transformation of Y - %i Iterations',its));

figure;
WaveletDensityPlot(Cbwt,its,'DivideLinesColor',[1 0 0],...
    'DivideLinesThickness',[2 2 2])
title(sprintf('Haar Wavelet Transformation of Cb - %i Iterations',its));
figure;
WaveletDensityPlot(Crwt,its,'DivideLinesColor',[1 0 0],...
    'DivideLinesThickness',[2 2 2])
title(sprintf('Haar Wavelet Transformation of Cr - %i Iterations',its));

%% Construct the Cumulative Energy Vectors
% We now find the cumulative energy vector for each of Ywt, Cbwt, and Crwt.

% Construct the cumulative energy vectors.
ceYwt=CE(Ywt);
ceCbwt=CE(Cbwt);
ceCrwt=CE(Crwt);

% Plot the first 7000 terms - first close all figures.
close all;

n=7000;
N=numel(Ywt);

figure;
subplot(3,1,1);
plot(ceYwt(1:7000));
title('Cumulative Energy - Y Channel (First 7000 Terms)');

subplot(3,1,2);
plot(ceCbwt(1:7000));
title('Cumulative Energy - Cb Channel (First 7000 Terms)');

subplot(3,1,3);
plot(ceCrwt(1:7000));
title('Cumulative Energy - Cr Channel (First 7000 Terms)');

%% Set the Energy Levels
% We now determine the number of terms in each of Ywt, Cbwt, and Crwt
% needed to comprise 100*r% of the energy in Ywt, Cbwt, and Crwt,
% respectively. 

% Set the energy level.
r=.9999;


% Find the number of terms needed to comprise 100r% of the energy.
kY=nCE(ceYwt,r);
str=sprintf('The largest %i elements (in absolute value) of the Ywt constitute %f%% \nof the total energy of the transformation.\n',kY,100*r);
disp(str);

kCb=nCE(ceCbwt,r);
str=sprintf('The largest %i elements (in absolute value) of the Cbwt constitute %f%% \nof the total energy of the transformation.\n',kCb,100*r);
disp(str);

kCr=nCE(ceCrwt,r);
str=sprintf('The largest %i elements (in absolute value) of the Crwt constitute %f%% \nof the total energy of the transformation.\n',kCr,100*r);
disp(str);

%% Quantize the Transformation
% We now use the Comp function to quantize each of the transformations.
% The routine retains the largest (in absolute value) elements needed to
% comprise 100r% of the transformation and converts all other values to 0.
% Notat that the highpass portions of the modified transformations are quite
% different from their original counterparts.

% Perform the quantizations.
newYwt=Comp(Ywt,kY);
str=sprintf('We set %i elements in the transform to 0.  This constitutes %f%% \nof the total number of elements in B.\n',N-kY,100*(N-kY)/N);
disp(str);

newCbwt=Comp(Cbwt,kCb);
str=sprintf('We set %i elements in the transform to 0.  This constitutes %f%% \nof the total number of elements in B.\n',N-kCb,100*(N-kCb)/N);
disp(str);

newCrwt=Comp(Crwt,kCr);
str=sprintf('We set %i elements in the transform to 0.  This constitutes %f%% \nof the total number of elements in B.\n',N-kCr,100*(N-kCr)/N);
disp(str);

%%
% Plot the modified transformations - first close all figures.
close all;

WaveletDensityPlot(newYwt,its,'DivideLinesColor',[1 0 0],...
    'DivideLinesThickness',[2 2 2]);
title('New Y Wavelet Transformation');

figure;
WaveletDensityPlot(newCbwt,its,'DivideLinesColor',[1 0 0],...
    'DivideLinesThickness',[2 2 2]);
title('New Cb Wavelet Transformation');

figure;
WaveletDensityPlot(newCrwt,its,'DivideLinesColor',[1 0 0],...
    'DivideLinesThickness',[2 2 2]);
title('New Cr Wavelet Transformation');

%% Compute the Huffman Codes for Each of the Modified Transformations
% We now compute the Huffman codes for each of the modified
% transformations.  Note that we have shifted the elements of each matrix
% so that the minimum is 0.  We have also rounded the shifted matrices
% since MakeHuffmanCodes requires integer input.  The computations were
% previously done in floating point arithmetic to improve computation
% speed.  The rouding is valid at this step since the modified HWTs map
% integers to integers.

% Make the Huffman codes for each of newYwt, newCbwt, and newCrwt.
[uniqY,freqY,codesY,origlenY,newlenY]=MakeHuffmanCodes(round(newYwt-min(min(newYwt))));
[uniqCb,freqCb,codesCb,origlenCb,newlenCb]=MakeHuffmanCodes(round(newCbwt-min(min(newCbwt))));
[uniqCr,freqCr,codesCr,origlenCr,newlenCr]=MakeHuffmanCodes(round(newCrwt-min(min(newCrwt))));

disp('Finished!');

%% 
% Here is some information on the new bitstream lengths.

str=sprintf('For Ywt, the original bitstream length is %i and the new bitstream length is %i.',origlenY,newlenY);
disp(str);
bppY=newlenY/N;
str=sprintf('The bits per pixel for the new bitstream is %f bpp.\n',bppY);
disp(str);

str=sprintf('For Cbwt, the original bitstream length is %i and the new bitstream length is %i.',origlenCb,newlenCb);
disp(str);
bppCb=newlenCb/N;
str=sprintf('The bits per pixel for the new bitstream is %f bpp.\n',bppCb);
disp(str);


str=sprintf('For Crwt, the original bitstream length is %i and the new bitstream length is %i.',origlenCr,newlenCr);
disp(str);
bppCr=newlenCr/N;
str=sprintf('The bits per pixel for the new bitstream is %f bpp.\n',bppCr);
disp(str);

%Compute the composite bpp for all channels.
bpp=(newlenY+newlenCb+newlenCr)/(3*N);
str=sprintf('The composite bpp for all channels is %f.\n',bpp);
disp(str);

% To get an idea of the best case compression scenario we compute the
% composite entropy of the wavelet transformation.
e=Entropy([newYwt newCbwt newCrwt]);

str=sprintf('The entropies of the transformation is %f.',e);
disp(str);


%% Compute the Inverse Transformations
% The next step is to apply the inverse wavelet transformations to each of
% the newYwt, newCbwt, and newCrwt channels.  This gives us compressed Y,
% Cb, and Cr channels.  Don't forget to divide by sqrt(2).

h=Haar()/sqrt(2);
newY=IWT2D(newYwt,h,its);
newCb=IWT2D(newCbwt,h,its);
newCr=IWT2D(newCrwt,h,its);

% We plot the new Y, Cb, and Cr channels - first close all figures.
close all;
ImagePlot(newY);
title('New Y Channel');

figure;
ImagePlot(newCb);
title('New Cb Channel');

figure;
ImagePlot(newCr);
title('New Cr Channel');

%% Convert Back to RGB Space
% Our last step is to convert back to RGB space.  

% Gather newY, newCb, and newCr as a 3-D array.
B=Make3D(newY,newCb,newCr);

% Perform the color space conversion.
compressedA=YCbCrToRGB(B,'DisplayMode','True');


% Plot the compressed image - first close all figures.
close all;
ImagePlot(compressedA);
title('Compressed Image');

% Plot the original image - make a second figure
figure;
ImagePlot(A);
title('Original Image');

%% Analysis
% The compressed image is not as sharp as the original.  But the
% compression rate is very good - about 1.2 bpp!  Note that the composity entropy is
% approximately 0.3983, so we would expect to achieve a better bpp if we used
% a coder a bit more sophisticated than Huffman's.

%% Things to Try
% Make a copy of this demo and :
%
% * try different images
% * try different transformations
% * in particular, try LeGall with IntegerMap set to True
% * use different percentages for quantizing the cumulative energy vector
% * change the value of iterations to any integer 1, 2,..., 8
% 

%%
close all;
displayEndOfDemoMessage(mfilename)