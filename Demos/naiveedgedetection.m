%% Naive Edge Detection
% Discrete wavelet transformations provide an easy way to perform naive
% edge detection in digital images.  Our task is to identify locations in a
% given image where large changes in pixel intensities have occurred.

%% Import a Digital Image
% We begin by importing a digital image. We will use one of the images that comes, courtesy of Radka Tezaur, with 
% the DiscreteWavelets Toolbox.  The command ShowThumbnails can be used to see what choices are available.
ShowThumbnails('ImageType','GrayScale');

%Let's use Gray 6.

%% 
% The code below reads this image from disk and plots it.
% ImageNames gives the absolute path to all included image files.
gry=ImageNames('ImageType','GrayScale');

% Use ImageRead to read the image and store it in matrix A.
A=ImageRead(gry{6});

% Use ImagePlot to plot the image.
clf;
ImagePlot(A);
title('A Clown');

%% Compute the Discrete Wavelet Transformation
% We will use the discrete Haar wavelet transformation for this demo.   We next compute two iterations
% of the HWT and plot the result.

% Compute the HWT and store in matrix B.
its=2;
B=HWT2D(A,its);
 
% Plot the HWT.
clf;
WaveletDensityPlot(B,its,'DivideLinesColor',[1 0 0],...
    'DivideLinesThickness',[2 2])
title(sprintf('Haar Wavelet Transformation - %i Iterations',its));

%% Replace the Lowpass Portion with a Matrix of Zeros
% We next replace the lowpass portion of the transformation with a matrix of zeros.

% Grab the dimensions of A and form an appropriately sized zero matrix.
Z=zeros(size(A)./[2^its 2^its]);

% Replace the upper left corner of B with Z and plot the result.
B=PutCorner(B,Z);
clf;
WaveletDensityPlot(B,its,'DivideLinesColor',[1 0 0],...
    'DivideLinesThickness',[2 2])
title('Modified Transformation');

%% Compute the Inverse Discrete Wavelet Transformation
% The final step in the process is to compute two iterations of the inverse HWT on the modified transformation now housed
% in B.

% Compute the inverse transformation.
Edges=IHWT2D(B,its);

clf;
ImagePlot(Edges);
title('The Edges in the Original Image');

%%
% You can get perhaps a better look at the edges if you plot the negative of Edges.

% Plot the negative of Edges.
clf;
ImagePlot(255-Edges);
title('The Edges in the Original Image');

%% Things to Try
% Make a copy of this demo and :
%
% * pick a different image from those provided or use one (grayscale) of your own
% * change the value of iterations to any integer 1, 2,..., 8.
% 

%%
close all;
displayEndOfDemoMessage(mfilename)