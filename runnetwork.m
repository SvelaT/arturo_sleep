function [tr,outputs,performance,errors,network] = runnetwork(x,t,trainSetIndexes,valSetIndexes,testSetIndexes,hidden_layer_neurons,num_hidden_layers,train_function,cost_function,activation_function,regularization_parameter,max_epochs,max_val_checks,selected_inputs,error_weights,use_gpu)
x = x(selected_inputs,:);

layers_nums = hidden_layer_neurons*ones(1,num_hidden_layers);
net = patternnet(layers_nums);%defining the neural network with its number of hidden layers and neurons per layer

net.inputs{1}.processFcns={};
net.outputs{2}.processFcns={};

% Defines the training algorithm to be used
net.trainFcn=train_function;%defining the training algorithm
net.performFcn=cost_function;%defining the performance function

%training parameters
net.trainParam.min_grad= 1.0000e-07;%minimum gradient value
net.trainParam.goal = 0;%optimization goal
net.trainParam.mu=1.0000e-003;
net.trainParam.mu_inc=10;
net.trainParam.mu_dec=0.1;
net.performParam.regularization = regularization_parameter;
net.trainParam.epochs = max_epochs;%maximum number of epochs
net.trainParam.max_fail = max_val_checks;%maximum number of failed validation checks
net.trainParam.time = 8640;

%dataset division
net.divideFcn='divideind';%dividing the samples based on indexes rather than random or blocks division
net.divideParam.trainInd=sort(trainSetIndexes);
net.divideParam.valInd=sort(valSetIndexes);
net.divideParam.testInd=sort(testSetIndexes);

net = configure(net,x,t);
for i = 1:1:num_hidden_layers
    net.layers{i}.transferFcn = activation_function;
end

% Create an array of weights with values that ranges from [-2.4/I,
% 2.4/I] where I is the number of Inputs
netstructure = [size(x,1),layers_nums,size(t,1)];
wbvector = initWeightsBiases(netstructure,'sigmoid','sigmoid','xaviernormal','xaviernormal');

% Set all network weight and bias values with single vector weight
net = setwb(net,wbvector);

% Saves the initial weights of the network
temp_initial_weights = getwb(net);

if use_gpu
    xg = gpuArray(x);
    tg = gpuArray(t);
    error_weights = gpuArray(error_weights);
end

% Train the network
if isempty(error_weights)
    if use_gpu
        [net, tr] = train(net,xg,tg,'useGPU','yes');%training the neural network
    else
        [net, tr] = train(net,x,t);%training the neural network
    end
else
    if use_gpu
        [net, tr] = train(net,xg,tg,gpuArray([]),gpuArray([]),error_weights','useGPU','yes');%training the neural network using error weights
    else
        [net, tr] = train(net,x,t,[],[],error_weights');%training the neural network using error weights
    end
end

% Simulate the network
if use_gpu
    outputsg = sim(net,xg,'useGPU','yes');
    outputs = gpu2nndata(outputsg)';
else
    outputs = sim(net,x);
end

errors = gsubtract(t,outputs);
if isempty(error_weights)
    performance = perform(net,t,outputs);
else
    performance = perform(net,t,outputs,error_weights');
end

network = net;
end

function wbvector = initWeightsBiases(netstructure,hidden_winit_func,hidden_binit_func,output_winit_func,output_binit_func)
    wbvector = [];
    for i = 1:1:(size(netstructure,2)-1)
        if i == (size(netstructure,2)-1)
            biases = initializeBiases(netstructure(i),netstructure(i+1),output_binit_func);
            weights = initializeWeights(netstructure(i),netstructure(i+1),output_winit_func);
            wbvector = [wbvector;biases;weights];
        else
            biases = initializeBiases(netstructure(i),netstructure(i+1),hidden_binit_func);
            weights = initializeWeights(netstructure(i),netstructure(i+1),hidden_winit_func);
            wbvector = [wbvector;biases;weights];
        end
    end
end

function initWeights = initializeWeights(nPrevLayer,nCurrentLayer,initFunc)
    if strcmp(initFunc,'henormal')
        initWeights = randn(nPrevLayer*nCurrentLayer,1);
        initWeights = initWeights*sqrt(2/nPrevLayer);
    elseif strcmp(initFunc,'xaviernormal')
        initWeights = randn(nPrevLayer*nCurrentLayer,1);
        initWeights = initWeights*sqrt(1/nPrevLayer);
    elseif strcmp(initFunc,'xavier2normal')
        initWeights = randn(nPrevLayer*nCurrentLayer,1);
        initWeights = initWeights*sqrt(2/(nPrevLayer+nCurrentLayer));
    elseif strcmp(initFunc,'24uniform')
        initWeights = 2*rand(nPrevLayer*nCurrentLayer,1)-1;
        initWeights = initWeights*(2.4/nPrevLayer);
    elseif strcmp(initFunc,'xavieruniform')
        initWeights = 2*rand(nPrevLayer*nCurrentLayer,1)-1;
        initWeights = initWeights*sqrt(1/nPrevLayer);
    elseif strcmp(initFunc,'sigmoid')
        initWeights = 2*rand(nPrevLayer*nCurrentLayer,1)-1;
        initWeights = initWeights*(3.6/sqrt(nPrevLayer));
    end
end

function initBiases = initializeBiases(nPrevLayer,nCurrentLayer,initFunc)
    if strcmp(initFunc,'henormal')
        initBiases = randn(nCurrentLayer,1);
        initBiases = initBiases*sqrt(2/nPrevLayer);
    elseif strcmp(initFunc,'xaviernormal')
        initBiases = randn(nCurrentLayer,1);
        initBiases = initBiases*sqrt(1/nPrevLayer);
    elseif strcmp(initFunc,'xavier2normal')
        initBiases = randn(nCurrentLayer,1);
        initBiases = initBiases*sqrt(2/(nPrevLayer+nCurrentLayer));
    elseif strcmp(initFunc,'24uniform')
        initBiases = 2*rand(nCurrentLayer,1)-1;
        initBiases = initBiases*(2.4/nPrevLayer);
    elseif strcmp(initFunc,'xavieruniform')
        initBiases = 2*rand(nCurrentLayer,1)-1;
        initBiases = initBiases*sqrt(1/nPrevLayer);
    elseif strcmp(initFunc,'zeros')
        initBiases = zeros(nCurrentLayer,1);
    elseif strcmp(initFunc,'sigmoid')
        initBiases = 2*rand(nPrevLayer*nCurrentLayer,1)-1;
        initBiases = initBiases*(3.6/sqrt(nPrevLayer));
    end
end


