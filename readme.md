
# Controle de Cruzeiro Adaptativo (ACC) Baseado em Otimização de Sistemas Críticos de Segurança via CLF-CBF-QP

O presente repositório documenta o desenvolvimento de um Trabalho de Graduação apresentado ao curso de Engenharia de Informação da Universidade Federal do ABC (UFABC), referente ao quadrimestre 2026.2, sob orientação do Prof. Dr. Caio Igor Gonçalves Chinelato.

O trabalho tem por objetivo investigar o problema do Controle de Cruzeiro Adaptativo (ACC) sob a perspectiva de sistemas de controle críticos de segurança, propondo a unificação de dois objetivos concorrentes: a manutenção de uma velocidade de cruzeiro desejada e a garantia de uma distância segura em relação ao veículo precedente. Para tanto, são investigadas e comparadas diferentes arquiteturas de controle fundamentadas em Funções de Lyapunov de Controle (CLF), Funções de Barreira de Controle (CBF) e Programação Quadrática (QP), a saber:
<ul>
<li>a formulação unificada CLF-CBF-QP, na qual desempenho e segurança são mediados em tempo real por meio de um único problema de otimização;
<li>a arquitetura de Filtro de Segurança (Active Set Invariance Filter — ASIF), na qual um controlador nominal de desempenho é submetido a uma camada de segurança independente;
<li>uma arquitetura de dois níveis, composta por um nível superior de decisão e um nível inferior de atuação via controle PID, com vistas a aproximar o modelo simulado de um sistema veicular real.
</ul>
A totalidade das simulações apresentadas foi implementada e validada em ambiente MATLAB/Simulink, com documentação detalhada da modelagem matemática, dos parâmetros de projeto adotados e dos resultados obtidos ao longo do desenvolvimento do trabalho.


## Visão Geral do Projeto

O objetivo do sistema ACC é regular a velocidade de um veículo seguidor (*host*) para que ele atinja uma velocidade de cruzeiro desejada ($V_d$) quando a pista estiver livre. Caso haja um veículo líder (*leader*) mais lento à frente, o controlador prioriza de forma absoluta a distância de segurança bi-dimensional baseada em tempo (*time headway*).



### Diferenciais Técnicos:
* **Segurança Pró-ativa (CBF):** Diferente de controladores PID ou preditivos convencionais (MPC) que tratam segurança como penalidade ou restrição pesada, as CBFs garantem matematicamente a invariância do conjunto seguro, agindo como um "filtro de segurança" inviolável antes que o comando chegue aos atuadores.
* **Otimização em Tempo Real (QP):** O cálculo da aceleração ótima ($u$) ocorre a cada passo de simulação, resolvendo um problema de Programação Quadrática analiticamente via algoritmo de *Hildreth* (`QPhild.m`), ideal para posterior embarque em hardware automotivo devido ao baixo custo computacional.
* **Modelo Dinâmico Realista:** Considera a física do veículo com forças de arrasto aerodinâmico não-lineares ($F_r = f_0 + f_1V_f + f_2V_f^2$).


##  Formulação Matemática

O sistema é modelado no espaço de estados não-linear $\dot{x} = f(x) + g(x)u$, onde as derivadas de direção (**Derivadas de Lie**) são calculadas para mapear o impacto do controle sobre a segurança e estabilidade.

### 1. Desempenho (CLF)
Para rastrear a velocidade desejada $V_d$, define-se a função candidata de Lyapunov:
$$V(x) = (V_f - V_d)^2$$
O otimizador busca decrescer $V(x)$ obedecendo à restrição de estabilidade $L_f V(x) + L_g V(x)u \le -\epsilon V(x) + \delta$, onde $\delta$ é uma variável de folga (*slack variable*) para garantir viabilidade se a segurança exigir o sacrifício do desempenho.

* <a href="modelagem/clf.md">Desempenho via CLF (Control Lyapunov Functions)</a>: Garante que o veículo persiga e estabilize na velocidade de cruzeiro desejada de forma assintótica.


### 2. Segurança Estrita (CBF)
A margem de segurança é definida pela função de barreira baseada no tempo de headway ($T_d$):
$$h(x) = x_r - T_d \cdot Vf$$
Para garantir que o veículo nunca colida, o estado deve permanecer no conjunto seguro ($h(x) \ge 0$). Isso é assegurado forçando o controle a respeitar a condição de frente de avanço:
$$L_f h(x) + L_g h(x)u \ge -\gamma h(x)$$

