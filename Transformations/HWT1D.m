function y = HWT1D(v,its)
%HWT1D takes as input a vector of even length and a number of iterations
%its and returns its iterations of the discrete Haar wavelet transformation.

N=length(v);
if(mod(N,2)==1)
    str=('HWT1D: The length of the input vector must be even. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;

if(round(its)~=its)
    str=sprintf('HWT1D: The number of iterations its must be an integer. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;

maxits=MaxIterations(N);

if(its > maxits)
    str=sprintf('HWT1D: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the input vector.',its,maxits);
    disp(str);
    y=v;
    return;
end;

hp=[];
a=v;

for j=1:its,
    b=HWT1D1(a);
    a=b(1:N/2^j);
    hp=[b(N/2^j+1:length(b)) ; hp];
end;

y=[a; hp];