function y = BWT1D(v,h,ht,its,varargin)
%BWT1D takes as input a vector of even length, a symmetric biorthogonal filter pair h and ht, and a number of iterations
%its, and returns its iterations of the discrete biorthogonal wavelet
%transformation.  Arguments can be added so that
%BWT1D utilizes the symmetry of the filter pair (see Section 11.3).  In
%this case the call is BWT1D(y,h,ht,its,'Boundary','Reflective').

N=length(v);
if(mod(N,2)==1)
    str=('BWT1D: The length of the input vector must be even. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;

if(round(its)~=its)
    str=sprintf('BWT1D: The number of iterations its must be an integer. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;

maxits=MaxIterations(N);

if(its > maxits)
    str=sprintf('BWT1D: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the input vector.',its,maxits);
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
    boundaryid=varargin{1};
    boundaryon=varargin{2};
else
    boundaryid='Boundary';
    boundaryon='False';
end

for j=1:its,
    b=BWT1D1(a,h,ht,boundaryid,boundaryon);
    a=b(1:N/2^j);
    hp=[b(N/2^j+1:length(b)) ; hp];
end;

y=[a; hp];