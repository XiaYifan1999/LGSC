function idx=LGSC(X,Y)

%% Parameters Setting
K1 = 10;     lambda1 = 0.2;
K2 = 10;     lambda2 = 0.6;
gam=1;

%% Run
Xt = X';Yt = Y'; % X :N * 2
%% iteration 1
% % % construct K-NN by kdtree
kdtreeX = vl_kdtreebuild(Xt);
kdtreeY = vl_kdtreebuild(Yt);
[neighborX,~] = vl_kdtreequery(kdtreeX,Xt,Xt,'NumNeighbors',K1+4);
[neighborY,~] = vl_kdtreequery(kdtreeY,Yt,Yt,'Numneighbors',K1+4);
% % % calculate energy of neighborhood graph structure consensus and return p
[x,E] = NGSC_cosF('m',Xt,Yt,neighborX,neighborY,lambda1,K1,gam);
%% iteration 2
idx = find(x == 1);
if length(idx) >= K2+5
    kdtreeX = vl_kdtreebuild(Xt(:, idx));
    kdtreeY = vl_kdtreebuild(Yt(:, idx));
    [neighborX,~] = vl_kdtreequery(kdtreeX, Xt(:,idx),Xt,'NumNeighbors',K2+4);
    [neighborY,~] = vl_kdtreequery(kdtreeY, Yt(:,idx),Yt,'NumNeighbors',K2+4);
    neighborX = idx(neighborX);
    neighborY = idx(neighborY);
    [x,E] = NGSC_cosF('m',Xt,Yt,neighborX,neighborY,lambda2,K2,gam);
end

idx = find(x==1);

end