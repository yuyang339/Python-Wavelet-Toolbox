function B = HWT2D(A,its)
%HWT2D takes as input a matrix A of even dimension M x N and a number of
%iterations its, and returns its iterations of the two-dimensional discrete Haar wavelet transformation.

[r c]=size(A);
if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('HWT2D: The dimensions of the input matrix must be even. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

if(round(its)~=its)
    str=sprintf('HWT2D: The number of iterations its must be an integer. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

maxits=min(MaxIterations(r),MaxIterations(c));

if(its > maxits)
    str=sprintf('HWT2D: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the input matrix.',its,maxits);
    disp(str);
    B=A;
    return;
end;

B=A;

for j=0:its-1
    D=GetCorner(B,r/(2^j),c/(2^j));
    Z=HWT2D1(D);
    B=PutCorner(B,Z);
end
	
