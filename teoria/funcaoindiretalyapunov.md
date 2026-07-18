# Função Indireta de Lyapunov

## 1. O que é uma Função de Lyapunov? (Estrutura Genérica)

Analogamente ao conceito físico de **energia**, uma Função de Lyapunov $V(x)$ é uma construção matemática escalar utilizada para determinar a estabilidade de um sistema dinâmico sem a necessidade de resolver explicitamente suas equações diferenciais (que muitas vezes são não-lineares e impossíveis de resolver analiticamente). Em outras palavras, Lyapunov generalizou a ideia em que, em vez de "energia física", usamos uma função matemática $V(x)$ que se comporta como uma energia generalizada.

Assim, se conseguirmos mostrar que essa função é sempre positiva (exceto no ponto de equilíbrio, onde é zero), e diminui continuamente ao longo das trajetórias do sistema, então podemos concluir que o sistema é estável, sem precisar resolver a equação diferencial.

## 2. Definição formal (Teorema de Lyapunov para Linearização):

Claro! Vamos à definição formal do **Método Indireto de Lyapunov (Primeiro Método)**. 

Entender isso é ótimo para o seu TCC porque você poderá justificar **por que você NÃO o usou** e **por que o Método Direto (que você está usando) é mais adequado** para o ACC com restrições de segurança.

---

### 1. A Definição Formal (Teorema de Lyapunov para Linearização)

Considere um sistema não-linear autônomo na forma:

\[\dot{x} = f(x)\]

onde \( x = 0 \) é um ponto de equilíbrio (ou seja, \( f(0) = 0 \)) e \( f \) é continuamente diferenciável.

O **Método Indireto** consiste nos seguintes passos:

1. **Linearizar o sistema** em torno do ponto de equilíbrio \( x = 0 \) usando a série de Taylor (desprezando termos de ordem superior):
   \[
   \dot{x} \approx A \cdot x
   \]
   onde \( A \) é a **matriz Jacobiana** avaliada no ponto de equilíbrio:
   \[
   A = \left. \frac{\partial f}{\partial x} \right|_{x = 0}
   \]

2. **Analisar os autovalores** (\(\lambda_i\)) da matriz \( A \).

3. **Teorema (Lyapunov - Primeiro Método)**:
   - Se **todos** os autovalores de \( A \) têm **parte real estritamente negativa** (\(\text{Re}(\lambda_i) < 0\)), então o ponto de equilíbrio \( x = 0 \) do **sistema não-linear original** é **assintoticamente estável**.
   - Se **pelo menos um** autovalor de \( A \) tem **parte real estritamente positiva** (\(\text{Re}(\lambda_i) > 0\)), então o ponto de equilíbrio \( x = 0 \) do sistema não-linear original é **instável**.
   - Se os autovalores têm parte real **zero** (ou seja, estão sobre o eixo imaginário), o método **é inconclusivo**. Você precisa olhar para os termos de ordem superior (não-linearidades) para decidir a estabilidade.

---

### 2. Por que ele é chamado de "Indireto"?

Porque você **não** precisa encontrar uma função de Lyapunov \( V(x) \) explicitamente. Em vez disso, você estuda a **dinâmica linearizada** (que é mais fácil de analisar) e, a partir dela, "infere" indiretamente o comportamento do sistema não-linear *nas proximidades* do equilíbrio.

---

### 3. Como seria aplicar isso no seu ACC (se você usasse o Indireto)?

Vamos fazer o exercício teórico para o seu veículo:

- Seu estado é \( x = V_f \).
- Ponto de equilíbrio (referência) é \( x^* = V_d \) (velocidade desejada).
- Definindo o erro \( e = V_f - V_d \), a dinâmica do erro é:
  \[
  \dot{e} = -\frac{F_r(V_f)}{m} + \frac{u}{m}
  \]
  (como \( V_d \) é constante, \( \dot{e} = \dot{V}_f \)).

- A resistência aerodinâmica é algo como \( F_r(V_f) = f_0 + f_1 V_f + f_2 V_f^2 \).

