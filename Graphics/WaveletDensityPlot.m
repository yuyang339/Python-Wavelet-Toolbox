function []=WaveletDensityPlot(A,its,varargin)
%testing 1,2,3

d=size(A);
t=length(d);
if t<2 || t>3
    str=sprintf('WaveletDensityPlot: The first input must be a matrix or a three-dimensional array.');
    disp(str);
    return;
end

if t==3 && d(3)~=3
    str=sprintf('WaveletDensityPlot: The depth of the three-dimensional array must be 3.');
    disp(str);
    return;
end

if its<=0 || round(its)-its~=0
    str=sprintf('WaveletDensityPlot: The number of iterations must be a nonnegative integer.');
    disp(str);
    return;
end

if t==2
    [r c]=size(A);
    d=0;
else
    [r c d]=size(A);
end

maxits=min([MaxIterations(r),MaxIterations(c)]);
if its>maxits
    str=sprintf('WaveletDensityPlot: The number of iterations cannot exceed %i.',maxits);
    disp(str);
    return;
end


opts={'Region','Iteration','DivideLines','DivideLinesColor','DivideLinesThickness','Title','Magnification'};
vals={'All','All','True',[1 1 1],ones(1,its),'',1};

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

if max(ismember({'Blur','Vertical','Horizontal','Diagonal'},vals{1}))==0
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
    str=sprintf('WaveletDensityPlot: DivideLinesColor must be a vector of length 3.');
    disp(str);
    return;
end

if max(vals{4}<0)==1 || max(vals{4}>1)==1
    str=sprintf('WaveletDensityPlot: The elements of the DivideLinesColor vector must be in the interval [0,1].');
    disp(str);
    return;
end

if length(vals{5})~=its
    str=sprintf('WaveletDensityPlot: The length of the DivideLinesThickness vector must equal the number of iterations %i.',its);
    disp(str);
    return;
end

if max(abs(round(vals{5})-vals{5}))~=0 || max(vals{5}<0)==1 || max(vals{5}>min(r,c))==1
    str=sprintf('WaveletDensityPlot: The values of the DivideLinesThickness must be positive integers.');
    disp(str);
    return;
end

if ~ischar(vals{6})
    vals{6}='';
end

if vals{7}<=0
    str=sprintf('WaveletDensityPlot: The magnification value must be a positive number.');
    disp(str);
    return;
end


%If asked for a particular region, display it and exit.
if max(ismember({'Blur','Vertical','Horizontal','Diagonal'},vals{1}))==1
    if d==0
        wtlist=WaveletMatrixToList(A,its);
        switch vals{1}
            case 'Blur'
                B=LinMap(wtlist(1).lp,0,255);
            case 'Vertical'
                B=LinMap(abs(wtlist(vals{2},1).hp),0,255);
            case 'Horizontal'
                B=LinMap(abs(wtlist(vals{2},2).hp),0,255);
            case 'Diagonal'
                B=LinMap(abs(wtlist(vals{2},3).hp),0,255);
        end
    else
        [R,G,B]=Split3D(A);
        wtlistR=WaveletMatrixToList(R,its);
        wtlistG=WaveletMatrixToList(G,its);
        wtlistB=WaveletMatrixToList(B,its);
        if isequal(vals{1},'Blur')
            BR=LinMap(wtlistR(1).lp,0,255);
            BG=LinMap(wtlistG(1).lp,0,255);
            BB=LinMap(wtlistB(1).lp,0,255);
        else
            switch(vals{1})
                case 'Vertical'
                    idx=1;
                case 'Horizontal'
                    idx=2;
                case 'Diagonal'
                    idx=3;
            end
            BR=LinMap(abs(wtlistR(vals{2},idx).hp),0,255);
            BG=LinMap(abs(wtlistG(vals{2},idx).hp),0,255);
            BB=LinMap(abs(wtlistB(vals{2},idx).hp),0,255);
        end
        B=Make3D(BR,BG,BB);
    end
    
    ImagePlot(B,'Title',vals{6},'Magnification',vals{7});
    return;
end

if d==3
    [R,G,B]=Split3D(A);
else
    R=A; G=A; B=A;
end
R=MakeWaveletPlotChannel(R,its,vals{2},vals{3},vals{4}(1),vals{5});
G=MakeWaveletPlotChannel(G,its,vals{2},vals{3},vals{4}(2),vals{5});
B=MakeWaveletPlotChannel(B,its,vals{2},vals{3},vals{4}(3),vals{5});
A=Make3D(R,G,B);

ImagePlot(A,'Title',vals{6},'Magnification',vals{7});



