%
% colonies = findcolonies(fname)
% colonies = findcolonies(fname, 
%                         'difference', val1,           (default: 25)
%                         's', val2,                    (default: 0.1)
%                         'radiibound', [low1 high1],   (default: [70 300])
%                         'edgethreshold', [low2 high2],(default: [.15 .25]
%                         'kernelwidth', val3,          (default: 11)
%                         'sensitivity', val4)          (default: .96)
%
% difference    intensity difference between two circles
% s             percentage/100 of increase or decrease of radius to reduce sensitivity (0,1)
% radiibound    lower and upper bounds on the detected radii, number of pixels
% edgethreahold lower and upper bounds of the thresholds of edge detector, (0,1)
% kernelwidth   kernel width of the Gaussian filter for edge detection, positive integer
% sensitivity   sensitivity of circle detector, (0,1)
%
function colonies = findcolonies(fname, options)
    arguments
        fname string
        options.difference (1,1) {mustBeNumeric} = 25
        options.s (1,1) {mustBeNumeric} = 0.1
        options.radiibound (1,2) {mustBeNumeric} = [70 300]
        options.edgethreshold (1,2) {mustBeNumeric} = [0.15 0.25]
        options.kernelwidth (1,1) {mustBeNumeric} = 11
        options.sensitivity (1,1) {mustBeNumeric} = 0.96
    end
    img = imread(fname);
    figure(1);imshow(img);
    img = rgb2gray(img);
    [h,w] = size(img);
    figure(2);imshow(img);
    bw = edge(img,'Canny',options.edgethreshold,options.kernelwidth);
    figure(3);imshow(bw);
    [centers, radii] = imfindcircles(bw,options.radiibound,'Sensitivity',options.sensitivity,'Method','TwoStage');
    figure(2);viscircles(centers, radii,'EdgeColor','b');
    radii = round(radii);
    dist = squareform(pdist(centers));
    n = length(radii);
    affinity = zeros(n);
    for i = 1:n-1
        for j = i+1:n
            if dist(i,j) < radii(i) + radii(j)
                affinity(i,j) = 1;
                affinity(j,i) = 1;
            end
        end
    end
    idx = find(sum(affinity)==1);
    idx = idx(sum(affinity(idx,idx))~=0);
    centers2 = centers(idx,:); 
    radii2 = radii(idx);
    nn = length(idx);
    pairs = zeros(2,nn/2);
    cnt = 0;
    aff_con = affinity(idx,idx);
    for i = 1:nn-1
        for j = i+1:nn
            if aff_con(i,j) == 1
                cnt = cnt + 1;
                pairs(1,cnt) = i;
                pairs(2,cnt) = j;
            end
        end
    end
    med_intensity = zeros(2,nn/2);
    insidenoise = zeros(2,nn/2);
    noisethre = zeros(1,nn/2);
    for i = 1:nn/2
        coor1 = findinside(centers2(pairs(1,i),:),round(radii2(pairs(1,i))*(1-options.s)),w,h);
        coor2 = findinside(centers2(pairs(2,i),:),round(radii2(pairs(2,i))*(1-options.s)),w,h);
        Coor1 = outsidecircle(coor1, centers2(pairs(2,i),:), round(radii2(pairs(2,i))*(1+options.s)));
        Coor2 = outsidecircle(coor2, centers2(pairs(1,i),:), round(radii2(pairs(1,i))*(1+options.s)));
        med_intensity(1,i) = mediangraylevel(img,Coor1);
        med_intensity(2,i) = mediangraylevel(img,Coor2);
        insidenoise(1,i) = findnoise(bw,Coor1);
        insidenoise(2,i) = findnoise(bw,Coor2);
        noisethre(i) = min(radii2(pairs(:,i)))/3;
    end
    
    diff = abs(med_intensity(1,:) - med_intensity(2,:));
    pair_idx = find(diff > options.difference);
    pair_idx = pair_idx(find((sum(insidenoise(:,pair_idx)) < noisethre(pair_idx))> 0));
    final_idx = [];
    for i = 1:length(pair_idx)
        final_idx = [final_idx pairs(1,pair_idx(i)) pairs(2,pair_idx(i))];
    end

    largecircle = cell(1,length(final_idx)/2);
    lcirccenter = zeros(2,length(final_idx)/2);
    lcircradii = zeros(1,length(final_idx)/2);
    for i = 1:length(final_idx)/2
        coor1 = findinside(centers2(final_idx(2*i-1),:),round(radii2(final_idx(2*i-1))*1.0),w,h);
        largecircle{i} = findbigcircle(bw, coor1, centers2(final_idx(2*i-1),:), ...
            radii2(final_idx(2*i-1))*(1-options.s/3), centers2(final_idx(2*i),:), ...
            radii2(final_idx(2*i))*(1-options.s/3));
        for j = 1:size(largecircle{i},2) 
            img(largecircle{i}(2,j),largecircle{i}(1,j)) = 255;
        end
        para = CircleFitByPratt(largecircle{i}');
        lcirccenter(1,i) = para(1);
        lcirccenter(2,i) = para(2);
        lcircradii(i) = para(3);
    end
    figure; imshow(img);
    
    % remove pairs whose bigradius = NaN
    tmp_idx1 = find(isnan(lcircradii)==0);
    tmp_idx2 = [];
    for i = 1:length(tmp_idx1)
        tmp_idx2 = [tmp_idx2 final_idx(2*tmp_idx1(i)-1) final_idx(2*tmp_idx1(i))];
    end
    final_idx = tmp_idx2;
    figure(1);viscircles(round(centers2(final_idx,:)), radii2(final_idx),'EdgeColor','r');

    colonies = [];
    for i = 1:length(final_idx)/2
        colonies(i).center1 = centers2(final_idx(2*i-1),:);
        colonies(i).radius1 = radii2(final_idx(2*i-1));
        colonies(i).medval1 = med_intensity(1,pair_idx(i));
        colonies(i).center2 = centers2(final_idx(2*i),:);
        colonies(i).radius2 = radii2(final_idx(2*i));
        colonies(i).medval2 = med_intensity(2,pair_idx(i));
        colonies(i).bigcenter = lcirccenter(:,i)';
        colonies(i).bigradius = lcircradii(i);
    end
