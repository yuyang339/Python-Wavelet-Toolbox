function [] = ImageList(varargin)
%ImageList gives information about images that come with the 
%DiscreteWavelets package.

global DWIMAGESPATH;

str=sprintf('\n\nThe base directory for the images is \n\n %s \n\nand the images courtesy of Dr. Radka Turcajova.',DWIMAGESPATH);
disp(str);
str=sprintf('\nThe naming convention for the thumbnail image is to add a small to the name.\nFor example, the thumbnail image for benches.png is benches_small.png.');
disp(str);	
str=sprintf('\nThe number in parentheses represents the dimensions and max iterations for the\nthumbnail image.\n\n');
disp(str);

if length(varargin)==2 && isequal(varargin{1},'ImageType')
    imagetype=varargin{2};
else
    imagetype='All';
end

if isequal(imagetype,'GrayScale') || isequal(imagetype,'All')
    str=sprintf('GrayScale%sImages.txt',filesep);
    %header=sprintf('FILE NAME\t\tTYPE\t\tROWS\t\tCOLUMNS\t\tMAX ITERATIONS\n');
    header=sprintf('GRAYSCALE IMAGES\n');
    disp(header);
    file=strcat(DWIMAGESPATH,str);
    fid=fopen(file);
    while 1
        p = fgetl(fid);
        if ~ischar(p),   break,   end
        [fname,p] = strtok(p, ';');
        [frows,p]=strtok(p,';');
        [fcols,p]=strtok(p,';');
        [fmaxits,p]=strtok(p,';');
        str=sprintf('Name: %s\n\t\tDimensions: %s x %s,\tMaxIts: %s\n',fname,frows,fcols,fmaxits);
        disp(str);
    end
    disp(sprintf('\n'));
    fclose(fid);
end
if isequal(imagetype,'Color') || isequal(imagetype,'All')
    str=sprintf('Color%sImages.txt',filesep);
    header=sprintf('COLOR IMAGES\n');
    disp(header);
    file=strcat(DWIMAGESPATH,str);
    fid=fopen(file);
    while 1
        p = fgetl(fid);
        if ~ischar(p),   break,   end
        [fname,p] = strtok(p, ';');
        [frows,p]=strtok(p,';');
        [fcols,p]=strtok(p,';');
        [fmaxits,p]=strtok(p,';');
        str=sprintf('Name: %s\n\t\tDimensions: %s x %s,\tMaxIts: %s\n',fname,frows,fcols,fmaxits);
        disp(str);
    end
    fclose(fid);
end

