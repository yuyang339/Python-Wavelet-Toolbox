function B = ILWT2D(A,its,varargin)
%ILWT2D takes as input a matrix A of even dimension M x N and a number of iterations its, and returns 
%its iterations of the two-dimensional discrete LeGall wavelet transformation.  Arguments can also be added
%to instruct ILWT2D to return integers.  In this case, the call is
%ILWT2D(A,its,'IntegerMap','True').

[r c]=size(A);

if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('LWT2D: The dimensions of the input matrix must be even. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

maxits=min(MaxIterations(r),MaxIterations(c));

if(its > maxits)
    str=sprintf('LWT2D: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the input matrix.',its,maxits);
    disp(str);
    B=A;
    return;
end;

if length(varargin)==2
    integermap=varargin{1};
    integerTF=varargin{2};
else
    integermap='IntegerMap';
    integerTF='False';
end

B=A;
for j=1:its
    D=GetCorner(B,r/(2^(its-j)),c/(2^(its-j)));
    Z=ILWT2D1(D,integermap,integerTF);
    B=PutCorner(B,Z);
end

