function B = RightHWT(A)
%RightHWT takes as input a matrix A of even dimension M x N and returns the
%product A W_N^T, where W_N is the Haar wavelet matrix (see Section 6.1).

[r c]=size(A);
if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('RightHWT: The dimensions of the input matrix must be even. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

C=A';
for j=1:r
    B(:,j)=HWT1D1(C(:,j));
end

B=B';