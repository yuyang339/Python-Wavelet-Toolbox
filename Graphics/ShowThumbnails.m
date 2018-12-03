function [] = ShowThumbnails(varargin)
%ShowThumbnails displays thumbnails for images that come with the
%DiscreteWavelets package.  An optional argument can be used to stipulate
%which type of thumbnails are to be displayed.  If no argument is provided,
%then the routine displays all grayscale and color images that come with
%the package.  If ImageType is set to GrayScale (Color), then only
%grayscale (color) thumbnails are displayed.
%
%
%Example Calls: 
%   ShowThumbnails('ImageType','GrayScale');
%   ShowThumbnails('ImageType','Color');

if length(varargin)==2 && isequal(varargin{1},'ImageType')
    type=varargin{2};
    if ~isequal(type,'GrayScale') && ~isequal(type,'Color')
        type='All';
    end
else
    type='All';
end

sc=linspace(0,1,256);
if isequal(type,'GrayScale') || isequal(type,'All')
    gry=ImageNames('ImageType','GrayScale','ListThumbnails','True');
    figure;
    rows=ceil(length(gry)/5);
    for k=1:length(gry)
        img=ImageRead(gry{k});
        subplot(rows,5,k); 
        image(img);
        axis image off;
        cm=[sc;sc;sc]';
        colormap(cm);
        str=sprintf('Gray %i',k);
        title(str);
    end
end

if isequal(type,'Color') || isequal(type,'All')
    clr=ImageNames('ImageType','Color','ListThumbnails','True');
    figure;
    for k=1:length(clr)
        img=ImageRead(clr{k});
        rows=ceil(length(clr)/4);
        subplot(rows,4,k)
        image(uint8(img));
        axis image off;
        str=sprintf('Color %i',k);
        title(str);
    end
end
    