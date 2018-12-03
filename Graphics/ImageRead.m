function A = ImageRead(file,varargin)
%ImageRead takes a filename or a url and returns either a matrix
%(grayscale) or a three-dimensional 
%array (color) that represents the digital image.  If the file 
%does not exist, the routine returns a 2 x 2 zero matrix.  The routine can
%be called with optional arguments.  Setting 'PowersOfTwo' to n (0 is the default) 
%will cause the routine to chop enough rows/columns off the bottom/right so that the
%dimensions of the image are divisible by 2^n.  PrintInfo can be set to
%True (False is default) to force the routine to print information about
%the image.  Example calls are ImageRead(file,'PowersOfTwo',3) or
%ImageRead(file,'PrintInfo','True',PowersOfTwo',1);

opts={'PowersOfTwo','PrintInfo'};
vals={0,'False'};

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

img=imread(file);
[r c d]=size(img);

if 2^vals{1}>min(r,c)
    str=sprintf('ReadImage: The choice of PowersOfTwo results in a value that is larger than at least one of the dimensions of the input matrix - returning a 2x2 zero matrix.');
    disp(str);
    A=double(zeros(2,2));
    return;
end

if vals{1}<0 || vals{1}-round(vals{1})~=0
    str=sprintf('ReadImage: The choice of PowersOfTwo must be nonnegative integer- returning a 2x2 zero matrix.');
    disp(str);
    A=double(zeros(2,2));
    return;
end

if ~isequal(vals{2},'True')
    vals{2}='False';
end

switch d
    case 1
        A=double(img);
        type='grayscale';
        chopr=0;
        chopc=0;
        if vals{1}>0
            chopr=mod(r,2^vals{1});
            chopc=mod(c,2^vals{1});
            A=img(1:r-chopr,1:c-chopc);
        end
    case 3
        A=double(img);
        type='color';
        chopr=0;
        chopc=0;
        if vals{1}>0
            chopr=mod(r,2^vals{1});
            chopc=mod(c,2^vals{1});
            [R,G,B]=Split3D(A);
            R=R(1:r-chopr,1:c-chopc);
            G=G(1:r-chopr,1:c-chopc);            
            B=B(1:r-chopr,1:c-chopc);
            A=Make3D(R,G,B);
       end
    otherwise
        str=sprintf('\nReadImage: The input image has more than three channels and cannot be processed.  Returning a 2x2 zero matrix.');
        disp(str);
        A=double(zeros(2,2));
        return;
end

if isequal(vals{2},'True')
    if chopr~=0 || chopc~=0
        str=sprintf('\nChopping %i columns off the right and %i rows off the bottom of the image.\n',chopc,chopr);
        disp(str);
    end
    str=sprintf('\nThe dimensions of the image are %i x %i and the file was processed as a %s image.',r-chopr,c-chopc,type);
    disp(str);
    maxits=min(MaxIterations(r-chopr),MaxIterations(c-chopc));
    str=sprintf('\nA total of %i iterations of a wavelet transform can be performed on the image.',maxits);
    disp(str);
end

