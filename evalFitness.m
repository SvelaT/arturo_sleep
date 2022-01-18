function fitnesses = evalFitness(population,fitFunc)
    fitnesses = zeros(size(population,1),1);
    for i = 1:1:size(population,1)
        fitnesses(i) = fitFunc(population(i,:));
    end
end

