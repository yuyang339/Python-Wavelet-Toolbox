function y = YCbCrToRGB(a,varargin)
%YCbCrToRGB takes either a vector of length 3 or a 3-dimensional array
%(where Y, Cb, and Cr are stored in a(:,:,1), a(:,:,2), and
%a(:,:,3), respectively) and returns the conversion to RGB space (see Section 3.2).  
%An optional argument allows the conversion to be made so that the result can be
%displayed onscreen (see Section 3.2).  In this case, the function call is
%YCbCrToRGB(a,'DisplayMode','True');

if isvector(a)
    if length(a)~=3
        str=sprintf('YCbCrToRGB: The input vector must be of length 3 - returning the original input.');
        disp(str);
        y=a;
        return;
    else
        a=reshape(a,3,1);
    end
else
    t=length(size(a));
    if t~=3
        str=sprintf('YCbCrToRGB: The input array must be 3-dimensional - returning the original input.');
        disp(str);
        y=a;
        return;
    end
    [r c d]=size(a);
    if d~=3
        str=sprintf('YCbCrToRGB: The third dimension of the input must be 3 - returning the original input.');
        disp(str);
        y=a;
        return;
    else
        Y=a(:,:,1); 
        Cb=a(:,:,2); 
        Cr=a(:,:,3);
    end
end

A=inv([.299 .587 .114; -.299/1.772 -.587/1.772 .886/1.772; .701/1.402 -.587/1.402 -.114/1.402]/255);

if length(varargin)==2 && isequal(varargin{1},'DisplayMode') && isequal(varargin{2},'True')
    if isvector(a)
        a=(a-[16;128;128])./[219;224;224];
    else
        Y=(Y-16)/219;
        Cb=(Cb-128)/224;
        Cr=(Cr-128)/224;
    end
end

if isvector(a)
    R=A(1,:)*a;
    G=A(2,:)*a;
    B=A(3,:)*a;
    y=[R;G;B];
    return;
end

len=r*c;
t=A*[reshape(Y',1,len); reshape(Cb',1,len); reshape(Cr',1,len)];

R=reshape(t(1,:),c,r)';
G=reshape(t(2,:),c,r)';
B=reshape(t(3,:),c,r)';

y=zeros(r,c,3);
y(:,:,1)=R; y(:,:,2)=G; y(:,:,3)=B;
