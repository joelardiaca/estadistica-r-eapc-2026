# =============================================================================
# SOLUCIÓ - EXERCICI SESSIÓ 4 - Correlació i regressió lineal
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# -----------------------------------------------------------------------------
# Passos 1 a 9, l'extra que vam fer a classe (passos 10 a 16: regressió
# múltiple i interaccions) i la part opcional de les seccions censals.
# =============================================================================


# ---- Pas 1. Importar les dades -------------------------------------------------------

library(tidyverse)

competencies <- read_csv2("dades/competencies.csv") |>
  mutate(habitat    = factor(habitat,
                             levels = c("Fins a 10000", "De 10001 a 100000", "Més de 100000")),
         nivell_mat = factor(nivell_mat, levels = c("Baix", "Mitjà", "Alt")))

glimpse(competencies)   # 480 alumnes


# =============================================================================
# PART A. CORRELACIÓ
# =============================================================================

# ---- Pas 2. Gràfic de dispersió --------------------------------------------------------

ggplot(competencies, aes(x = nota_cat, y = nota_ang)) +
  geom_point() +
  geom_smooth(method = "lm")

# La relació és positiva: els alumnes amb més nota de català tendeixen a
# treure més nota d'anglès. Els punts segueixen força bé la recta, però amb
# dispersió: sembla una relació forta, no perfecta. Hi ha uns quants alumnes
# amb bona nota de català i molt mala d'anglès (a baix a la dreta).
# L'avís ("Removed 18 rows") són els alumnes sense nota de català o d'anglès.


# ---- Pas 3. Correlació entre català i anglès ---------------------------------------------

competencies |>
  filter(!is.na(nota_cat), !is.na(nota_ang)) |>
  summarise(r = cor(nota_cat, nota_ang))

# r = 0,73: relació positiva i forta (> 0,50).


# ---- Pas 4. Les tres parelles d'assignatures ----------------------------------------------

competencies |>
  filter(!is.na(nota_cat)) |>
  summarise(r_cat_mat = cor(nota_cat, nota_mat))

competencies |>
  filter(!is.na(nota_ang)) |>
  summarise(r_mat_ang = cor(nota_mat, nota_ang))

# Català-anglès: 0,73; català-matemàtiques: 0,59; matemàtiques-anglès: 0,55.
# Totes tres relacions són positives i fortes. La més forta és la de català i
# anglès (les dues llengües) i la més feble, la de matemàtiques i anglès.


# ---- Pas 5. La correlació per grups ---------------------------------------------------------

competencies |>
  filter(!is.na(nota_cat), !is.na(nota_ang)) |>
  group_by(genere) |>
  summarise(n = n(),
            r = cor(nota_cat, nota_ang))

competencies |>
  filter(!is.na(nota_cat), !is.na(nota_ang)) |>
  group_by(titularitat) |>
  summarise(n = n(),
            r = cor(nota_cat, nota_ang))

# La correlació és pràcticament igual en tots els grups: 0,73 per a les noies
# i 0,72 per als nois; 0,73 a la privada i 0,72 a la pública. La relació entre
# català i anglès no depèn del gènere ni de la titularitat.


# =============================================================================
# PART B. REGRESSIÓ LINEAL
# =============================================================================

# ---- Pas 6. Model: la nota d'anglès segons la de català ------------------------------------

model <- lm(nota_ang ~ nota_cat, data = competencies)
summary(model)

# a) Pendent = 0,79: per cada punt més de català, la nota d'anglès és, de
#    mitjana, 0,79 punts més alta.
# b) Intercept = 20,2: la nota d'anglès esperada amb un 0 de català. No té
#    gaire sentit: cap alumne té un 0 de català.
# c) p-valor del pendent < 2e-16 (< 0,001): la relació és significativa. Una
#    relació com aquesta no surt per atzar.
# d) R² = 0,53: la nota de català explica el 53 % de la variació de la nota
#    d'anglès. La resta (47 %) depèn d'altres coses.
# R avisa que ha tret 18 alumnes sense nota ("18 observations deleted due to
# missingness").


# ---- Pas 7. Prediccions ----------------------------------------------------------------------

predict(model, newdata = tibble(nota_cat = c(50, 90)))

# Amb un 50 de català, esperem un 59,5 d'anglès; amb un 90, un 91,0.

competencies |>
  filter(!is.na(nota_cat)) |>
  summarise(minim = min(nota_cat))

# No té sentit predir amb un 0 de català: la nota de català més baixa de les
# dades és un 18,2. Fora del rang de les dades, no sabem si la recta continua
# sent vàlida.


# ---- Pas 8. Una variable explicativa categòrica: la titularitat -----------------------------

lm(nota_mat ~ titularitat, data = competencies)

