# =============================================================================
# SOLUCIÓ - EXERCICI SESSIÓ 3 - Estadística bivariada
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# =============================================================================


# ---- Pas 1. Importar les dades -------------------------------------------------------

library(tidyverse)

competencies <- read_csv2("dades/competencies.csv") |>
  mutate(habitat    = factor(habitat,
                             levels = c("Fins a 10000", "De 10001 a 100000", "Més de 100000")),
         nivell_mat = factor(nivell_mat, levels = c("Baix", "Mitjà", "Alt")))

glimpse(competencies)   # 480 alumnes; habitat i nivell_mat són <fct>


# =============================================================================
# PART A. DUES VARIABLES CATEGÒRIQUES
# =============================================================================

# ---- Pas 2. Taula de contingència amb count() ---------------------------------------

competencies |>
  count(titularitat, nivell_mat)

# Cada fila és una cel·la de la taula de contingència. 153 alumnes de centres
# públics tenen un nivell alt de matemàtiques (i 95 de centres privats).


# ---- Pas 3. Percentatges dins de cada titularitat ------------------------------------

competencies |>
  count(titularitat, nivell_mat) |>
  group_by(titularitat) |>
  mutate(percentatge = n / sum(n) * 100) |>
  ungroup()

# Amb group_by(titularitat), sum(n) és el total de CADA titularitat: els
# percentatges sumen 100 dins de la pública i dins de la privada.
# Als centres privats hi ha més alumnes amb nivell alt (58,3 %) que als
# públics (48,3 %), i menys amb nivell baix (8,6 % vs. 14,2 %).


# ---- Pas 4. Ara sols: hàbitat i nivell de matemàtiques ---------------------------------

competencies |>
  count(habitat, nivell_mat) |>
  group_by(habitat) |>
  mutate(percentatge = n / sum(n) * 100) |>
  ungroup()

# Com més petit és el municipi, més alumnes amb nivell alt: 59,4 % als
# municipis de fins a 10.000 habitants, 51,4 % als de 10.001 a 100.000 i
# 47,3 % als de més de 100.000.


# =============================================================================
# PART B. VARIABLE NUMÈRICA I CATEGÒRICA
# =============================================================================

# ---- Pas 5. Nota de matemàtiques per titularitat -------------------------------------

competencies |>
  group_by(titularitat) |>
  summarise(n           = n(),
            mitjana     = mean(nota_mat),
            mediana     = median(nota_mat),
            desv_tipica = sd(nota_mat))

# Centres privats: 163 alumnes, mitjana de 76,7 punts (mediana 81,6).
# Centres públics: 317 alumnes, mitjana de 72,0 punts (mediana 74,5).
# Els alumnes dels centres privats treuen gairebé 5 punts més de mitjana.
# La dispersió és semblant (desviació típica de 16,4 i 17,9).


# ---- Pas 6. Les tres assignatures per hàbitat -----------------------------------------

competencies |>
  group_by(habitat) |>
  summarise(n           = n(),
            mitjana_cat = mean(nota_cat, na.rm = TRUE),
            mitjana_mat = mean(nota_mat),
            mitjana_ang = mean(nota_ang, na.rm = TRUE)) |>
  arrange(desc(mitjana_cat))

# Als municipis més petits (fins a 10.000 habitants) les mitjanes són una mica
# més altes a les tres assignatures, sobretot a català (77,6 vs. 73,8 i 73,6).
# Però les diferències són petites: entre 1 i 4 punts.
# (Amb un sol group_by() no cal ungroup(): summarise() ja treu el grup.)


# ---- Pas 7. Dues variables de grup: titularitat i gènere --------------------------------

competencies |>
  group_by(titularitat, genere) |>
  summarise(n       = n(),
            mitjana = mean(nota_mat)) |>
  ungroup() |>
  arrange(desc(mitjana))

# Els nois treuen més nota de matemàtiques que les noies als dos tipus de
# centre, però la diferència és més gran a la pública (74,4 vs. 69,8: 4,6 punts)
# que a la privada (78,2 vs. 75,2: 3,0 punts). La nota més alta és la dels nois
# de la privada i la més baixa, la de les noies de la pública.


# =============================================================================
# OPCIONAL 1. LES DIFERÈNCIES, SÓN SIGNIFICATIVES?
# =============================================================================

# a) Test chi-quadrat (passos 2 i 3)
# H0: el nivell de matemàtiques no té relació amb la titularitat
# H1: hi ha relació

chisq.test(competencies$titularitat, competencies$nivell_mat)

# X-squared = 5,42, p-valor = 0,066 > 0,05: no podem rebutjar H0.
# A la mostra hi ha diferències (10 punts més de nivell alt a la privada), però
# no són prou grans per afirmar que existeixin a tots els alumnes de Catalunya.
# No vol dir que no n'hi hagi: amb aquestes dades no ho podem assegurar (el
# p-valor és a prop del límit).

# b) t-test (pas 5)
# H0: la nota mitjana de matemàtiques és igual a la pública i a la privada
# H1: és diferent

t.test(nota_mat ~ titularitat, data = competencies)

# p-valor = 0,004 < 0,05: rebutgem H0. La diferència de 4,7 punts és
# estadísticament significativa: no és fruit de l'atzar de la mostra.
# Que sigui significativa no vol dir que la titularitat en sigui la causa: les
# famílies que porten els fills a la privada poden tenir, de mitjana, més
# recursos.


# =============================================================================
# OPCIONAL 2. REPTE: ESPERANÇA DE VIDA PER CONTINENT
# =============================================================================

# a) Importar
esperanca <- read_csv2("dades/paisos_esperanca_vida.csv")
glimpse(esperanca)   # 236 països i territoris

# b) Resums per continent, ordenats de més a menys esperança de vida
esperanca |>
  group_by(CONTINENT) |>
  summarise(n       = n(),
            mitjana = mean(ESP_VIDA),
            minim   = min(ESP_VIDA),
            maxim   = max(ESP_VIDA)) |>
  arrange(desc(mitjana))

# Europa té l'esperança de vida mitjana més alta (80,4 anys) i Àfrica, la més
# baixa (66,2): més de 14 anys de diferència. Dins de cada continent també hi
# ha molta variació: a l'Àfrica, de 54,5 a 83,5 anys.

# c) Els 5 països d'Europa amb més esperança de vida
esperanca |>
  filter(CONTINENT == "Europe") |>
  arrange(desc(ESP_VIDA)) |>
  head(5)

# Mònaco, San Marino, Andorra, Suïssa i Itàlia: totes per sobre dels 83 anys.
