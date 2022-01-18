d = ones(1,200);
for i = 2:1:200
    d(i) = -d(i-1);
end

for i = 140:1:150
    d(i) = 1.5*d(i);
end
for i = 150:1:160
    d(i) = 2*d(i);
end
for i = 160:1:170
    d(i) = 1.5*d(i);
end

for i = 80:1:90
    d(i) = 0.75*d(i);
end
for i = 90:1:100
    d(i) = 0.5*d(i);
end
for i = 100:1:110
    d(i) = 0.75*d(i);
end


a = sin((1:200)/15)+d/5;

f1 = figure;
plot(a);
xlabel('Time');
ylabel('Amplitude');
title('Original Signal');
saveas(f1,'originalsignal.png');
disp('orig');
for i = 1:1:size(a,2)
    disp(['(' num2str(i) ',' num2str(a(i)) ')']);
end
[b,c] = dwt(a,'db4');

f2 = figure;
plot(b);
xlabel('Time');
ylabel('Amplitude');
title('Approximation Coefficients');
saveas(f2,'approxcoef.png');
disp('approx');
for i = 1:1:size(b,2)
    disp(['(' num2str(i) ',' num2str(b(i)) ')']);
end

f3 = figure;
plot(c);
xlabel('Time');
ylabel('Amplitude');
title('Details Coefficients');
saveas(f3,'detailscoef.png');
disp('deta');
for i = 1:1:size(c,2)
    disp(['(' num2str(i) ',' num2str(c(i)) ')']);
end
