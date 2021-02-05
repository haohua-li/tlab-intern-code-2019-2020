
% start the first k-means cluster. 
load('HCTSA_N.mat')
k = 20;  % an arbitary number, can be any other. 

% use cosine distance metric (instead of sqeuclidean)
[idx_bench, ctr] = kmeans(TS_DataMat, k, 'Distance', 'sqeuclidean');
% ctr is cluster centroid locations. 
num_diff_cls = zeros(1, k); % how many time that new k-means clustering is differnt from the first outcome we tried.
benchmark = -1 * ones(k, length(idx_bench)+1);
benchmark(:, 1) = 1; % the first element is the length of the array 
for i = 1:length(idx_bench) 
    g = idx_bench(i) ; % which group 
    % insert a new element 
    benchmark(g, 1) = benchmark(g, 1) + 1;
    arr_len = benchmark(g, 1); 
    benchmark(g, arr_len) = i;  % In this cluster, we have these points. 
end 


% Monte Carlo Simulation 
for i = 1:1
    [idx, ~] = kmeans(TS_DataMat, k, 'Distance', 'sqeuclidean');
    % check if we have the same cluster. 
    for c = 1:k
        num_points_per_cluster = benchmark(c, 1); 
        num_collision = 0; 
        % compare any two points 
        for p1_index = 2 : num_points_per_cluster - 1 % the first element is the length of the array 
            for p2_index = p1_index + 1 : num_points_per_cluster
                p1 = benchmark(c, p1_index);  
                p2 = benchmark(c, p2_index); 
                if idx(p1) ~= idx(p2)
                   num_collision = num_collision + 1; 
                end 
            end 
        end
        % normalizse the percentage for this cluster 
        num_diff_cls(c) = num_diff_cls(c) + num_collision/nchoosek(benchmark(c, 1)-1,2); 
    end 
end 

num_diff_cls = num_diff_cls / i; 
