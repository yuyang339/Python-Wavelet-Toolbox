function B = IBWT2D(A,h,ht,its,varargin)
%IBWT2D takes as input a matrix A of even dimension M x N and a symmetric biorthogonal filter pair h and ht, 
%and a positive integer its, and returns its iterations of the two-dimensional discrete inverse biorthogonal 
%wavelet transformation.  Arguments can be added so that IBWT2D utilizes the symmetry of the filter pair (see Section 11.3).  In
%this case the call is IBWT2D(A,h,ht,its,'Boundary','Reflective').

if ~isvector(h)
    str=sprintf('IBWT2D: The filter must be a row vector or a column vector.  Returning the input matrix.');
    disp(str);
    B=A;
    return;
end

if ~isvector(ht)
    str=sprintf('IBWT2D: The filter must be a row vector or a column vector.  Returning the input matrix.');
    disp(str);
    B=A;
    return;
end

[r c]=size(A);
M=length(h);
Mt=length(ht);

if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('IBWT2D: The dimensions of the input matrix must be even. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

if mod(abs(M-Mt),2)~=0
    str='IBWT2D: The input filter lengths must have the same parity.  Returning the input matrix.';
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

maxits=min(MaxIterations(r),MaxIterations(c));

if(its > maxits)
    str=sprintf('IBWT2D: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the input matrix.',its,maxits);
    disp(str);
    B=A;
    return;
end;

B=A;
for j=1:its
    D=GetCorner(B,r/(2^(its-j)),c/(2^(its-j)));
    Z=IBWT2D1(D,h,ht,boundaryid,boundaryon);
    B=PutCorner(B,Z);
end
	
