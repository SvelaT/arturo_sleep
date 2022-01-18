function diversityValue = calcDiversity(population)
    diversityConstant = 2/(size(population,2)*size(population,1)*(size(population,1)-1));
    hammingDistance = 0;
    for i = 1:1:size(population,1)
        for j = 1:1:i
            if j < i
                hammingDistance = hammingDistance + sum(abs(population(i,:)-population(j,:)));
            end
        end
    end
    diversityValue = hammingDistance*diversityConstant;
end
