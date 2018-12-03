function y = WaveletListToVector(s,its)
%WaveletVectorToList takes as input a structure s created by
%WaveletVectorToList and a number of iterations its and returns a vector v
%that represents its iterations of a discrete wavelet transformation.  The 
%structure has two fields.  The field s(1).lp holds the lowpass portion of the 
%transform while s.hp holds the highpass portion of the transform.  In particular, 
%s(1).hp holds the first highpass portion, s(2).hp, the second highpass portion, etc.

if round(its)~=its
    str=sprintf('WaveletListToVector: The value for its must be an integer - returning the original input vector.');
    disp(str);
    s=v;
    return;
end

if its<=0
    str=sprintf('WaveletListToVector: The value for its must be a positive integer - returning the original input vector.');
    disp(str);
    s=v;
    return;
end

y=s(1).lp;

for k=its:-1:1
    y=[y; s(k).hp];
end
