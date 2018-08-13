t = (0:0.01:35);


y = 0.588 * exp(0.3993*t)./(9.803+exp(0.4051*t));

plot(t, y)
hold on

plot(A_t, A)