competencies |>
  group_by(titularitat) |>
  summarise(mitjana = mean(nota_mat))

# Intercept = 76,7: la nota mitjana de matemàtiques de la categoria de
# referència (Privat, la primera per ordre alfabètic).
# Coeficient de titularitatPúblic = -4,75: els alumnes de la pública treuen, de
# mitjana, 4,75 punts menys que els de la privada (72,0 vs. 76,7).
# És la mateixa diferència de mitjanes que vam veure a la sessió 3, però ara
# el model ens la dona directament.


# ---- Pas 9. La correlació, és significativa? -------------------------------------------------

cor.test(competencies$nota_cat, competencies$nota_ang)

# a) p-valor < 2,2e-16 (< 0,001): rebutgem H0. La correlació és significativa.
# b) Amb un 95 % de confiança, la correlació entre català i anglès a tots els
#    alumnes de 6è és entre 0,68 i 0,77: forta, en qualsevol cas.


# =============================================================================
# EXTRA FET A CLASSE. REGRESSIÓ MÚLTIPLE I INTERACCIONS
# =============================================================================
# Què explica la nota de matemàtiques? Provem models amb dues variables X:
#   - Amb "+": l'efecte de cada variable, MANTENINT CONSTANT l'altra.
#   - Amb "*": hi afegim la INTERACCIÓ, és a dir, mirem si l'efecte d'una
#     variable DEPÈN del valor de l'altra.
# En cada model mirem: els coeficients, els seus p-valors i el R² (i el R²
# ajustat, "Adjusted R-squared", que penalitza afegir variables que no aporten
# res: serveix per comparar models amb un nombre diferent de variables).


# ---- Pas 10. Una numèrica i una categòrica: nota_cat + titularitat ---------------------------

model_10 <- lm(nota_mat ~ nota_cat + titularitat, data = competencies)
summary(model_10)

# nota_cat = 0,65: a igual titularitat, cada punt més de català suposa 0,65
# punts més de matemàtiques (p < 0,001).
# titularitatPúblic = -1,5: a igual nota de català, la pública treu 1,5 punts
# menys que la privada, però NO és significatiu (p = 0,27).
# Fixeu-vos: al pas 8, la titularitat sola donava -4,75 punts i era
# significativa. Quan tenim en compte la nota de català, la diferència gairebé
# desapareix: els alumnes de la privada treuen més nota de mates sobretot
# perquè també van millor en general (en català), no pel tipus de centre.
# R² = 0,355: gairebé el mateix que només amb la nota de català (0,353).


# ---- Pas 11. Amb interacció: nota_cat * titularitat ------------------------------------------

model_11 <- lm(nota_mat ~ nota_cat * titularitat, data = competencies)
summary(model_11)

# La interacció (nota_cat:titularitatPúblic = -0,05) no és significativa
# (p = 0,63): la relació entre català i matemàtiques (el pendent) és la mateixa
# a la pública i a la privada. El R² ajustat baixa (de 0,352 a 0,351): la
# interacció no aporta res. Ens quedem amb el model 10.
# Compte: quan hi ha interacció, els coeficients "sols" (nota_cat,
# titularitatPúblic) canvien de significat i no s'han de llegir com abans.


# ---- Pas 12. Dues numèriques: nota_cat + nota_ang ---------------------------------------------

model_12 <- lm(nota_mat ~ nota_cat + nota_ang, data = competencies)
summary(model_12)

# nota_cat = 0,45 i nota_ang = 0,24: totes dues són significatives (p < 0,001).
# A igual nota d'anglès, cada punt més de català suposa 0,45 punts més de
# mates; a igual nota de català, cada punt més d'anglès, 0,24 punts més.
# El coeficient de català és més petit que al model 10 (0,65), perquè català i
# anglès van molt juntes (r = 0,73): ara una part de "ser bon alumne" la recull
# l'anglès.
# R² = 0,371: una mica més que només amb el català (0,353).


# ---- Pas 13. Amb interacció: nota_cat * nota_ang -----------------------------------------------

model_13 <- lm(nota_mat ~ nota_cat * nota_ang, data = competencies)
summary(model_13)

# La interacció (nota_cat:nota_ang) no és significativa (p = 0,60) i el R²
# ajustat baixa (de 0,368 a 0,367). L'efecte del català no depèn de la nota
# d'anglès. Ens quedem amb el model 12.


# ---- Pas 14. Dues categòriques: titularitat + genere ---------------------------------------------

model_14 <- lm(nota_mat ~ titularitat + genere, data = competencies)
summary(model_14)

