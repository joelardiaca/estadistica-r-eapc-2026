# =============================================================================
# Sessió 2 - Estadística descriptiva i introducció a la inferència
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# -----------------------------------------------------------------------------
# El codi de les slides, en el mateix ordre:
#   - Seccions 1 i 2 (descriptiva): us serveixen de xuleta per a la part A
#     de la pràctica 2.
#   - Secció 3 (inferència): la seguirem a classe després de la pausa, i us
#     servirà de xuleta per a la part B de la pràctica 2.
# Executa cada línia amb Ctrl + Enter i mira què passa a la consola.
# =============================================================================


# ---- 0. Preparació -------------------------------------------------------------

# On treballa R? Ha d'acabar en .../sessio-2
# (si no, tanca RStudio i obre el fitxer sessio_2.Rproj)
getwd()

library(tidyverse)

# Les dades netes de la pràctica 1 (el mateix fitxer que vau exportar)
competencies <- read_csv2("dades/competencies.csv")

# El CSV no guarda l'ordre de les categories: el tornem a posar
competencies <- competencies |>
  mutate(habitat = factor(habitat,
                          levels = c("Fins a 10000", "De 10001 a 100000", "Més de 100000")))

glimpse(competencies)


# ---- 1. Variables categòriques: count() -----------------------------------------

# Freqüència absoluta: quants alumnes hi ha a cada categoria
competencies |>
  count(titularitat)

# Freqüència relativa: quin percentatge representen
competencies |>
  count(titularitat) |>
  mutate(percentatge = n / sum(n) * 100)

# Variables ordinals: percentatge acumulat amb cumsum()
competencies |>
  count(habitat) |>
  mutate(percentatge = n / sum(n) * 100,
         percentatge_acumulat = cumsum(percentatge))


# ---- 2. Variables numèriques -----------------------------------------------------

# Mitjana i mediana: un valor extrem "estira" la mitjana, però no la mediana
alcades <- c(165, 168, 170, 172, 210)
mean(alcades)
median(alcades)

# Valors perduts: si hi ha algun NA, el resultat és NA...
mean(competencies$nota_cat)

# ...i cal dir-li que els ignori amb na.rm = TRUE
mean(competencies$nota_cat, na.rm = TRUE)

# Quants NA hi ha?
sum(is.na(competencies$nota_cat))

# Quartils: amb unes dades "de joguina" (12 notes, 4 quarts de 3)...
notes <- c(2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 9, 10)
quantile(notes)

# ...i amb les dades reals
quantile(competencies$nota_cat, na.rm = TRUE)

# Percentils: triem quins volem amb probs (en tant per u)
quantile(competencies$nota_cat, probs = c(0.1, 0.9), na.rm = TRUE)

# Variància i desviació típica de 5 alçades (el càlcul a mà és a les slides)
alcades2 <- c(160, 170, 180, 165, 175)
var(alcades2)
sd(alcades2)

# Dispersió: desviació típica, interval interquartílic, mínim i màxim
sd(competencies$nota_cat, na.rm = TRUE)
IQR(competencies$nota_cat, na.rm = TRUE)
min(competencies$nota_cat, na.rm = TRUE)
max(competencies$nota_cat, na.rm = TRUE)

# Tot de cop
summary(competencies$nota_cat)

# A la nostra manera, amb summarise(): cada línia és nom = funcio(variable)
competencies |>
  summarise(mitjana     = mean(nota_cat, na.rm = TRUE),
            mediana     = median(nota_cat, na.rm = TRUE),
            q1          = quantile(nota_cat, 0.25, na.rm = TRUE),
            q3          = quantile(nota_cat, 0.75, na.rm = TRUE),
            desv_tipica = sd(nota_cat, na.rm = TRUE),
            iqr         = IQR(nota_cat, na.rm = TRUE))


# Per fer gràfics: vegeu el tutorial de ggplot2 a la web de la sessió 2


# ---- 3. Inferència ------------------------------------------------------------------

# Error estàndard: quant pot variar la mitjana d'una mostra a una altra
competencies |>
  summarise(mitjana     = mean(nota_mat),
            desv_tipica = sd(nota_mat),
            n           = n(),
            se          = desv_tipica / sqrt(n))

# Interval de confiança del 95 %: mitjana +/- 1,96 errors estàndard
competencies |>
  summarise(mitjana = mean(nota_mat),
            se      = sd(nota_mat) / sqrt(n()),
            inf     = mitjana - 1.96 * se,
            sup     = mitjana + 1.96 * se)

# El mateix amb una sola comanda (ignora els NA automàticament)
t.test(competencies$nota_mat)$conf.int

# Més confiança = interval més ample
t.test(competencies$nota_mat, conf.level = 0.90)$conf.int
t.test(competencies$nota_mat, conf.level = 0.99)$conf.int

# Proporcions: quin percentatge d'alumnes va a un centre públic?
# 1) La proporció a la mostra
competencies |>
  count(titularitat) |>
  mutate(proporcio = n / sum(n))

# 2) L'interval de confiança: 317 alumnes de centres públics de 480
prop.test(317, 480)$conf.int

# Contrast d'hipòtesis: la nota mitjana de matemàtiques és diferent de 72?
#   H0: la mitjana és 72     H1: la mitjana no és 72
# Si el p-valor < 0,05, rebutgem H0
t.test(competencies$nota_mat, mu = 72)

# I diferent de 74? (el 74 és dins de l'interval de confiança)
t.test(competencies$nota_mat, mu = 74)$p.value
