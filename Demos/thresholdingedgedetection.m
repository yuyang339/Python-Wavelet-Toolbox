%% Thresholding in Edge Detection
%
% To perform naive edge detection in a digital image, we simply compute the
% wavelet transformation of the digital image, convert the lowpass portion
% elements to zero, and then perform an inverse transform.  If we wish, we
% can perform thresholding on the modified transformation before inverting.
% In this case, certain elements of the highpass portions of the transform
% are converted to zero.  These elements are those which the threshold
% process believes do not significantly contribue to any edges in the
% original image.
%
% It is helpful to review the Naive Edge Detection demo prior to viewing
% this demo.

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

%% Compute the Tolerance for Thresholding
% We now compute the tolerance needed to perform thresholding.  We will use
% alpha = 1 to determine the tolerance.  The code that follows is based on
% the material that appears in Section 6.4 of the book.

% Separate the parts of the transform using WaveletMatrixToList.
wtlist=WaveletMatrixToList(B,its);

% We first store the absolute values of all elements in the highpass
% portions of hte tranformation in a vector.
S=[];
for j=1:its
    for k=1:3
        t=reshape(wtlist(j,k).hp,1,numel(wtlist(j,k).hp));
        S = [S abs(t)];
    end
end

%%
%Now we set alpha = 1 and find the threshold.
alpha=1;
%Create an initial starting guess for the tolerance.
t1=(max(S)+min(S))/2;
%Create a value to use to determine when to terminate the algorithm.
diff=t1;
str=sprintf('t1 = %f, diff = %f.',t1,diff);
disp(str);
while diff>=alpha
    %Select everything in S that is larger than t1.
    S1=nonzeros(S.*(S>t1));
    %Compute the mean of the elements in S1.
    avg1=mean(S1);
    %Select everything in S that is less than or equal to t1.
    S2=nonzeros(S.*(S<=t1));
    %Compute the mean of the elements in S2.
    avg2=mean(S2);
    %Compute the new threshold and new difference.
    t2=(avg1+avg2)/2;
    diff=abs(t1-t2);
    t1=t2;
    str=sprintf('avg1 = %f, avg2 = %f, t1 = %f, and diff = %f.',avg1,avg2,...
        t1,diff);
    disp(str);
end

str=sprintf('\nWe will use the tolerance t1 = %f.',t1);
disp(str);

%% Perform Thresholding on Highpass Portions of the Transformation
% We now use t1 to threshold the highpass portions of the transformation.
% Any element in any highpass portion less than t1 (in absolute value) is
% converted to 0.

for j=1:its
    for k=1:3
        wtlist(j,k).hp = wtlist(j,k).hp.*(abs(wtlist(j,k).hp)>=t1);
    end
end
disp('Thresholding complete.');

%% Replace the Lowpass Portion with a Matrix of Zeros
% We next replace the lowpass portion of the transformation with a matrix of zeros.

% Grab the dimensions of A and form an appropriately sized zero matrix.
wtlist(1).lp=zeros(size(A)./[2^its 2^its]);

% Converte wtlist back to a matrix and plot the result.
B=WaveletListToMatrix(wtlist,its);
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