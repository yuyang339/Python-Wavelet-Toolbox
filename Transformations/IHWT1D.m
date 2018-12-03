function a = IHWT1D(v,its)
%IHWT1D takes as input a vector of even length and a number of iterations
%its and returns its iterations of the inverse discrete Haar wavelet transformation.

N=length(v);
if(mod(N,2)==1)
    str=('HWT1D: The length of the input vector must be even. Returning the input vector.');
    disp(str);
    a=v;
    return;
end;

if(round(its)~=its)
    str=sprintf('HWT1D: The number of iterations its must be an integer. Returning the input vector.');
    disp(str);
    a=v;
    return;
end;

maxits=MaxIterations(N);

if(its > maxits)
    str=sprintf('HWT1D: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the input vector.',its,maxits);
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
    b=IHWT1D1(y);
    z=a(N/(2^(its-j))+1:N);
    a=[b; z];
end;