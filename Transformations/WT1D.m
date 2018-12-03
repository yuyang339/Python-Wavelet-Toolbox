function y = WT1D(v,h,its)
%WT1D takes as input a vector of even length, an even-length orthogonal filter h, and a number of iterations
%its, and returns its iterations of the discrete wavelet transformation.

N=length(v);
if(mod(N,2)==1)
    str=('WT1D: The length of the input vector must be even. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;

if(round(its)~=its)
    str=sprintf('WT1D: The number of iterations its must be an integer. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;

maxits=MaxIterations(N);

if(its > maxits)
    str=sprintf('WT1D: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the input vector.',its,maxits);
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

for j=1:its,
    b=WT1D1(a,h);
    a=b(1:N/2^j);
    hp=[b(N/2^j+1:length(b)) ; hp];
end;

y=[a; hp];