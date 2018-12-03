function y=UniversalThreshold(v,h,its)
%UniversalThreshold takes a vector or matrix, an orthogonal filter, 
%and a number of iterations for the wavelet transform and returns the 
%universal threshold tolerance.

if ~isvector(h)
    str='UniversalThreshold: The input filter must be a row vector or a column vector - returning 0';
    disp(str);
    y=0;
    return;
end

if mod(length(h),2)~=0
    str='UniversalThreshold: The input filter length must be an even integer - returning 0.';
    disp(str);
    y=0;
    return;
end

if(round(its)~=its)
    str=sprintf('UniversalThreshold: The number of iterations its must be an integer - returning 0.');
    disp(str);
    y=0;
    return;
end;

if isvector(v)
    maxits=MaxIterations(length(v));
    n=length(v);
    d=2^its;
else
    [r c]=size(v);
    maxits=min(MaxIterations(r),MaxIterations(c));
    n=r*c;
    d=2^(2*its);
end

if(its > maxits)
    str=sprintf('UniversalThreshold: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning 0.',i,maxits);
    disp(str);
    y=0;
    return;
end;

sigma=NoiseEstimate(v,h);
len=n-n/d;
y=sigma*sqrt(2*log(len));