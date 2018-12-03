function B = IWT2D1(A,h)
%IWT2D1 takes as input a matrix A of even dimension M x N and an orthogonal filter h, and returns 
%one iteration of the two-dimensional discrete inverse wavelet transformation.

if ~isvector(h)
    str=sprintf('IWT2D1: The filter must be a row vector or a column vector.  Returning the input matrix.');
    disp(str);
    B=A;
    return;
end

[r c]=size(A);
L=length(h);

if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('IWT2D1: The dimensions of the input matrix must be even. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

if mod(L,2)~=0
    str='IWT2D1: The input filter length must be an even integer - returning the input matrix.';
    disp(str);
    B=A;
    return;
end

if size(h)==[1 L]
    h=h';
end

for j=1:c
    C(:,j)=IWT1D1(A(:,j),h);
end


for j=1:r
    B(j,:)=IWT1D1(C(j,:),h);
end
