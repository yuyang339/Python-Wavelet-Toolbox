function []=WaveletVectorPlot(v,its,varargin)
%WaveletVectorPlot takes a vector v (presumably obtained by computing the
%wavelet transformation of some vector) and a number of iterations its, and
%plots v with each portion of the transformation separated by grid lines and
%illustrated with a different color.  There are several optional arguments
%that can be passed to the function.
%
%'Region' can be set to either 'All' (default), 'LowPass', or 'HighPass'.  In this case,
%the routine looks for the value of Iteration (see below) and then plots
%the selected portion of v.
%
%'Iteration' can be set to All (default) or any positive integer 1,2,...,its.
%This value is used if Region has been set to HighPass to plot that
%particular region.  If 'Region' is set to 'All' and 'Iteration' is set to
%i, then the routine plots the lowpass portion and highpass portions
%k=1,...,i.
%
%'DivideLines' can be set to 'True' (default) or 'False' in order to show
%or hide gridlines dividing the different portions of the transformation.
%
%'DivideLinesColor' - the user can supply a 1 x 3 vector whose entries are
%in the interval [0,1] that serves as the color of the gridlines.
%
%'DivideLinesThickness' - this value must be a nonnegative integer (default
%is 1) that tells the routine how thick to make the gridlines that separate
%the different portions of the transformation.
%
%'UseColors' - this parameter is set to either 'True' (default) to show the
%different portions of the transformation with different color.  Set the
%parameter to 'False' to use the default color of blue for the entire plot.
%
%'ColorList' - this input must be an nx3 matrix whose entries are
%numbers in the interval [0,1].  If n < its+1, then the nx3 matrix is
%augmented with enough rows so that the number of rows is >=its+1.  In this
%way, the routine has enough colors to plot each portion of the
%transformation.  A default color list (6 colors) is provided with the
%routine.
%
%'Title' - a string can be added to serve as the title of the plot.
%
%Sample Calls:
%
%WaveletVectorPlot(wt,3) - plots all three iterations of the input wt with
%gridlines on.  Each portion of the transformation is displayed using a
%different color.
%
%WaveletVectorPlot(wt,3,'Region','HighPass','Iteration',2) - plots the
%second highpass iteration of transformation.
%
%WaveletVectorPlot(wt,3,'Region','HighPass','Iteration',2,'ColorList',[1 0 1]) 
%plots the second iteration in purple.
%
%
%WaveletVectorPlot(wt,3,'Iteration',2,'ColorList',eye(3))
%plots the lowpass portion of the transformation in red, the first highpass
%portion in green, and the second highpass portion in blue.
%
%WaveletVectorPlot(wt,3,'UseColors','False','DivideLines','False','Title','A Blue Graph')
%plots the entire transformation in blue with no gridlines.

if ~isvector(v)
    str=sprintf('WaveletVectorPlot: The first input must be a vector.');
    disp(str);
    return;
end

if its<=0 || round(its)-its~=0
    str=sprintf('WaveletVectorPlot: The number of iterations must be a nonnegative integer.');
    disp(str);
    return;
end

N=length(v);
maxits=MaxIterations(N);

if its>maxits
    str=sprintf('WaveletVectorPlot: The number of iterations cannot exceed %i.',maxits);
    disp(str);
    return;
end

defcolors=[.25 0 .5; .75 0 .5; .5 .5 0; .25 .5 .5; .5 .25 .25; .5 .5 .75];
defcolors=[defcolors; defcolors; defcolors];

opts={'Region','Iteration','DivideLines','DivideLinesColor','DivideLinesThickness','UseColors','ColorList','Title'};
vals={'All','All','True',[.3 .3 .3],1,'True',defcolors(1:its+1,:),''};

len=length(varargin);
if mod(len,2)~=0
    len=len-1;
end

nms=cell(len);

for k=1:len/2
    nms{k}=varargin{2*k-1};
end

for k=1:len/2
    t=ismember(opts,nms{k});
    [dum,idx]=max(t);
    if dum~=0
        vals{idx}=varargin{2*k};
    end
end

if max(ismember({'LowPass','HighPass'},vals{1}))==0
    vals{1}='All';
end

if isnumeric(vals{2})~=1
    vals{2}=1;
end

if vals{2}<=0 || vals{2}>its
    vals{2}=1;
end

if ~isequal(vals{3},'False')
    vals{3}='True';
end

if ~isvector(vals{4}) || length(vals{4})~=3
    str=sprintf('WaveletVectorPlot: DivideLinesColor must be a vector of length 3.');
    disp(str);
    return;
end

if max(vals{4}<0)==1 || max(vals{4}>1)==1
    str=sprintf('WaveletVectorPlot: The elements of the DivideLinesColor vector must be in the interval [0,1].');
    disp(str);
    return;
end

if round(vals{5})-vals{5}~=0 || vals{5}<0 || vals{5}-N>0
    str=sprintf('WaveletVectorPlot: The values of the DivideLinesThickness must be positive integers smaller than the length of the input vector.');
    disp(str);
    return;
end

if ~isequal(vals{6},'False')
    vals{6}='True';
end

if isequal(vals{6},'True')
    [m n]=size(vals{7});
    if n~=3
        str=sprintf('WaveletVectorPlot: ColorList must be a matrix of size m x 3.');
        disp(str);
        return;
    end
    
    if m<its
        p=floor(its/m);
        for k=1:p
            vals{7}=[vals{7}; vals{7}];
        end
    end
end


if ~ischar(vals{8})
    vals{8}='';
end

%If asked for a particular region, display it and exit.
if max(ismember({'HighPass','LowPass'},vals{1}))
    wtlist=WaveletVectorToList(v,its);
    switch vals{1}
        case 'LowPass'
            y=wtlist(1).lp;
            vals{2}=1;
        case 'HighPass'
            y=wtlist(vals{2}).hp;
    end
    if isequal(vals{6},'True') %Grab a color from ColorList
        plot(y,'Color',vals{7}(vals{2},:));
    else
        plot(y); 
    end
    title(vals{8});
    return;
end

v=v(1:N/2^(vals{2}-1));
N=length(v);
its=its+1-vals{2};

wtlist=WaveletVectorToList(v,its);
x=1:N;
xlist=WaveletVectorToList(x,its);

if isequal(vals{6},'False')
    plot(v);
else
    plot(xlist(1).lp,wtlist(1).lp,'Color',vals{7}(1,:));
    hold on
    for k=1:its
        plot(xlist(k).hp,wtlist(k).hp,'Color',vals{7}(its-k+2,:));
        hold on
    end
end
tix=N* 2.^-linspace(its,0,its+1);
%tix=[tix N];
set(gca,'XTick',tix);
set(gca,'XGrid','on','GridLineStyle','-','XColor',vals{4},'YColor',vals{4});
set(gca,'LineWidth',vals{5});
title(vals{8});
hold off



return;