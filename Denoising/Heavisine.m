function y=Heavisine(t)
%Heavisine is the test function developed by David Donoho, et. al. for
%testing denoising methods.  The formula is
%heavisine(t)=4*sin(4*pi*t)-sign(t-.3)-sign(.72-t)

y=4*sin(4*pi*t)-sign(t-.3)-sign(.72-t);