Onde $L_f$ e $L_g$ representam as Derivadas de Lie calculadas dinamicamente no sistema.

* <a href="modelagem/cbf.md">Segurança via CBF (Control Barrier Functions)</a>: Garante a invariância do conjunto seguro, agindo como um filtro de segurança inviolável para evitar colisões traseiras.

### 3. Programação Quadrática (QP)
É a ferramenta que permite unificar dois objetivos que, à primeira vista, parecem conflitantes: **perseguir uma velocidade de cruzeiro** e **nunca colidir com o veículo à frente**.
O controlador resolve a cada passo:

$$u^*(x) = \arg\min_{u} \; \tfrac{1}{2}u^{\top}Hu + F^{\top}u \quad \text{sujeito a restrições afins em } u$$

Encontrando, entre todas as ações de controle possíveis, a mais barata que ainda respeita a segurança. Desempenho vira uma restrição *suave* (pode ceder um pouco); segurança vira uma restrição *rígida* (nunca cede). É essa mediação contínua, resolvida via QP, que torna a arquitetura **CLF-CBF-QP** — e suas variações exploradas neste repositório — capaz de garantir formalmente que a distância segura jamais é violada, mesmo enquanto tenta acelerar.

* <a href="modelagem/qp.md">Modelagem QP</a>

## Simulação Matlab
Este documento descreve a evolução completa da simulação do ACC — desde a primeira tentativa (arquitetura ASIF com conflito CBF×conforto) até a arquitetura de dois níveis final (Chinelato et al., 2023) — incluindo todo o processo de depuração numérica, as descobertas qualitativas sobre o comportamento das diferentes arquiteturas, e o dicionário completo de parâmetros.

* <a href="simulacao/simulacao.md">Simulação Matlab</a>

## Estrutura do Repositório

* `INIT_ACC_2026.m`: Script principal. Configura as condições iniciais ($V_{f0}$, $D_0$), executa a simulação e plota as curvas de desempenho.
* `ACC_TESTE_2026.slx`: Modelo em Simulink contendo a malha fechada do sistema automotivo.
* `FUNÇÃO_CLF_CBF_QP.txt` / `fcn`: Bloco de função do MATLAB dentro do Simulink que monta as matrizes do problema de otimização ($A \cdot u \le b$) a cada instante $t$.
* `LIE_2026.m`: Script simbólico utilizado para deduzir as equações algébricas das Derivadas de Lie do modelo.
* `QPhild.m`: Solver analítico de Programação Quadrática baseado no algoritmo de Hildreth, dispensando o uso do `quadprog` nativo do MATLAB para maior eficiência.

  
## Referências

- AMES, A. D.; GRIZZLE, J. W.; TABUADA, P. *Control barrier function based quadratic programs with application to adaptive cruise control*. IEEE CDC, 2014.
- AMES, A. D.; XU, X.; GRIZZLE, J. W.; TABUADA, P. *Control barrier function based quadratic programs for safety critical systems*. IEEE TAC, 62(8), 2017.
- AMES, A. D.; COOGAN, S.; EGERSTEDT, M.; NOTOMISTA, G.; SREENATH, K.; TABUADA, P. *Control barrier functions: Theory and applications*. European Control Conference (ECC), 2019.
- CHINELATO, C. I. G.; ANGÉLICO, B. A.; JUSTO, J. F.; LAGANÁ, A. A. M. *Design of adaptive cruise control with control barrier function and model-free control*. Journal of Control, Automation and Electrical Systems, 34, 2023. — fonte da arquitetura de dois níveis.
- GURRIET, T.; SINGLETARY, A.; REHER, J.; CIARLETTA, L.; FERON, E.; AMES, A. D. *Towards a framework for realizable safety critical control through active set invariance*. ICCPS, 2018. — fonte da arquitetura ASIF.
- MONTEIRO, L. H. A. Sistemas dinâmicos. SP-Brasil: Editora Livraria da Física, 2006.
- OGATA, K. Engenharia de Controle Moderno. Brasil: Pearson & Prentice Hall, 2008.


