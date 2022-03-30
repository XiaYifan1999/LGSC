function [p,E] = NGSC_cosF(ms,Xt,Yt,neighborX,neighborY,lambda,K,gam)
%% Neighborhood Graph Structure Consensus
% based on consensus of neighborhood topology
% multi-scaled NGSC
% Input:    neighborX - numneighbors * number of set, indexs of K-NN by x
%           neighborY - numneighbors * number of set, indexs of K-NN by y
%           lambda    - threshold for distinguishing inliers and outliers
%           K         - KNN for constructing node(v) and edge(e) affinity
% Output:   p         - binary vector indicating inlier or outlier, 1 - inlier
%           E         - energy of each correspondence

%% Parameters Prepare
E = zeros(1,size(neighborX,2));

if ms=='s'
    Km=K;
else if ms=='m'
        Km = K+3:-3:K-3;
        if K<4
            Error( 'K must be not less than 4, so that the multi-scale is not less than [1 4 7]')
        end
    else
        error('error for m/s setting')
    end
end
M = length(Km);
Klabel=max(Km)+1;
[labelxs,labelys] = label_compute(neighborX(2:Klabel,:),neighborY(2:Klabel,:));
for KK = Km
    neighborX2 = neighborX(2:KK+1,:);
    neighborY2 = neighborY(2:KK+1,:);
    neighborIndex = [neighborX2; neighborY2];
    index = sort(neighborIndex);
    dif = diff(index);
    temp = (dif == zeros(size(dif,1),size(dif,2)));
    xKK = [ones(1,size(neighborX2,2));temp ; zeros(1,size(neighborX2,2))];
    
    Se = Se_compute(Xt,Yt,index,gam)./KK;
    Sv = 1-sum(labelxs(1:KK,:)+labelys(1:KK,:))./(2*KK);
    W = [Sv;Se]./2;
    
    E = E + sum(W.*xKK);
end
E = E/M;
p = E >= lambda;
end

% function plot_localgraph(Xt,Yt,index,xKK)
% 
% x_ax.left=min(Xt(1,:))-20;
% x_ax.right=max(Xt(1,:))+20;
% x_ax.up = max(Xt(2,:))+20;
% x_ax.down=min(Xt(2,:))-20;
% 
% 
% y_ax.left=min(Yt(1,:))-20;
% y_ax.right=max(Yt(1,:))+20;
% y_ax.up = max(Yt(2,:))+20;
% y_ax.down=min(Yt(2,:))-20;
% 
% edge=xKK(2:end,:);
% edge_index=edge.*double(index);
% n = size(Xt,2);
% figure;
% for i=1:n
%     color=rand([1,3]);
%     for j=1:size(index,1)
%         if edge_index(j,i)~=0
%             plot([Xt(1,i),Xt(1,index(j,i))],[Xt(2,i),Xt(2,index(j,i))],'Color',color);
%             hold on;
%         end
%     end
% end
% axis equal
% axis([x_ax.left x_ax.right x_ax.down x_ax.up]);
% set(gca,'XTick',[])
% set(gca,'YTick',[])
% figure;
% for i=1:n
%     color=rand([1,3]);
%     for j=1:size(index,1)
%         if edge_index(j,i)~=0
%             plot([Yt(1,i),Yt(1,index(j,i))],[Yt(2,i),Yt(2,index(j,i))],'Color',color);
%             hold on;
%         end
%     end
% end
% axis equal
% axis([y_ax.left y_ax.right y_ax.down y_ax.up]);
% set(gca,'XTick',[])
% set(gca,'YTick',[])
% end