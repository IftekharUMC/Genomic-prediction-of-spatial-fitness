function noise = findnoise(img,coor)
n = size(coor,2);
noise = 0;
for i = 1:n
    if img(coor(2,i),coor(1,i)) ~= 0
        noise = noise + 1;
    end
end