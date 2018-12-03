function B = RightWT(A,h)
%RightWT takes as input a matrix A of even dimension M x N and an orthogonal filter h and returns the
%produce A W_N^T, where W_N is the wavelet matrix constructed from h (see Sections 7.1, 7.2, and 8.3).

if ~isvector(h)
    str=sprintf('RightWT: The filter must be a row vector or a column vector.  Returning the input matrix.');
    disp(str);
    B=A;
    return;
end

[r c]=size(A);
L=length(h);

if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('RightWT: The dimensions of the input matrix must be even. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

if mod(L,2)~=0
    str='RightWT: The input filter length must be an even integer - returning the input matrix.';
    disp(str);
    B=A;
    return;
end

if size(h)==[1 L]
    h=h';
end

C=A';
for j=1:r
    B(:,j)=WT1D1(C(:,j),h);
end

B=B';