# Intercept = 74,6: la nota esperada de la categoria de referència de totes
# dues variables (noies de la privada).
# titularitatPúblic = -4,6: a igual gènere, la pública treu 4,6 punts menys
# (p = 0,006).
# genereHome = +4,1: a igual titularitat, els nois treuen 4,1 punts més
# (p = 0,010).
# Totes dues són significatives, però el R² és només de 0,03: expliquen molt
# poca part de la variació de la nota de matemàtiques.


# ---- Pas 15. Amb interacció: titularitat * genere --------------------------------------------------

model_15 <- lm(nota_mat ~ titularitat * genere, data = competencies)
summary(model_15)

# Amb la interacció, el model dona la mitjana exacta de cada combinació
# (com el group_by(titularitat, genere) de la sessió 3):
#   noies privada = 75,2 (l'intercept)
#   noies pública = 75,2 - 5,5 = 69,8
#   nois privada  = 75,2 + 2,9 = 78,2
#   nois pública  = 75,2 - 5,5 + 2,9 + 1,8 = 74,4
# La interacció (+1,8) diu que la diferència entre nois i noies és més gran a
# la pública (4,7 punts) que a la privada (2,9 punts), com vam veure a la
# sessió 3. Però NO és significativa (p = 0,60): no podem afirmar que la
# diferència entre nois i noies depengui de la titularitat. El R² ajustat
# baixa: ens quedem amb el model 14.

competencies |>
  group_by(titularitat, genere) |>
  summarise(mitjana = mean(nota_mat))


# ---- Pas 16. Quin és el millor model? I què faríem nosaltres? -------------------------------------
# Comparem els models amb el R² ajustat:
#   model 10 (nota_cat + titularitat)   0,352
#   model 11 (amb interacció)            0,351
#   model 12 (nota_cat + nota_ang)       0,368   <- el millor dels sis
#   model 13 (amb interacció)            0,367
#   model 14 (titularitat + genere)      0,026
#   model 15 (amb interacció)            0,025
# - Cap interacció és significativa: en tots els casos, el model sense
#   interacció és millor (més simple i amb un R² ajustat més alt).
# - Les notes d'altres assignatures expliquen molt més que la titularitat o
#   el gènere: saber com va un alumne en català i anglès diu molt de com va
#   en mates.

# La "demo": de cada alumne sabem tres coses que poden explicar la nota de
# mates: com de bon alumne és (les altres notes ens en fan de proxy), el seu
# gènere i la titularitat del centre. Com que català i anglès van molt
# juntes, en fem una sola variable: la mitjana de les dues.

competencies <- competencies |>
  mutate(nota_mitjana_cat_ang = (nota_cat + nota_ang) / 2)

# a) Les tres coses alhora
model_16a <- lm(nota_mat ~ nota_mitjana_cat_ang + genere + titularitat, data = competencies)
summary(model_16a)

# La titularitat no és significativa (p = 0,64): a igual nivell en llengües i
# igual gènere, la pública i la privada treuen la mateixa nota de mates.

# b) Sense la titularitat
model_16b <- lm(nota_mat ~ nota_mitjana_cat_ang + genere, data = competencies)
summary(model_16b)

# nota_mitjana_cat_ang = 0,74: per cada punt més de mitjana en català i
# anglès, 0,74 punts més de mates (p < 0,001).
# genereHome = +8,7: a igual nivell en llengües, els nois treuen 8,7 punts més
# de mates que les noies (p < 0,001). És molt més que la diferència "en brut"
# (4,2 punts, sessió 3): les noies van millor en llengües, i quan les
# comparem amb nois del mateix nivell, la diferència en mates es fa més gran.
# R² = 0,43 i R² ajustat = 0,427: més alt que el model a (0,426), amb una
# variable menys.

# c) Amb interacció: l'efecte del nivell en llengües, és igual per a nois i noies?
model_16c <- lm(nota_mat ~ nota_mitjana_cat_ang * genere, data = competencies)
summary(model_16c)

# La interacció (-0,14) no és significativa (p = 0,09): el pendent sembla una
# mica més petit per als nois, però no ho podem afirmar. El R² ajustat puja
# molt poc (de 0,427 a 0,429).

# Conclusió: ens quedem amb el model b (nivell en llengües + gènere). És
# simple, tots els coeficients són significatius i explica el 43 % de la
# variació de la nota de matemàtiques. Quan dos models expliquen gairebé el
# mateix, preferim el més SIMPLE.


# =============================================================================
# OPCIONAL 1. ANÀLISI DE LES SECCIONS CENSALS
# =============================================================================

seccions <- read_csv2("dades/seccions_censals.csv") |>
  mutate(renda_milers = renda_persona / 1000)

glimpse(seccions)   # 1.469 seccions


# ---- a) Descriure ----------------------------------------------------------------------

