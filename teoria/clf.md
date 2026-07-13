# Funções de Lyapunov de Controle (CLF) para Rastreamento de Velocidade

Esta página detalha a formulação matemática utilizada para garantir os objetivos de **desempenho** e **estabilidade** do sistema de Controle de Cruzeiro Adaptativo (ACC), especificamente o rastreamento da velocidade de cruzeiro desejada ($V_d$).

---

## 1. O Objetivo de Desempenho
Quando a pista à frente está livre de obstáculos ou o veículo líder está distante, o veículo seguidor (*host*) deve se comportar como um controlador de cruzeiro convencional, regulando sua velocidade atual ($V_f$) para convergir assintoticamente para uma velocidade desejada ($V_d$) definida pelo condutor.

Para quantificar o erro de rastreamento e projetar uma malha de controle estável, utiliza-se o conceito de **Funções de Lyapunov de Controle (CLF)**, fundamentado no teorema de estabilidade de Lyapunov para sistemas não-lineares.

---

## 2. Definição da Função Candidata de Lyapunov
Define-se a função de custo baseada no erro quadrático da velocidade do veículo seguidor:

$$V(x) = (V_f - V_d)^2$$

Para que o sistema seja estável e a velocidade real convirja para a desejada, a função $V(x)$ deve ser estritamente positiva para todo $V_f \neq V_d$, nula quando $V_f = V_d$, e sua derivada temporal $\dot{V}(x)$ deve ser estritamente decrescente ao longo das trajetórias do sistema.

---

## 3. Dinâmica do Sistema e Derivadas de Lie
Considerando a dinâmica do veículo expressa no espaço de estados não-linear $\dot{x} = f(x) + g(x)u$, a derivada temporal de $V(x)$ é obtida pela regra da cadeia através das **Derivadas de Lie**:

$$\dot{V}(x) = \frac{\partial V}{\partial x} \dot{x} = \frac{\partial V}{\partial x} (f(x) + g(x)u)$$

$$\dot{V}(x) = L_f V(x) + L_g V(x)u$$

Onde as componentes algébricas calculadas analiticamente no script `LIE_2026.m` resultam em:
* $L_f V(x) = \frac{2 \cdot F_r \cdot (V_d - V_f)}{m}$
* $L_g V(x) = 2 \cdot V_f - 2 \cdot V_d$

*(Nota: $F_r$ é a força de arrasto aerodinâmico não-linear $f_0 + f_1V_f + f_2V_f^2$ e $m$ é a massa do veículo).*

---

## 4. Restrição Linear de Estabilidade (CLF)
Para impor uma taxa de convergência exponencial ao erro de velocidade, define-se a restrição que o sinal de controle ($u$) deve obedecer:

$$L_f V(x) + L_g V(x)u \le -c \cdot V(x)$$

Onde $c > 0$ é um parâmetro de ganho de sintonia que determina a rapidez com que o carro atinge a velocidade alvo.

### Variável de Folga (Slack Variable)
Como o objetivo primordial do sistema é a **segurança** (evitar colisões), pode haver cenários onde seja matematicamente impossível manter o carro acelerando em direção a $V_d$ sem violar a distância mínima do veículo à frente. 

Para evitar o travamento do otimizador por incompatibilidade de restrições, relaxa-se a condição da CLF introduzindo uma variável de folga $\delta \ge 0$:

$$L_f V(x) + L_g V(x)u \le -c \cdot V(x) + \delta$$

No problema de Programação Quadrática (QP), penaliza-se severamente valores altos de $\delta$ na função de custo, garantindo que o desempenho só seja sacrificado se a segurança do veículo estiver em risco iminente.
