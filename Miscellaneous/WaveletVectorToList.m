function s = WaveletVectorToList(v,its)
%WaveletVectorToList takes as input a vector v - presumably obtained by
%by applying its iterations of a discrete wavelet transformation - and
%returns a structure s.  The structure has two fields.  The field s(1).lp
%holds the lowpass portion of the transform while s.hp holds the highpass
%portion of the transform.  In particular, s(1).hp holds the first highpass
%portion, s(2).hp, the second highpass portion, etc.

if round(its)~=its
    str=sprintf('WaveletVectorToList: The value for its must be an integer - returning the original input vector.');
    disp(str);
    s=v;
    return;
end

if its<=0
    str=sprintf('WaveletVectorToList: The value for its must be a positive integer - returning the original input vector.');
    disp(str);
    s=v;
    return;
end

if ~isvector(v)
    str=sprintf('WaveletVectorToList: v must be either a row vector or a column vector - returning the original input vector.');
    disp(str);
    s=v;
    return;
end

n=length(v);
if size(v)==[1 n]
    v=v';
end

if mod(n,2^its)~=0
    str=sprintf('WaveletVectorToList: %i iterations cannot be performed on a vector of length %i - returning the original input vector.',its,n);
    disp(str);
    s=v;
    return;
end

if ~isvector(v)
    str=sprintf('WaveletVectorToList: v must be either a row vector or a column vector - returning the original input vector.');
    disp(str);
    s=v;
    return;
end

lpvals=v(1:n/2^its);

for j=its:-1:1
    idx=n/2^j;
    hpvals(j)={v(idx+1:2*idx)};
end

s=struct('lp',lpvals,'hp',hpvals);
