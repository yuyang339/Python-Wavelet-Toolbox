function A = WaveletListToMatrix(s,its)
%WaveletListToMatrix takes as input a structure s created by
%WaveletMatrixToList and a number of iterations its and returns a matrix A
%that represents its iterations of a discrete wavelet transformation.  The structure s has two fields.  The field s(1).lp
%holds the lowpass portion of the transform while s.hp holds the highpass
%portion of the transform.  In particular, s(k,1).hp holds the vertical component of the
%kth highpass portion, s(k,2).hp holds the horizontal component of the
%kth highpass portion, and s(k,3).hp holds the digaonal component of the
%kth highpass portion, k=1,2,...,its.

if round(its)~=its
    str=sprintf('WaveletListToMatrix: The value for its must be an integer - returning the original input matrix.');
    disp(str);
    A=s;
    return;
end

if its<=0
    str=sprintf('WaveletListToMatrix: The value for its must be a positive integer - returning the original input matrix.');
    disp(str);
    A=s;
    return;
end

A=s(1).lp;

for j=its:-1:1
    A=[A s(j,1).hp; s(j,2).hp s(j,3).hp];
end

