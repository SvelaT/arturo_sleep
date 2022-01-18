function weights = classweights(t)
    weights = zeros(1,size(t,1));%error weights to be used to balance the neural network weight update process
    
    for i = 1:1:size(t,1)
        weights(i) = ((1/sum(t(i,:)))*size(t,2))/size(t,1);
    end
end

