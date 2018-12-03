function [h,ht] = LeGall()
%LeGall returns the LeGall biorthogonal filter pair.

h=[1/2;1;1/2]';
ht=[-1/8;1/4;3/4;1/4;-1/8]';