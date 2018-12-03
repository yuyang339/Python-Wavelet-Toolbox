function y=MAD(v)
%MAD computes the median absolute deviation of input v.  v can be a matrix
%or a vector.

[r c]=size(v);
v=reshape(v,1,r*c);
y=median(abs(v-median(v)));