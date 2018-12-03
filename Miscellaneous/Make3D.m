function A = Make3D(R,G,B)
%Make3D takes as input three matrices R, G, and B of equal dimensions rxc and returns a
%three-dimensional array A where A(:,:,1)=R, A(:,:,2)=G, and A(:,:,3)=B;

[rR cR]=size(R); 
[rG cG]=size(G); 
[rB cB]=size(B);

if max(abs([rR-rG cR-cG]))==0 && max(abs([rR-rB cR-cB]))==0
    A=zeros(rR,cR,3);
    A(:,:,1)=R; A(:,:,2)=G; A(:,:,3)=B;
else
    str=sprintf('Make3D: The dimensions of the input matrices must be the same - returning a 0 array.');
    disp(str);
    A=zeros(2,2,3);
    return;
end