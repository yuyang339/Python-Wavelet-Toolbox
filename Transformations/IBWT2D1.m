function B = IBWT2D1(A,h,ht,varargin)
%IBWT2D1 takes as input a matrix A of even dimension M x N and a symmetric biorthogonal filter pair h and ht, 
%and returns one iteration of the two-dimensional discrete inverse
%biorthogonal wavelet transformation.  Arguments can be added so that
%IBWT2D1 utilizes the symmetry of the filter pair (see Section 11.3).  In
%this case the call is IBWT2D1(A,h,ht,'Boundary','Reflective').

if ~isvector(h)
    str=sprintf('IBWT2D1: The filter must be a row vector or a column vector.  Returning the input matrix.');
    disp(str);
    B=A;
    return;
end

if ~isvector(ht)
    str=sprintf('IBWT2D1: The filter must be a row vector or a column vector.  Returning the input matrix.');
    disp(str);
    B=A;
    return;
end

[r c]=size(A);
M=length(h);
Mt=length(ht);

if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('IBWT2D1: The dimensions of the input matrix must be even. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

if mod(abs(M-Mt),2)~=0
    str='IBWT2D1: The input filter lengths must have the same parity.  Returning the input matrix.';
    disp(str);
    y=v;
    return;
end


if size(h)==[1 M]
    h=h';
end

if size(ht)==[1 Mt]
    ht=ht';
end

if length(varargin)==2
    boundaryid=varargin{1};
    boundaryon=varargin{2};
else
    boundaryid='Boundary';
    boundaryon='False';
end

for j=1:c
    C(:,j)=IBWT1D1(A(:,j),h,ht,boundaryid,boundaryon);
end


for j=1:r
    B(j,:)=IBWT1D1(C(j,:),h,ht,boundaryid,boundaryon);
end

