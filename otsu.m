clear all;
clc;

a=imread('coins.png');
[rows,columns]=size(a);
b=double(a);
L=256;
% otsus method
rk=0:L-1;
% nk=imhist(a);
nk=zeros(L,1);
for i=1:rows
    for j=1:columns
        val=b(i,j);
%         val+1 as values from 0 to 255
        nk(val+1,1)= nk(val+1,1)+1;
    end
end


prob=nk/(rows*columns);
% pk=cumsum(prob);
pk = zeros(L,1);
sum1=0;
for i=1:L
    sum1=sum1+prob(i,1);
    pk(i,1)=sum1; 
end    
sumk=prob.*rk';
% mk=cumsum(sumk);
mk = zeros(L,1);
sum1=0;
for i=1:L
    sum1=sum1+sumk(i,1);
    mk(i,1)=sum1; 
end    

mg=mk(L,1);
sigma=((mg*pk-mk).^2)./(pk.*(1-pk));
max_sigma=max(sigma);
% if max is not unique
idxs=find(max_sigma==sigma);
% as idxs will be all values from 1-256 but we need 0 to 255
kstar=mean(idxs)-1;
% thresholding the image with optimal value
threshold=kstar;
for i=1:rows
    for j=1:columns
        if a(i,j)>threshold
            b(i,j)=255;
        else
            b(i,j)=0;
        end    
    end
end    

figure;
subplot(1,2,1);
imshow(a);
title('Original image');
subplot(1,2,2);
imshow(b);
title(['Threshold=',num2str(kstar)]);

% calculating sepearability measure
big_mg = ones(L,1)*mg;
sigma_g=((rk'- big_mg).^2).*prob;
sigma_total=sum(sigma_g);
separability = max_sigma/sigma_total;
disp('Separability=');
disp(separability);

