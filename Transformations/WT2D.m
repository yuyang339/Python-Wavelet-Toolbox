function B = WT2D(A,h,its)
%WT2D takes as input a matrix A of even dimension M x N, an even-length orthogonal filter h, and a number of iterations
%its, and returns its iterations of the discrete wavelet transformation.

if ~isvector(h)
    str=sprintf('WT2D: The filter must be a row vector or a column vector.  Returning the input matrix.');
    disp(str);
    B=A;
    return;
end

[r c]=size(A);
L=length(h);

if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('WT2D: The dimensions of the input matrix must be even. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

if mod(L,2)~=0
    str='WT2D: The input filter length must be an even integer - returning the input matrix.';
    disp(str);
    B=A;
    return;
end

if size(h)==[1 L]
    h=h';
end

maxits=min(MaxIterations(r),MaxIterations(c));

if(its > maxits)
    str=sprintf('WT2D: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the input matrix.',its,maxits);
    disp(str);
    B=A;
    return;
end;

B=A;

for j=0:its-1
    D=GetCorner(B,r/(2^j),c/(2^j));
    Z=WT2D1(D,h);
    B=PutCorner(B,Z);
end
	