seccions |>
  group_by(municipi) |>
  summarise(n            = n(),
            abstencio    = mean(abstencio),
            atur         = mean(perc_atur),
            renda_milers = mean(renda_milers)) |>
  arrange(desc(abstencio))

# Badalona és el municipi que més s'absté (55,6 %), seguit de l'Hospitalet
# (53,6 %). Barcelona (43,1 %) i Girona (42,1 %) s'abstenen uns 10 punts menys.
# Barcelona té la renda mitjana més alta (16.800 euros per persona) i
# l'Hospitalet, la més baixa (11.800).


# ---- b) Correlacions ---------------------------------------------------------------------

seccions |>
  summarise(r_atur       = cor(abstencio, perc_atur),
            r_estrangers = cor(abstencio, perc_estrangers),
            r_renda      = cor(abstencio, renda_milers))

# L'abstenció està molt relacionada amb la renda (r = -0,85: com més renda,
# menys abstenció) i amb l'atur (r = 0,84: com més atur, més abstenció). Amb el
# % de població estrangera, la relació és moderada (r = 0,44).


# ---- c) Per municipi -----------------------------------------------------------------------

seccions |>
  group_by(municipi) |>
  summarise(n = n(),
            r = cor(renda_milers, abstencio))

# A tots quatre municipis la relació és negativa i molt forta, de -0,83
# (Barcelona) a -0,94 (Badalona).


# ---- d) Regressió simple -------------------------------------------------------------------

ggplot(seccions, aes(x = renda_milers, y = abstencio)) +
  geom_point() +
  geom_smooth(method = "lm")

model_renda <- lm(abstencio ~ renda_milers, data = seccions)
summary(model_renda)

predict(model_renda, newdata = tibble(renda_milers = c(15, 25)))

# Per cada 1.000 euros més de renda per persona, l'abstenció baixa, de mitjana,
# 1,95 punts (p < 0,001). La renda explica el 73 % de la variació de
# l'abstenció. Amb una renda de 15.000 euros esperem un 47,0 % d'abstenció; amb
# 25.000 euros, un 27,5 % (totes dues dins del rang de les dades: de 4.500 a
# 31.700 euros).


# ---- e) Una X categòrica: Badalona i Girona -------------------------------------------------

badalona_girona <- seccions |>
  filter(municipi %in% c("Badalona", "Girona"))

lm(abstencio ~ municipi, data = badalona_girona) |>
  summary()

t.test(abstencio ~ municipi, data = badalona_girona)

# Intercept = 55,6: l'abstenció mitjana de Badalona (la referència).
# Coeficient de municipiGirona = -13,5: Girona s'absté, de mitjana, 13,5 punts
# menys que Badalona (42,1 %). La diferència és significativa (p < 0,001).
# El t-test diu el mateix: les mateixes mitjanes (55,6 i 42,1) i una diferència
# significativa. Els p-valors no són idèntics perquè t.test() fa la versió de
# Welch (no suposa variàncies iguals), però la conclusió és la mateixa.


# ---- f) Regressió múltiple ------------------------------------------------------------------

model_atur <- lm(abstencio ~ perc_atur, data = seccions)
summary(model_atur)

model_atur_renda <- lm(abstencio ~ perc_atur + renda_milers, data = seccions)
summary(model_atur_renda)

# Només amb l'atur, cada punt més d'atur suposa 1,88 punts més d'abstenció
# (R² = 0,71). Quan afegim la renda, el coeficient de l'atur baixa a 1,00:
# gairebé la meitat. Les seccions amb més atur són també les de menys renda, i
# una part de l'efecte que atribuíem a l'atur era, en realitat, de la renda.
# Ara, a igual renda, cada punt més d'atur suposa 1 punt més d'abstenció; i a
# igual atur, cada 1.000 euros més de renda, 1,16 punts menys.
# Junts expliquen més: el R² puja de 0,71 a 0,81.


# ---- g) Conclusions ---------------------------------------------------------------------------
# L'abstenció a les eleccions al Parlament del 2021 va ser més alta a Badalona
# i l'Hospitalet que a Barcelona i Girona. A tots quatre municipis, les seccions
# amb menys renda i més atur s'abstenen molt més: la renda sola explica el 73 %
# de les diferències d'abstenció entre seccions, i amb l'atur, el 81 %.
#
# Limitacions:
#   - Correlació no és causalitat: no podem dir que la renda "provoqui"
#     l'abstenció; hi pot haver altres variables (edat, nivell d'estudis...).
#   - Són dades per secció, no per persona: no podem dir que les persones amb
#     menys renda s'abstinguin més (podria ser, però caldria una enquesta).
#   - Només són 4 municipis de l'àrea de Barcelona i Girona: no és tot Catalunya.
