function y = LWT1D(v,its,varargin)
%LWT1D takes as input a vector of even length and a number of iterations its, and returns its iterations of
%the discrete LeGall wavelet transformation.  Arguments can also be added
%to instruct LWT1D to return integers.  In this case, the call is
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

hp=[];
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
    b=LWT1D1(a,integermap,integerTF);
    a=b(1:N/2^j);
    hp=[b(N/2^j+1:length(b)) ; hp];
end;

y=[a; hp];