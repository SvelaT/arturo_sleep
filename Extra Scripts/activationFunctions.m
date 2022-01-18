a = (-2000:2000)/1000;
figura = figure;
subplot(2,2,1);
fplot(@(x) sigmoid(x));
title('Sigmoid');
xlabel('input value');
ylabel('output value');
xticks([-3 -2 -1 0 1 2 3]);
yticks([-1.2 -0.8 -0.4 0 0.4 0.8 1.2]);
axis([-3 3 -1.2 1.2])
grid on

subplot(2,2,2);
fplot(@(x) tanh(x));
title('Hyperbolic Tangent');
xlabel('input value');
ylabel('output value');
xticks([-3 -2 -1 0 1 2 3]);
yticks([-1.2 -0.8 -0.4 0 0.4 0.8 1.2]);

axis([-3 3 -1.2 1.2])
grid on

subplot(2,2,3);
fplot(@(x) relu(x));
title('Relu');
xlabel('input value');
ylabel('output value');
xticks([-3 -2 -1 0 1 2 3]);
yticks([-1.2 -0.8 -0.4 0 0.4 0.8 1.2]);
axis([-3 3 -1.2 1.2])
grid on

subplot(2,2,4);
fplot(@(x) x);
title('Identity');
xlabel('input value');
ylabel('output value');
xticks([-3 -2 -1 0 1 2 3]);
yticks([-1.2 -0.8 -0.4 0 0.4 0.8 1.2]);
axis([-3 3 -1.2 1.2])
grid on

saveas(figura,'ActivationFunctions.png');


function sigmoid = sigmoid(x)
    sigmoid = 1/(1+exp(-x));
end

function relu = relu(x)
    if x >= 0
        relu = x;
    else
        relu = 0;
    end
end