times = zeros(size(TR,1),size(TR,2));

for i = 1:1:size(TR,1)
    for j = 1:1:size(TR,2)
        tr = TR{i,j};
        if ~isempty(tr)
            times(i,j) = max(tr.time);
        end
    end
end