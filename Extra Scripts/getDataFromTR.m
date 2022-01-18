best_epochs = zeros(size(TR,1),size(TR,2));
best_perfs = zeros(size(TR,1),size(TR,2));
best_vperfs = zeros(size(TR,1),size(TR,2));
best_tperfs = zeros(size(TR,1),size(TR,2));

for i=1:1:size(TR,1)
    for j=1:1:size(TR,2)
        best_epochs(i,j) = TR{i,j}.best_epoch;
        best_perfs(i,j) = TR{i,j}.best_perf;
        best_vperfs(i,j) = TR{i,j}.best_vperf;
        best_tperfs(i,j) = TR{i,j}.best_tperf;
    end
end