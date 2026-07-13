# Funções de Barreira de Controle (CBF) para Garantia Estrita de Segurança

Esta página detalha a formulação matemática utilizada para impor restrições de **segurança absoluta** no sistema de Controle de Cruzeiro Adaptativo (ACC), impedindo colisões traseiras contra o veículo líder através do framework de conjuntos invariantes.

---

## 1. O Conceito de Invariância de Conjunto
A segurança no tráfego é definida pela manutenção de uma distância física segura em relação ao veículo à frente. Matematicamente, modelamos isso definindo um **Conjunto Seguro ($\mathcal{C}$)** no espaço de estados do sistema. Se o estado inicial do veículo começa dentro deste conjunto, o controlador deve garantir que ele **nunca** saia dele. 

Dizemos que o conjunto $\mathcal{C}$ é *frente-invariante* (*forward invariant*). As **Funções de Barreira de Controle (CBF)** atuam como barreiras matemáticas que impedem o estado de cruzar a fronteira do conjunto seguro.

---

## 2. Definição da Função de Barreira para o ACC
A restrição de segurança adotada baseia-se em uma política de distância bi-dimensional dinâmica, considerando o tempo de reação (*time headway* ou $T_d$) e uma distância estática de segurança:

$$h(x) = x_r - T_d \cdot V_f$$

Onde:
* $x_r$ é a distância relativa real entre os dois veículos ($x_{líder} - x_{seguidor}$).
* $V_f$ é a velocidade atual do veículo seguidor.
* $T_d$ é o intervalo de tempo seguro desejado (ex: 1.8 segundos).

O Conjunto Seguro $\mathcal{C}$ é matematicamente descrito por:

$$\mathcal{C} = \{ x \in \mathbb{R}^2 : h(x) \ge 0 \}$$

Se $h(x) > 0$, o veículo opera em zona confortável. Se $h(x) = 0$, o veículo atingiu o limite exato da distância de segurança permitida.

---

## 3. Condição de Barreira e Derivadas de Lie
Para garantir que o estado do sistema nunca saia de $\mathcal{C}$, a derivada da função de barreira $\dot{h}(x)$ não pode decrescer de forma irrestrita à medida que se aproxima da fronteira. Aplica-se a condição de barreira generalizada:

$$\dot{h}(x) \ge -\lambda \cdot h(x)$$

Onde $\lambda > 0$ dita o comportamento do filtro de segurança nas bordas do conjunto. Expandindo através das Derivadas de Lie em relação à dinâmica do veículo ($\dot{x} = f(x) + g(x)u$):

$$\dot{h}(x) = L_f h(x) + L_g h(x)u \ge -\lambda \cdot h(x)$$

As equações deduzidas simbolicamente no arquivo `LIE_2026.m` e implementadas no Simulink são:
* $L_f h(x) = V_l - V_f + \frac{F_r \cdot T_d}{m}$
* $L_g h(x) = -T_d$

---

## 4. Restrição de Segurança Inviolável no Otimizador
Diferente da CLF, a restrição da CBF **não possui variáveis de folga**. Ela entra no algoritmo de Programação Quadrática (QP) como uma restrição linear rígida (*hard constraint*):

$$-L_g h(x)u \le L_f h(x) + \lambda \cdot h(x)$$

Isso garante que, independentemente do desejo do motorista de acelerar para atingir $V_d$, se a trajetória projetada indicar que $h(x)$ se aproxima perigosamente de zero, o otimizador anulará a ação da CLF e injetará um sinal de frenagem ($u < 0$) drástico o suficiente para respeitar o limite físico da barreira de segurança.
