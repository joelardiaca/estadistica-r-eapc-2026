# =============================================================================
# Sessió 4 - Correlació i regressió lineal
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# -----------------------------------------------------------------------------
# El codi de les slides, en el mateix ordre:
#   - Secció 1: els exemples de la teoria, amb les seccions censals de
#     Barcelona (abstenció i atur a les eleccions al Parlament del 2021).
#   - Secció 2: les novetats de R d'avui: el gràfic de dispersió, cor(),
#     lm() i predict(). Us serveix de xuleta per a la pràctica.
# Executa cada línia amb Ctrl + Enter i mira què passa a la consola.
# =============================================================================


# ---- 0. Preparació -------------------------------------------------------------

# On treballa R? Ha d'acabar en .../sessio-4
# (si no, tanca RStudio i obre el fitxer sessio_4.Rproj)
getwd()

library(tidyverse)

# Seccions censals de 4 municipis: abstenció, atur, població estrangera i renda
seccions <- read_csv2("dades/seccions_censals.csv")
glimpse(seccions)

# Ens quedem amb les 1.068 seccions de Barcelona
bcn <- seccions |>
  filter(municipi == "Barcelona")


# ---- 1. Teoria: correlació i regressió -------------------------------------------

# Diagrama de dispersió: l'atur a l'eix X, l'abstenció a l'eix Y
ggplot(bcn, aes(x = perc_atur, y = abstencio)) +
  geom_point()

# Correlació de Pearson
bcn |>
  summarise(r = cor(perc_atur, abstencio))

# És significativa? H0: la correlació a la població és 0
cor.test(bcn$perc_atur, bcn$abstencio)

# Correlació no és causalitat: la renda està relacionada amb totes dues
bcn |>
  summarise(r_atur_abstencio  = cor(perc_atur, abstencio),
            r_renda_abstencio = cor(renda_persona, abstencio),
            r_renda_atur      = cor(renda_persona, perc_atur))

# Regressió lineal: abstenció segons atur
model <- lm(abstencio ~ perc_atur, data = bcn)
model                # els coeficients: intercept i pendent
summary(model)       # el resum: coeficients, p-valors i R quadrat

# Un exemple concret: la primera secció de Barcelona, la seva predicció i el residu
bcn |>
  mutate(predita = predict(model),
         residu  = abstencio - predita) |>
  select(seccio, perc_atur, abstencio, predita, residu) |>
  head(1)

# Significatiu no vol dir que expliqui molt: abstenció segons % d'estrangers
lm(abstencio ~ perc_estrangers, data = bcn) |>
  summary()

# Predicció: quina abstenció esperem en una secció amb un 20 % d'atur?
predict(model, newdata = tibble(perc_atur = 20))

# Variable explicativa categòrica: Barcelona i l'Hospitalet
dos_municipis <- seccions |>
  filter(municipi %in% c("Barcelona", "L'Hospitalet"))

lm(abstencio ~ municipi, data = dos_municipis)

# El coeficient és la diferència de mitjanes (com a la sessió 3)
dos_municipis |>
  group_by(municipi) |>
  summarise(mitjana = mean(abstencio))

# Per anar més enllà: regressió múltiple (atur i renda alhora)
lm(abstencio ~ perc_atur + renda_persona, data = bcn) |>
  summary()


# ---- 2. Novetats de R: les nostres dades de competències -------------------------

competencies <- read_csv2("dades/competencies.csv")

# Novetat 1. La plantilla del gràfic de dispersió (fixeu-vos: + i no |>)
ggplot(competencies, aes(x = nota_cat, y = nota_ang)) +   # dades i variables
  geom_point() +                                          # un punt per alumne
  geom_smooth(method = "lm")                              # la recta de regressió

# Novetat 2. cor() dins de summarise()
# Si hi ha NA, cor() torna NA: primer traiem els alumnes sense nota
competencies |>
  filter(!is.na(nota_cat), !is.na(nota_ang)) |>
  summarise(r = cor(nota_cat, nota_ang))

# ...i per grups, amb group_by()
competencies |>
  filter(!is.na(nota_cat), !is.na(nota_ang)) |>
  group_by(genere) |>
  summarise(n = n(),
            r = cor(nota_cat, nota_ang))

# Novetat 3. lm(): guardem el model en un objecte...
model_cat <- lm(nota_ang ~ nota_cat, data = competencies)

# ...i després en mirem el resum
summary(model_cat)
coef(model_cat)

# Novetat 4. predict(): la nota d'anglès esperada amb un 50 i un 90 de català
predict(model_cat, newdata = tibble(nota_cat = c(50, 90)))


# Per fer més gràfics de dispersió: vegeu el tutorial de ggplot2 a la web de la sessió 4
