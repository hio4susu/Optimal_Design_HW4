clear all;close all; clc;
x0 = 1.0*ones(1,8);
lb = 0.1*ones(1,8);
ub = 5.0*ones(1,8);
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'active-set');
[x, fval, exitflag,output,lambda] = fmincon('get_obj', x0, [], [], [], [], lb, ub, 'get_cns', options);

muX = x;
stdX = 0.0052;
covX = stdX^2*eye(8);
muE=1e07;
stdE = 1e06;
covE=stdE^2;
N=1e06;
times=1;
for j = 1:times
    RandX = mvnrnd(muX, covX,N);
    RandE = mvnrnd(muE, covE,N);
    Y = zeros(N, 27);
    for i = 1:N
        [c, ceq] = get_cns_2(RandX(i,:), RandE(i));
        [Y(i,:)] = c;
    end
    
    Nf=sum(Y>0); 
    pf=Nf/N; 
    sprintf('Failure probability using MCS with %d samples is %0.5g percent ', N, pf*100)
end
figure
for i = 1:27
    plot(pf(:,i), 'x')
    hold on;
end
xlabel('times'); 
ylabel('Failure probability');
axis([0 times+1 -0.1 0.8]);
pf








