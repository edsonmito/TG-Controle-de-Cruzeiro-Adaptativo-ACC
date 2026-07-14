# Demonstração e Adaptação da Teoria de Lyapunov para o ACC

## 1. O Problema de Análise Clássico vs. O Problema de Síntese (CLF)

Na disciplina de Análise de Sistemas Dinâmicos, estuda-se o **Método Direto de Lyapunov** para verificar se um ponto de equilíbrio $x^* = 0$ de um sistema autônomo $\dot{x} = f(x)$ é estável. Para isso, busca-se uma função de energia $V(x)$ tal que:

1. $V(0) = 0$ e $V(x) > 0 \quad \forall x \neq 0$ (Definida Positiva)
2. $\dot{V}(x) = \nabla V(x) \cdot f(x) < 0 \quad \forall x \neq 0$ (Definida Negativa)

No entanto, em engenharia de controle, o sistema possui uma entrada de controle $u$ (sistemas não-autônomos/controlados):

$$\dot{x} = f(x) + g(x)u$$

O objetivo deixa de ser apenas *analisar* a estabilidade natural do sistema e passa a ser **projetar/sintetizar** uma lei de controle $u = k(x)$ que force o sistema a ser estável. É aqui que entra o conceito de **Função de Lyapunov de Controle (CLF)**.

---

## 2. Adaptação Teórica para o Controle de Cruzeiro (Rastreamento)

No nosso problema de ACC, o objetivo é fazer com que a velocidade do veículo hospedeiro ($V_f$) persiga de forma assintótica a velocidade desejada de cruzeiro ($V_d$).

### Passo 1: Definição do Erro e do Ponto de Equilíbrio

Define-se o erro de rastreamento de velocidade como:


$$e(t) = Vf(t) - Vd$$

O ponto de equilíbrio desejado para o erro é $e^* = 0$ (o que implica $V_f = V_d$).

### Passo 2: Escolha da Função Candidata de Lyapunov

Para provar a estabilidade do erro, propõe-se uma função candidata de Lyapunov quadrática baseada na energia do erro:

$$V(e) = e^2 = (V_f - V_d)^2$$

**Demonstração das propriedades de $V(e)$:**

1. **Nulidade no equilíbrio:** $V(0) = (V_d - V_d)^2 = 0$.
2. **Positividade:** Como $V(e)$ é um termo quadrático, $V(e) > 0$ para qualquer $e \neq 0$ ($V_f \neq V_d$).
3. **Radialmente ilimitada:** $V(e) \to \infty$ quando $\Vert{}e\Vert{} \to \infty$.

Portanto, $V(e)$ é uma função candidata válida de Lyapunov globalmente definida positiva.

---

## 3. Dedução da Derivada de Lyapunov ao longo das Trajetórias

Para garantir a convergência assintótica (estabilidade), a derivada temporal $\dot{V}(e)$ deve ser estritamente negativa. Aplicando a regra da cadeia:

$$\dot{V}(e) = \frac{d}{dt} \left[ (V_f - V_d)^2 \right] = 2(V_f - V_d) \cdot \dot{V}_f$$

Substituindo a dinâmica física do veículo seguidor (obtida do espaço de estados $\dot{x} = f(x) + g(x)u$, onde $\dot{V}_f = -\frac{F_r}{m} + u$):

$$\dot{V}(e) = 2(V_f - V_d) \left( -\frac{F_r}{m} + u \right)$$

Ao expandirmos essa equação, podemos isolar os termos que dependem apenas do estado natural do veículo daqueles que são influenciados diretamente pelo nosso sinal de controle $u$. Essa separação é feita de forma elegante através das **Derivadas de Lie** ($L_f V$ e $L_g V$):

$$\dot{V}(e) = \underbrace{-\frac{2(V_f - V_d)F_r}{m}}_{L_f V(x)} + \underbrace{2(V_f - V_d)}_{L_g V(x)} \cdot u$$

Onde:

* $L_f V(x)$ representa a variação "natural" da energia do sistema devido ao arrasto aerodinâmico $F_r$.
* $L_g V(x)$ representa a autoridade ou ganho que o controle $u$ possui para alterar essa energia.

*(Estes são exatamente os termos que o seu arquivo `LIE_2026.m` calcula simbolicamente no MATLAB).*

---

## 4. Imposição de Estabilidade Exponencial (Sintonia do Controlador)

Para garantir que o erro de velocidade decaia exponencialmente a uma taxa conhecida e ajustável $c > 0$, impomos a seguinte restrição de decaimento de energia (Condição de Sontag):

$$\dot{V}(e) \le -c \cdot V(e)$$

Substituindo as Derivadas de Lie deduzidas:

$$L_f V(x) + L_g V(x) \cdot u \le -c \cdot V(x)$$

Esta desigualdade é a **Restrição CLF** do seu projeto. Qualquer sinal de controle $u$ que satisfaça essa inequação garante que o erro de velocidade convergirá exponencialmente para zero.

### O Ajuste de Robustez (Variável de Folga $\delta$)

Como a segurança (CBF) é prioritária sobre o rastreamento de velocidade, adicionamos a variável de folga $\delta \ge 0$ na restrição CLF:

$$L_f V(x) + L_g V(x) \cdot u \le -c \cdot V(x) + \delta$$

Se o veículo precisar frear bruscamente para não bater (ação imposta pela CBF), o otimizador QP aumentará temporariamente o valor de $\delta$, permitindo que a restrição de Lyapunov seja violada ($\dot{V}(e) > 0$) pelo tempo necessário para garantir a sobrevivência física do veículo.

---

### Como apresentar isso no seu GitHub e trabalhos acadêmicos:

Essa estrutura teórica conecta perfeitamente os teoremas matemáticos abstratos de sala de aula com a engenharia de controle moderna baseada em otimização em tempo real (QP). No seu repositório, você pode colocar esse texto em uma seção dedicada no arquivo `docs/CLF.md`. Isso demonstrará de forma inequívoca o embasamento científico por trás das linhas de código do seu Simulink!
