function [labelxs,labelys] = label_compute(neighborX,neighborY)
%% compute node affinity 
% % based on neighbors ranking transformation
% Input:    neighborX - numneighbors * number of set, indexs of K-NN by x
%           neighborY - numneighbors * number of set, indexs of K-NN by y
%           K         - KNN for constructing node(v) and edge(e) affinity
[K,L] = size(neighborX);
Kv=K;
labelxs = zeros(Kv,L);
labelys = zeros(Kv,L);
for i=1:L
    labelx = zeros(1,Kv); labely = zeros(1,Kv);
    for j =1:Kv
        labelx(j) = isempty(find(neighborY(1:j,i) == neighborX(j,i),1));
        labely(j) = isempty(find(neighborX(1:j,i) == neighborY(j,i),1));
    end
    labelxs(1:Kv,i) = labelx';
    labelys(1:Kv,i) = labely';
end
end
