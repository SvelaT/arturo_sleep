function parent = selection(population,fitness,ntournament)
    populationSize = size(population,1);
    randnums = randperm(populationSize);
    randnums = randnums(1:ntournament);
    fitnesses = fitness(randnums);
    [~,parentInd] = min(fitnesses);
    
    parent = population(randnums(parentInd),:);
end

