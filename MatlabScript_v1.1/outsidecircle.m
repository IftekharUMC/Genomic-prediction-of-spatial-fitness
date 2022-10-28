function coor_o = outsidecircle(coor_i, center, radius)
n = size(coor_i,2);
coor_o = zeros(2,n);
cnt = 0;
for i = 1:n
    if (coor_i(1,i) - center(1))^2 + (coor_i(2,i) - center(2))^2 > radius^2
        cnt = cnt + 1;
        coor_o(1,cnt) = coor_i(1,i);
        coor_o(2,cnt) = coor_i(2,i);
    end
end
coor_o = coor_o(:,1:cnt);