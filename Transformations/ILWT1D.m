function a = ILWT1D(v,its,varargin)
%ILWT1D takes as input a vector of even length and a number of iterations its, and returns its iterations of
%the discrete inverse LeGall wavelet transformation.  Arguments can also be added
%to instruct ILWT1D to return integers.  In this case, the call is
%LWT1D1(v,its,'IntegerMap','True').

N=length(v);
if(mod(N,2)==1)
    str=('BWT1D: The length of the input vector must be even. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;

if(round(its)~=its)
    str=sprintf('LWT1D: The number of iterations its must be an integer. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;

maxits=MaxIterations(N);

if(its > maxits)
    str=sprintf('LWT1D: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the input vector.',its,maxits);
    disp(str);
    y=v;
    return;
end;

if size(v)==[1,N]
    a=v';
else
    a=v;
end

if length(varargin)==2
    integermap=varargin{1};
    integerTF=varargin{2};
else
    integermap='IntegerMap';
    integerTF='False';
end

for j=1:its,
    y=a(1:N/(2^(its-j)));
    b=ILWT1D1(y,integermap,integerTF);
    z=a(N/(2^(its-j))+1:N);
    a=[b; z];
end;