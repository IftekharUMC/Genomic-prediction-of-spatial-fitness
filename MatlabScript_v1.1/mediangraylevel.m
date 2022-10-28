function med = mediangraylevel(img,coor)
n = size(coor,2);
tmp = zeros(1,n);
for i = 1:n
    tmp(i) = img(coor(2,i),coor(1,i));
end
med = median(tmp);