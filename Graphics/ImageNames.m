function varargout = ImageNames(varargin)
%ImageNames gives the absolute path name for each image in the
%DiscreteWavelets package.  Two optional parameters can be provided.
%ImageType can be set to GrayScale, Color, or All (default).  ListThumbnails can be
%set to True or False (default).  In this case, absolute path names are
%given for the thumbnails of each image.  Example calls are
%ImageNames('ImageType','Color') or ImageNames('ListThumbnails','True') or
%ImageNames('ImageType','GrayScale','ListThumbnails','True');

global DWIMAGESPATH;

opts={'ImageType','ListThumbnails'};
vals={'All','False'};

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

if ~isequal(vals{1},'GrayScale') && ~isequal(vals{1},'Color')
    vals{1}='All';
end

if ~isequal(vals{2},'True')
    vals{2}='False';
end

if isequal(vals{1},'GrayScale') || isequal(vals{1},'All')
    imgdir=strcat(DWIMAGESPATH,sprintf('GrayScale%s',filesep));
    file=strcat(imgdir,'Images.txt');
    fid=fopen(file);
    k=1;
    while 1
        p = fgetl(fid);
        if ~ischar(p),   break,   end
        [name,p] = strtok(p, ';');
        if isequal(vals{2},'True')
            name=strrep(name,'.','_small.');
        end
        gname{k}=strcat(imgdir,name);
        k=k+1;
    end
    fclose(fid);
end

if isequal(vals{1},'Color') || isequal(vals{1},'All')
    imgdir=strcat(DWIMAGESPATH,sprintf('Color%s',filesep));
    file=strcat(imgdir,'Images.txt');
    fid=fopen(file);
    k=1;
    while 1
        p = fgetl(fid);
        if ~ischar(p),   break,   end
        [name,p] = strtok(p, ';');
        if isequal(vals{2},'True')
            name=strrep(name,'.','_small.');
        end
        cname{k}=strcat(imgdir,name);
        k=k+1;
    end
    fclose(fid);
end

if isequal(vals{1},'GrayScale')
    varargout{1}=gname;
elseif isequal(vals{1},'Color')
    varargout{1}=cname;
else
	varargout{1}=gname;
    varargout{2}=cname;
end


