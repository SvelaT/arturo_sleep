function elites = elitism(population,fitnesses,numElitism)
    elites = zeros(numElitism,size(population,2));
    [~,indexes] = mink(fitnesses,numElitism);
    elites = population(indexes,:);
end

