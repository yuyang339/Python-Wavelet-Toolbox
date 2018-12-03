function [] = ImagePlot(A,varargin)
%ImagePlot takes either a matrix or a three-dimensional array and displays
%the input (grayscale for an input matrix, color for a three-dimensional
%array).  
%
%
%The routine accepts three optional arguments.  
%
%LinearScaling can be set to either True, LeftWT, or RightWT.  The default value is False.  In
%this case no scaling is performed.  If LinearScaling is set to Linear, the
%input is scaled so that the minimum is 0 and the maximum is 255.  If
%LinearScaling is set to LeftWT (RightWT) then the routine scales the bottom (right) half of
%the image to improve the contrast of the highpass portion of the transform.
%
%
%ChannelColor can be set to shade the intensities
%from the input matrix by a particular color (default is white).  The value
%of this parameter should be a 3-vector of an RGB triple.  ChannelColor is
%only applied to grayscale images.
%
%Title can be set to add a title to the graphic.
%
%
%Magnification can be set to make the output image size smaller or larger.
%The default value is 1.
%
%Example Calls: 
%   ImagePlot(A,'LinearScaling','LeftWT','ChannelColor',[1 0 0])
%   ImagePlot[A,'ChannelColor',[0 0 1],'Title','Figure 3.7','LinearScaling','True')

opts={'LinearScaling','ChannelColor','Title','Magnification'};
vals={'False',[1 1 1],'',1};

len=length(varargin);
if mod(len,2)~=0
    len=len-1;
end

if len>0
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
end

if ~ischar(vals{3})
    vals{3}='';
end

if max(ismember({'True','False','LeftWT','RightWT'},vals{1}))==0
    vals{1}='False';
end

if max(vals{2}<0)==1 && max(vals{2}>1)==1
    str=sprintf('ImagePlot: The values of ColorChannel must be in the interval [0,1]. ChannelColor set to white.');
    disp(str);
    vals{2}=[1 1 1];
end

if ~isvector(vals{2})
    str=sprintf('ImagePlot: The value of ColorChannel must be a vector of length 3. ChannelColor set to white.');
    disp(str);
    vals{2}=[1 1 1];
end

if length(vals{2})~=3
    str=sprintf('ImagePlot: The value of ColorChannel must be a vector of length 3. ChannelColor set to white.');
    disp(str);
    vals{2}=[1 1 1];
end

t=size(A);
if length(t)<2 || length(t)>3
    str=sprintf('ImagePlot: The input must be a matrix or a 3-dimensional array whose depth is 3.');
    disp(str);
    return;
end

if length(t)==3 && t(3)~=3
    str=sprintf('ImagePlot: The third dimension of the input must be 3.');
    disp(str);
    return;
end

%figure;
if length(t)==2
    A=double(A);
    [r c]=size(A);
    if isequal(vals{1},'LeftWT') && mod(r,2)~=0
        str=sprintf('ImagePlot: For LinearScaling set to LeftWT, the number of rows in the image must be even. No scaling applied.');
        disp(str);
        vals{1}='False';
    end

    if isequal(vals{1},'RightWT') && mod(c,2)~=0
        str=sprintf('ImagePlot: For LinearScaling set to LeftWT, the number of columns in the image must be even. No scaling applied.');
        disp(str);
        vals{1}='False';
    end
    switch vals{1}
        case 'True'
            A=LinMap(A,0,255);
        case 'LeftWT'
            top=A(1:r/2,:);
            bot=LinMap(abs(A(r/2+1:end,:)),0,255);
            A=[top;bot];
        case 'RightWT'
            left=A(:,1:c/2);
            right=LinMap(abs(A(:,c/2+1:end)),0,255);
            A=[left right];
    end
    image(A);
    cm=[linspace(0,vals{2}(1),256);linspace(0,vals{2}(2),256);linspace(0,vals{2}(3),256)]';
    colormap(cm);
else
    [r c d]=size(A);
    switch vals{1}
        case 'True'
            [R,G,B]=Split3D(A);
            R=LinMap(R,0,255);
            G=LinMap(G,0,255);
            B=LinMap(B,0,255);
            A=Make3D(R,G,B);
        case 'LeftWT'
            [R,G,B]=Split3D(A);
            Rtop=R(1:r/2,:);
            Rbot=LinMap(abs(R(r/2+1:end,:)),0,255);
            Gtop=G(1:r/2,:);
            Gbot=LinMap(abs(G(r/2+1:end,:)),0,255);
            Btop=B(1:r/2,:);
            Bbot=LinMap(abs(B(r/2+1:end,:)),0,255);
            R=[Rtop;Rbot];
            G=[Gtop;Gbot];
            B=[Btop;Bbot];
            A=Make3D(R,G,B);
        case 'RightWT'
            [R,G,B]=Split3D(A);
            Rleft=R(:,1:c/2);
            Rright=LinMap(abs(R(:,c/2+1:end)),0,255);
            Gleft=G(:,1:c/2);
            Gright=LinMap(abs(G(:,c/2+1:end)),0,255);
            Bleft=B(:,1:c/2);
            Bright=LinMap(abs(B(:,c/2+1:end)),0,255);
            R=[Rleft Rright];
            G=[Gleft Gright];
            B=[Bleft Bright];
            A=Make3D(R,G,B);
    end
    image(uint8(A)); 
end

if ~isequal(vals{3},'')
    title(vals{3});
end
axis image off;

screen=get(0,'screensize');
screenw=screen(3);
screenh=screen(4);
figposition=[(screenw-vals{4}*c)/2 (screenh-vals{4}*r)/2 vals{4}*c vals{4}*r];
set(gcf,'Position',figposition); % set size of figure
set(gca,'OuterPosition',[0 0 1 1] ); % set size of axis
  
%p=get(gcf,'Position');
%set(gcf,'Position',[p(1) p(2) r, c]); % set size of figure


