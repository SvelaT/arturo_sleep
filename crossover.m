function child = crossover(parent1,parent2,npoints)
    child = parent1;
    chromossomeSize = size(parent1,2);
    points = randperm(chromossomeSize-1,npoints);
    sections = round(rand(1,npoints+1));
    if all(sections) || all(~sections)
        point = randi(npoints+1);
        sections(point) = ~sections(point);
    end
    numsecs = size(sections,2);
    for i = 1:1:numsecs
        if sections(i)
            if i == 1
                child(1:points(i)) = parent2(1:points(i));
            elseif i == numsecs
                child((points(i-1)+1):chromossomeSize) = parent2((points(i-1)+1):chromossomeSize);
            else
                child((points(i-1)+1):points(i)) = parent2((points(i-1)+1):points(i));
            end
        end
    end
end
