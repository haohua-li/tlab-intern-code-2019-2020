
% load data (normalized data)
subjectId = 'S12'; 
nightId = 'night2'; 
channelId = 'EEGL'; 
filename = ['HCTSA_ts_' subjectId '_' nightId '_' channelId '_N.mat']; 
load(fullfile(pwd, '..', filename)); 

% specify the filename and load data 
filename = ['sleep_whole_night_cluster_results_' subjectId '_' nightId '_' channelId '_N.mat'] ; 
load(filename)

c = jet(5); % 5 clusters 


%% Plot time-course
figure 
imagesc(idx')
colormap(c)
colorbar;
title('Clusters vs Time Course')
xlabel('Epochs(30s)')
ylabel('Cluster') 

%% Plot tSNE
figure
Y = tsne(TS_DataMat); 
h = gscatter(Y(:,1),Y(:,2),idx); 
title('K-means with tSNE :data of headband ')
for i = 1:5
    h(i).Color = c(i, :); 
end 

%% 
%-------------------------------------------------------------------------
% plot the PCA trajactory 
%------------------------------------------------------------------------- 

% Each row is an observation or sample, Each column is a predictor variable 
X = TS_DataMat; 
% centralize to zero
for i = 1:size(X, 2)
    X(:,i) = X(:,i) - mean(X(:,i)); 
end 

% start the PCA 
[coeff,score,latent,tsquared,explained] = pca(X); 

%% 3D plotting 
figure 
x = score(:,1); 
y = score(:,2); 
z = score(:,3); 
pointsColor = zeros(size(x, 1), 3); 
for i = 1:size(x, 1)
    pointsColor(i, :) = c(idx(i),:); 
end 
hold on
scatter3(x, y, z, 15, pointsColor, 'filled')
title(['PCA to dataset: ', subjectId, ' ', nightId, ' ', channelId])
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')

lh = plot3(x, y, z, '-');           % add line-connection to the Matlab figure  
lh.Color = [0.6, 0.6, 0.6, 0.3]; 

view(3)
grid on 
hold off
