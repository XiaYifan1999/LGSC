function Se = Se_compute(Xt,Yt,index,gam)
%% compute Edge Affinity of each Correspondence for Neighborhood Graph
% % based on euclidean distance between neighbor correspondences
% Input:    Xt          - two dimensional coordinates in X image for each feature
%           Yt          - two dimensional coordinates in Y image for each feature
%           neighborX   - numneighbors * number of set, indexs of K-NN by x
%           neighborY   - numneighbors * number of set, indexs of K-NN by y
% Output:   Se          - edge affinity for the neighbors of each correspondence
%% **********************
col = size(index,1);
x1 = Xt(1,:);   y1 = Xt(2,:);
x2 = Yt(1,:);   y2 = Yt(2,:);

x1i = x1(index);  y1i = y1(index);
d1 = sqrt((x1i-repmat(x1,col,1)).^2+(y1i-repmat(y1,col,1)).^2);

x2i = x2(index); y2i = y2(index);
d2 = sqrt((x2i-repmat(x2,col,1)).^2+(y2i-repmat(y2,col,1)).^2);

Se = exp(-abs(d1-gam*d2)./ (max(d1,gam*d2)+1e-6));
end