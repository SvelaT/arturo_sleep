function mutChromossome = mutation(chromossome,mutRate)
    mutChromossome = chromossome;
    for i = 1:1:size(chromossome,2)
        if rand() < mutRate
            mutChromossome(i) = ~mutChromossome(i);
        end
    end
end

