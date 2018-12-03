function a = IWT1D(v,h,its)
%IWT1D takes as input a vector of even length, an even-length orthogonal filter h, and a number of iterations
%its, and returns its iterations of the inverse discrete wavelet transformation.

N=length(v);
if(mod(N,2)==1)
    str=('IWT1D: The length of the input vector must be even. Returning the input vector.');
    disp(str);
    a=v;
    return;
end;

if(round(its)~=its)
    str=sprintf('IWT1D: The number of iterations its must be an integer. Returning the input vector.');
    disp(str);
    a=v;
    return;
end;

maxits=MaxIterations(N);

if(its > maxits)
    str=sprintf('IWT1D: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the input vector.',its,maxits);
    disp(str);
    a=v;
    return;
end;

if size(v)==[1,N]
    a=v';
else
    a=v;
end

for j=1:its,
    y=a(1:N/(2^(its-j)));
    b=IWT1D1(y,h);
    z=a(N/(2^(its-j))+1:N);
    a=[b; z];
end;