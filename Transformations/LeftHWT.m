function B = LeftHWT(A)
%LeftHWT takes as input a matrix A of even dimension M x N and returns the
%produce W_M A, where W_M is the Haar wavelet matrix (see Section 6.1).

[r c]=size(A);
if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('LeftHWT: The dimensions of the input matrix must be even. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

for j=1:c
    B(:,j)=HWT1D1(A(:,j));
end