- Para linearizar, você aplicaria a série de Taylor em torno de \( e = 0 \) (ou seja, \( V_f = V_d \)):
  \[
  F_r(V_f) \approx F_r(V_d) + \left. \frac{dF_r}{dV_f} \right|_{V_f = V_d} \cdot (V_f - V_d)
  \]

- Substituindo e rearranjando, você obteria um sistema linearizado da forma:
  \[
  \dot{e} = a \cdot e + b \cdot u
  \]
  onde \( a \) e \( b \) são constantes (que dependem de \( V_d \), massa, etc.).

- Projetando um controlador \( u = -K e \), você teria \( \dot{e} = (a - bK)e \). Para ser estável, você precisa que \( a - bK < 0 \). Ou seja, você colocaria o polo (autovalor) no semiplano esquerdo.

---

### 4. A Grande Limitação (Por que você fez bem em não usá-lo)

O Método Indireto garante estabilidade **APENAS LOCALMENTE**. 

- Se o carro estiver a \( 10 m/s \) e a referência for \( 30 m/s \), o erro \( e \) é grande. A linearização feita em torno de \( 30 m/s \) **não é válida** para \( 10 m/s \). O controlador projetado pelo Método Indireto poderia até funcionar na prática, mas você **não teria como provar matematicamente** que ele vai convergir.

- **Pior**: Quando a CBF (segurança) atuar e forçar uma frenagem brusca, o sistema pode sair completamente da região onde a linearização é válida. A prova de estabilidade feita pelo Método Indireto simplesmente "quebra" (não se aplica mais).

---

### 5. Comparação Direta no seu TCC

| Característica | Método Indireto | Método Direto (seu QP) |
| :--- | :--- | :--- |
| **Base** | Linearização do sistema. | Função escalar positiva \( V(x) \). |
| **Garantia** | **Local** (apenas perto do equilíbrio). | **Global** (válida para todo o espaço de estados). |
| **Manuseio de Não-linearidades** | Precisa cortar/ignorar (ex.: arrasto \( V_f^2 \)). | Lida diretamente com a não-linearidade (usa \( L_fV \) exata). |
| **Manuseio de Restrições (CBF)** | Não lida bem. A segurança pode quebrar a linearização. | Lida perfeitamente via QP. Segurança é priorizada, e a CLF se recupera depois. |
| **Esforço Computacional** | Muito baixo (multiplicação de ganhos). | Médio (resolve QP a cada iteração, mas com Hildreth é rápido). |

---

### Conclusão para escrever no seu TCC

Você pode colocar algo como:

> "O Método Indireto de Lyapunov, embora amplamente utilizado em sistemas lineares e na sintonia de controladores clássicos, apresenta uma limitação fundamental para este trabalho: sua validade é estritamente local. Dado que o veículo pode operar em uma ampla faixa de velocidades e, principalmente, que a atuação da CBF (função de barreira) pode levar o sistema para regiões distantes do ponto de equilíbrio, a linearização não seria capaz de garantir formalmente a estabilidade global do sistema. Por este motivo, optou-se pelo Método Direto de Lyapunov, que, através da função \( V = (V_f - V_d)^2 \), fornece uma prova de estabilidade válida para todo o domínio de operação, sendo perfeitamente compatível com a estrutura de otimização (QP) utilizada para mediar o conflito entre desempenho e segurança."

Isso mostra que você **domina a teoria**, sabe das limitações de cada método e justifica cientificamente a escolha do seu orientador pela abordagem CLF-CBF-QP. 

Quer agora dar uma olhada na definição da **CBF** (Control Barrier Function) para ver como ela é matematicamente a "irmã gêmea" da CLF, mas trabalhando com desigualdades ao contrário?


$$V(x) = (V_f - V_d)^2$$


E a teoria de Lyapunov garante que, ao resolver a Programação Quadrática restringindo o controle para que satisfaça $L_f V(x) + L_g V(x)u \le -c \cdot V(x) + \delta$, a velocidade do veículo seguidor ($V_f$) convergirá de forma estável e exponencial para a velocidade desejada ($V_d$), aceitando desvios temporários ($\delta > 0$) apenas para priorizar a barreira de segurança física (CBF).
