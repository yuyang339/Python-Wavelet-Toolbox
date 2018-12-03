function B = ILWT2D1(A,varargin)
%ILWT2D1 takes as input a matrix A of even dimension M x N and returns 
%one iteration of the two-dimensional discrete inverse LeGall wavelet transformation.  Arguments can also be added
%to instruct LWT2D1 to return integers.  In this case, the call is
%ILWT2D1(A,'IntegerMap','True').

[r c]=size(A);

if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('ILWT2D1: The dimensions of the input matrix must be even. Returning the input matrix.');
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

for j=1:c
    C(:,j)=ILWT1D1(A(:,j),integermap,integerTF);
end

for j=1:r
    B(j,:)=ILWT1D1(C(j,:),integermap,integerTF);
end