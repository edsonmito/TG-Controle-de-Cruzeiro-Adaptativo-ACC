# Teoria das Funções de Lyapunov

## 1. O que é uma Função de Lyapunov? (Estrutura Genérica)

Analogamente ao conceito físico de **energia**, uma Função de Lyapunov $V(x)$ é uma construção matemática escalar utilizada para determinar a estabilidade de um sistema dinâmico sem a necessidade de resolver explicitamente suas equações diferenciais (que muitas vezes são não-lineares e impossíveis de resolver analiticamente). Em outras palavras, Lyapunov generalizou a ideia em que, em vez de "energia física", usamos uma função matemática $V(x)$ que se comporta como uma energia generalizada.

Assim, se conseguirmos mostrar que essa função é sempre positiva (exceto no ponto de equilíbrio, onde é zero), e diminui continuamente ao longo das trajetórias do sistema, então podemos concluir que o sistema é estável, sem precisar resolver a equação diferencial.

## 2. Definição formal:

Para um sistema dinâmico autônomo descrito por:

$$\dot{x} = f(x), \quad f(0) = 0$$

onde $x = 0$ é um ponto de equilíbrio, uma função escalar continuasmente diferenciável $V: \mathbb{R}^n \to \mathbb{R}$ é considerada uma **Função Candidata de Lyapunov** se atender a duas condições geométricas fundamentais na vizinhança do ponto de equilíbrio:

1. **Definida Positiva:** A "energia" deve ser zero no equilíbrio e estritamente positiva em qualquer outro lugar.

$$V(0) = 0 \quad \text{e} \quad V(x) > 0 \quad \forall x \neq 0$$


2. **Derivada Temporal Negativa (Semidefinida ou Definida):** A taxa de variação da "energia" ao longo das trajetórias do sistema deve ser decrescente (dissipação de energia).

$$\dot{V}(x) = \frac{\partial V}{\partial x}\dot{x} = \frac{\partial V}{\partial x}f(x) \le 0$$



* Se $\dot{V}(x) \le 0$ (Semidefinida Negativa): O sistema é **Estável** no sentido de Lyapunov (as trajetórias não divergem, mas podem orbitar infinitamente).
* Se $\dot{V}(x) < 0$ (Definida Negativa): O sistema é **Assintoticamente Estável** (a energia decai até zero, forçando o estado $x(t)$ a retornar exatamente para o ponto de equilíbrio $0$).
* Se $\dot{V}(x) > 0$: O sistema é Instável.

## 3. Por que é "direto"?

Porque não exige integrar as equações de movimento — daí o nome "método direto", em oposição ao "primeiro método" (ou indireto), que envolve linearizar o sistema e analisar autovalores.

### O desafio prático

O maior problema é que **não há uma receita geral** para encontrar V(x). É preciso "adivinhar" ou construir uma função candidata (muitas vezes baseada em energia física, formas quadráticas, etc.) e depois verificar se ela satisfaz as condições. Se uma tentativa falhar, isso não prova instabilidade — só significa que essa função não serviu.



## 4. Exemplo simples

Sistema: $\dot{x} = -x^3$

Candidata: $V(x) = x^2$ (positiva definida, V(0)=0)

Derivada:
$$\dot{V}(x) = 2x \cdot \dot{x} = 2x \cdot (-x^3) = -2x^4$$

Como $-2x^4 < 0$ para todo x ≠ 0, concluímos que o equilíbrio x = 0 é **assintoticamente estável** — e chegámos a essa conclusão sem resolver a equação diferencial!


## 5. Implementações e Evoluções na Teoria de Controle

Ao longo das décadas, o conceito original de Lyapunov (que servia apenas para *analisar* se um sistema já existente era estável) foi estendido para o *projeto e síntese* de controladores ativos. Algumas das implementações teóricas mais importantes e utilizadas na engenharia de controle são:

### A. Control Lyapunov Functions (CLF)

Proposta por Zartsin e popularizada por Eduardo Sontag na década de 1980, a CLF estende a teoria para sistemas com entradas de controle:


$$\dot{x} = f(x) + g(x)u$$


A pergunta passa a ser: *Existe uma ação de controle $u$ capaz de tornar a derivada temporal de $V(x)$ negativa?*
Uma função $V(x)$ é uma CLF se, para todo $x \neq 0$:


$\inf_{u} \left\{ L_f V(x) + L_g V(x)u \right\} < 0$


Esta formulação matemática permite projetar leis de controle não-lineares universais (como a famosa Fórmula de Sontag) e é a base da otimização em tempo real via Programação Quadrática (QP) utilizada no seu projeto de ACC.

### B. Barrier Lyapunov Functions (BLF)

Em muitos problemas reais de engenharia, os estados do sistema não podem exceder certos limites físicos por razões de segurança ou limitações de hardware (ex: limites de curso de um pistão ou ângulos máximos de junta de um braço robótico).
As **Funções de Lyapunov de Barreira (BLF)** são construídas de modo que seu valor cresça até o infinito quando o estado se aproxima de um limite predefinido.

* *Estrutura comum:* $V(x) = \frac{1}{2}\ln\left(\frac{k_b^2}{k_b^2 - x^2}\right)$, onde $k_b$ é o limite que o estado $x$ nunca deve violar.
* Se a energia de Lyapunov $V(x)$ for mantida limitada ao longo do tempo, garante-se matematicamente que o estado nunca atingirá a fronteira $k_b$.

### C. Teorema de Krasovskii e Método de Variáveis de Gradiente

Para sistemas não-lineares genéricos, encontrar uma função de Lyapunov adequada ($V(x)$) é uma tarefa difícil, pois não há um método sistemático único.

* O **Método de Krasovskii** propõe uma estrutura de Lyapunov baseada diretamente na matriz Jacobiana do sistema: $V(x) = f(x)^T P f(x)$.
* O **Método de Variáveis de Gradiente** assume um gradiente para $V(x)$ e utiliza condições de integrabilidade para reconstruir a função de energia, facilitando a análise de sistemas físicos complexos.

### D. Sistemas Lineares e Desigualdades Matriciais Lineares (LMIs)

Para sistemas lineares $\dot{x} = Ax$, a busca por uma função de Lyapunov se simplifica para uma forma quadrática genérica:


$$V(x) = x^T P x$$


Onde $P$ é uma matriz simétrica definida positiva ($P > 0$). A condição de estabilidade $\dot{V}(x) < 0$ se traduz na famosa **Equação de Lyapunov**:


$$A^T P + P A < 0$$


A resolução desse problema para sistemas lineares com realimentação de estados deu origem ao uso massivo de **LMIs (Linear Matrix Inequalities)**, permitindo que computadores encontrem controladores robustos otimizados em segundos através de algoritmos de otimização convexa.

---

## Como isso se conecta ao seu projeto (CLF-CBF-QP)?

No seu projeto de ACC, a **CLF** é implementada sob a forma quadrática clássica do erro de velocidade:


$$V(x) = (V_f - V_d)^2$$


E a teoria de Lyapunov garante que, ao resolver a Programação Quadrática restringindo o controle para que satisfaça $L_f V(x) + L_g V(x)u \le -c \cdot V(x) + \delta$, a velocidade do veículo seguidor ($V_f$) convergirá de forma estável e exponencial para a velocidade desejada ($V_d$), aceitando desvios temporários ($\delta > 0$) apenas para priorizar a barreira de segurança física (CBF).
