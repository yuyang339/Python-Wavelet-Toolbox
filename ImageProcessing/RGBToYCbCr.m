function y = RGBToYCbCr(a,varargin)
%RGBToYCbCr takes either a vector of length 3 or a 3-dimensional array
%(where Red, Green, and Blue are stored in a(:,:,1), a(:,:,2), and
%a(:,:,3), respectively) and returns the conversion to YCbCr space (see Section 3.2).  
%An optional argument allows the conversion to be made so that the result can be
%displayed onscreen (see Section 3.2).  In this case, the function call is
%RGBToYCbCr(a,'DisplayMode','True');

if isvector(a)
    if length(a)~=3
        str=sprintf('RGBToYCbCr: The input vector must be of length 3 - returning the original input.');
        disp(str);
        y=a;
        return;
    else
        a=reshape(a,3,1);
    end
else
    t=length(size(a));
    if t~=3
        str=sprintf('RGBToYCbCr: The input array must be 3-dimensional - returning the original input.');
        disp(str);
        y=a;
        return;
    end
    [r c d]=size(a);
    if d~=3
        str=sprintf('RGBToYCbCr: The third dimension of the input must be 3 - returning the original input.');
        disp(str);
        y=a;
        return;
    else
        R=a(:,:,1); 
        G=a(:,:,2); 
        B=a(:,:,3);
    end
end
        
A=[.299 .587 .114; -.299/1.772 -.587/1.772 .886/1.772; .701/1.402 -.587/1.402 -.114/1.402]/255;

if length(varargin)==2 && isequal(varargin{1},'DisplayMode') && isequal(varargin{2},'True')
    dflag=1;
else
    dflag=0;
end

if isvector(a)
    if dflag==0
        Y=A(1,:)*a;
        Cb=A(2,:)*a;
        Cr=A(3,:)*a;
    else
        Y=219*A(1,:)*a+16;
        Cb=224*A(2,:)*a+128;
        Cr=224*A(3,:)*a+128;
    end
    y=[Y;Cb;Cr];
    return;
end

len=r*c;
t=A*[reshape(R',1,len); reshape(G',1,len); reshape(B',1,len)];

if dflag==0
    Y=reshape(t(1,:),c,r)';
    Cb=reshape(t(2,:),c,r)';
    Cr=reshape(t(3,:),c,r)';
else
    Y=219*reshape(t(1,:),c,r)'+16;
    Cb=224*reshape(t(2,:),c,r)'+128;
    Cr=224*reshape(t(3,:),c,r)'+128;
end

y=zeros(r,c,3);
y(:,:,1)=Y; y(:,:,2)=Cb; y(:,:,3)=Cr;