function s = WaveletMatrixToList(A,its)
%WaveletMatrixToList takes as input a matrix A - presumably obtained by
%by applying its iterations of a discrete wavelet transformation - and
%returns a structure s.  The structure has two fields.  The field s(1).lp
%holds the lowpass portion of the transform while s.hp holds the highpass
%portion of the transform.  In particular, s(k,1).hp holds the vertical component of the
%kth highpass portion, s(k,2).hp holds the horizontal component of the
%kth highpass portion, and s(k,3).hp holds the digaonal component of the
%kth highpass portion, k=1,2,...,its.

if round(its)~=its
    str=sprintf('WaveletMatrixToList: The value for its must be an integer - returning the original input matrix.');
    disp(str);
    s=A;
    return;
end

if its<=0
    str=sprintf('WaveletMatrixToList: The value for its must be a positive integer - returning the original input matrix.');
    disp(str);
    s=A;
    return;
end

[r c]=size(A);

maxits=min(MaxIterations(r),MaxIterations(c));

if(its > maxits)
    str=sprintf('WaveletMatrixToList: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input - returning the input matrix.',i,maxits);
    disp(str);
    s=A;
    return;
end;

lpvals=A(1:r/2^its,1:c/2^its);

for j=its:-1:1
    idxr=r/2^j;
    idxc=c/2^j;
    hpvals(j,1)={A(1:idxr,idxc+1:2*idxc)};
    hpvals(j,2)={A(idxr+1:2*idxr,1:idxc)};
    hpvals(j,3)={A(idxr+1:2*idxr,idxc+1:2*idxc)};
end

s=struct('lp',lpvals,'hp',hpvals);
