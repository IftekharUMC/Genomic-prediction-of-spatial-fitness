function coor = findinside(center, radius, w, h)
coor = zeros(2,radius^2 * 4);
left = max(1,ceil(center(1) - radius));
right = min(w, floor(center(1) + radius));
top = max(1,ceil(center(2) - radius));
bottom = min(h, floor(center(2) + radius));
cnt = 0;
for x = left:right
    for y = top:bottom
        if (x-center(1))^2 + (y-center(2))^2 <= radius^2
            cnt = cnt + 1;
            coor(1,cnt) = x;
            coor(2,cnt) = y;
        end
    end
end
coor = coor(:,1:cnt);
