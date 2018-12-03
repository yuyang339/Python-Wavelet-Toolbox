function B = HistogramEQ(A)
%HistogramEQ performs histogram equalization (see Section 3.1) on input
%matrix A.  The elements of the input matrix must be nonnegative integers
%less than 256.

if max(max(abs(round(A)-A)))~=0
    str=sprintf('MakeHistogramEQ: The elements of the input matrix must be integers - returning zero vector.');
    disp(str);
    return;
end
 
if max(max(A<0))==1 || max(max(A>255))==1
    str=sprintf('MakeHistogramEQ: The elements of the input matrix must be nonnegative integers less than 256 - returning zero vector.');
    disp(str);
    return;
end

[r c]=size(A);
n=MakeHistogramEQ(A);
s=cumsum(n)/(r*c);
B=ceil(255*s(A+1));
