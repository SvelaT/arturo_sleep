function [best_chromossome,best_fitness,populations,fitnesses] = geneticalgorithm(chroSize,populationSize,fitFunc,percCross,numElitism,mutationRate,nGenerations,ntournament,npoints)
    numChildren = populationSize - numElitism;
    numCross = round(numChildren*percCross);
    numMutated = numChildren - numCross;
    crossoverChildren = zeros(numCross,chroSize);
    mutatedChildren = zeros(numMutated,chroSize);
    
    disp(['Running Generation ' num2str(1)]);
    population = genPopulation(chroSize,populationSize);
    fitness = evalFitness(population,fitFunc);
    populations{1} = population;
    fitnesses{1} = fitness;
    for i = 2:1:nGenerations
        disp(['Running Generation ' num2str(i)]);
        elites = elitism(population,fitness,numElitism);
        for j = 1:1:numCross
            parent1 = selection(population,fitness,ntournament);
            parent2 = selection(population,fitness,ntournament);
            
            crossoverChildren(j,:) = mutation(crossover(parent1,parent2,npoints),mutationRate(i));
        end
        for j = 1:1:numMutated
            parent = selection(population,fitness,ntournament);
            
            mututedChildren(j,:) = mutation(parent,mutationRate(i));
        end
        population = [elites;crossoverChildren;mututedChildren];
        fitness = evalFitness(population,fitFunc);
        populations{i} = population;
        fitnesses{i} = fitness;
    end
    [~,index] = min(fitness);
    best_chromossome = population(index,:);
    best_fitness = fitness(index);
end

