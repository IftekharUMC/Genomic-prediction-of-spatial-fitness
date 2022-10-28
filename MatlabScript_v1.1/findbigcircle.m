function coorout = findbigcircle(img, coorin, center1, radius1, center2, radius2)
coorout = coorin;
cnt = 0;
n = size(coorin,2);
for i = 1:n
    if img(coorin(2,i),coorin(1,i)) == 1 && ...
            (coorin(1,i) - center1(1))^2 + (coorin(2,i) - center1(2))^2 < radius1^2 && ...
            (coorin(1,i) - center2(1))^2 + (coorin(2,i) - center2(2))^2 < radius2^2
        cnt = cnt + 1;
        coorout(1,cnt) = coorin(1,i);
        coorout(2,cnt) = coorin(2,i);
    end
end
coorout = coorout(:,1:cnt);
