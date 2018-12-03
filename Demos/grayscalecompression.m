%% Grayscale Image Compression
% We can use discrete wavelet transformations to perform naive image
% compression.  We can compute the wavelet transformation of an image,
% construct the cumulative energy vector for the transformation, quantize the
% transform based on a decision we make regarding this vector, and then
% find the Huffman codes for the modified transformations.  We can measure
% the effectiveness of the compressed image by computing the bitstream
% length of the Huffman-coded modified transformation.

%% Import a Digital Image
% We begin by importing a digital image. We will use one of the images that comes, courtesy of Radka Tezaur, with 
% the DiscreteWavelets Toolbox.  The command ShowThumbnails can be used to see what choices are available.
ShowThumbnails('ImageType','GrayScale');

%Let's use Gray 8.

%% 
% The code below reads this image from disk and plots it.
% ImageNames gives the absolute path to all included image files.
gry=ImageNames('ImageType','GrayScale');

% Use ImageRead to read the image and store it in matrix A.
A=ImageRead(gry{8});

% Use ImagePlot to plot the image.
clf;
ImagePlot(A);
title('A Telescope');

%% Compute the Discrete Wavelet Transformation
% We will use the discrete Haar wavelet transformation for this demo.   We next compute three iterations
% of the modified HWT.  The transforation is modified by multiplying the
% filter [sqrt(2)/2, sqrt(2)/2] by sqrt(2).  In this way the filter will
% map integers to integers and improve the performance of
% the Huffman coder.  We need to remember to divide the inverse transform
% by sqrt(2) when we view the compressed image.

% Compute the HWT and store in matrix B.
its=3;
h=sqrt(2)*Haar();
B=WT2D(A,h,its);
 
% Plot the HWT.
clf;
WaveletDensityPlot(B,its,'DivideLinesColor',[1 0 0],...
    'DivideLinesThickness',[2 2 2])
title(sprintf('Haar Wavelet Transformation - %i Iterations',its));

%% Construct the Cumulative Energy Vector
% We now construct the cumulative energy vector for B.  

% Construct the cumulative energy vector.
cewt=CE(B);

% Plot the first 7000 terms.
n=7000;
N=numel(A);
str=sprintf('Cumulative Energy: The First %i Terms (%i Total)',n,N);
close;
plot(cewt(1:7000));
title(str);

%% Set Energy Level
% We next determine the number of terms in B needed to comprise 100*r% of
% the energy in B.

% Set the energy level.
r=.9997;

k=nCE(cewt,r);
str=sprintf('The largest %i elements (in absolute value) of the B constitute %f%% \nof the total energy of the transformation.',k,100*r);
disp(str);

%% Quantize the Transformation
% We now use the Comp function to quantize the transformation.  The routine
% retains the largest (in absolute value) elements needed to comprise 100r%
% of the transformation and converts all other values to 0.  Note that the
% highpass portions of the modified transformation are quite different from
% their original counterparts.

% Perform the quantization.
newB=Comp(B,k);
str=sprintf('We set %i elements in the transform to 0.  This constitutes %f%% \nof the total number of elements in B.',N-k,100*(N-k)/N);
disp(str);

% Plot the modified transformation.
close;
WaveletDensityPlot(newB,its,'DivideLinesColor',[1 0 0],...
    'DivideLinesThickness',[2 2 2]);
title('Quantized Wavelet Transformation');

%% Compute the Huffman Codes for the Modified Transformation
% We now compute the Huffman codes for the modified transformation.  Note
% that we have shifted the elements of newB so that the minimum is 0.  We
% have also rounded the shifted newB since MakeHuffmanCodes requires
% integer input.  The computations were previously done in floating point
% arithmetic to improve computation speed.  The rounding is valid at this
% step since the modified HWT maps integers to integers.

% Make the Huffman codes.
[uniq,freq,codes,origlen,newlen]=MakeHuffmanCodes(round(newB-min(min(newB))));

% Here is some information on the output:
str=sprintf('The original bitstream length is %i and the new bitstream length is %i.',origlen,newlen);
disp(str);

bpp=newlen/N;
str=sprintf('The bits per pixel for the new bitstream is %f bpp.',bpp);
disp(str);

% To get an idea of the best case compression scenario we compute the
% entropy of newB.
e=Entropy(newB);
str=sprintf('The entropy of newB is %f.',e);
disp(str);

%% View the Compressed Image
% Finally we apply the inverse transform to view the compressed image.  We
% also plot the original image for comparative purposes.

% Compute the inverse transformation - don't forget to divide by sqrt(2)!
h=Haar()/sqrt(2);
compressedA=IWT2D(newB,h,its);

% Plot the compressed image.
close;
ImagePlot(compressedA);
title('Compressed Image');

% Plot the original image - make a second figure
figure;
ImagePlot(A);
title('Original Image');

%% Analysis
% The compressed image is not as sharp as the original.  But the
% compression rate is very good - about 1.289bpp!  Note that the entropy is
% approximately .465, so we would expect to achieve a better bpp if we used
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


