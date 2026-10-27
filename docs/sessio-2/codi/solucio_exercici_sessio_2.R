# =============================================================================
# SOLUCIÓ - EXERCICI SESSIÓ 2 - Estadística descriptiva i inferència
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# =============================================================================


# =============================================================================
# PART A. ESTADÍSTICA DESCRIPTIVA
# =============================================================================

# ---- Pas 1. Importar les dades ------------------------------------------------------

library(tidyverse)

competencies <- read_csv2("dades/competencies.csv") |>
  mutate(habitat = factor(habitat,
                          levels = c("Fins a 10000", "De 10001 a 100000", "Més de 100000")))

glimpse(competencies)   # 480 alumnes i 9 variables; habitat és <fct>


# ---- Pas 2. Freqüències de habitat ---------------------------------------------------

competencies |>
  count(habitat) |>
  mutate(percentatge = n / sum(n) * 100,
         percentatge_acumulat = cumsum(percentatge))

# La categoria més freqüent són els municipis d'entre 10.001 i 100.000 habitants
# (44,2 %). El 65,2 % dels alumnes estudia en municipis de 100.000 habitants o menys.
# L'acumulat té sentit perquè al pas 1 hem ordenat habitat amb factor().


# ---- Pas 3. Descriptiva de nota_cat ---------------------------------------------------

competencies |>
  summarise(mitjana     = mean(nota_cat, na.rm = TRUE),
            mediana     = median(nota_cat, na.rm = TRUE),
            q1          = quantile(nota_cat, 0.25, na.rm = TRUE),
            q3          = quantile(nota_cat, 0.75, na.rm = TRUE),
            desv_tipica = sd(nota_cat, na.rm = TRUE),
            iqr         = IQR(nota_cat, na.rm = TRUE))

# Hi ha 16 alumnes sense nota de català: sense na.rm = TRUE, tot surt NA.
# La nota mitjana de català és de 74,5 punts i la mediana, de 77,8. El 50 %
# central dels alumnes té notes entre 64,9 i 85,7 (IQR = 20,8 punts).
# La mitjana és més baixa que la mediana: hi ha una cua a l'esquerra (una
# minoria d'alumnes amb notes molt baixes estira la mitjana cap avall).


# ---- Pas 4. Comparar les tres assignatures ---------------------------------------------

competencies |>
  summarise(mitj_cat = mean(nota_cat, na.rm = TRUE),
            mitj_mat = mean(nota_mat),
            mitj_ang = mean(nota_ang, na.rm = TRUE),
            med_cat  = median(nota_cat, na.rm = TRUE),
            med_mat  = median(nota_mat),
            med_ang  = median(nota_ang, na.rm = TRUE))

# Anglès és l'assignatura amb les notes més altes (mitjana 78,5 i mediana 83,5).
# A totes tres la mitjana és més baixa que la mediana (cua a l'esquerra). On hi
# ha més diferència és a anglès (5 punts).
# nota_mat no necessita na.rm = TRUE perquè a la pràctica 1 vam eliminar els
# alumnes sense nota de matemàtiques.


# =============================================================================
# PART B. INFERÈNCIA
# =============================================================================

# ---- Pas 5. Interval de confiança del 95 % ---------------------------------------------

# a) A mà
competencies |>
  filter(!is.na(nota_cat)) |>
  summarise(mitjana     = mean(nota_cat),
            desv_tipica = sd(nota_cat),
            n           = n(),
            se          = desv_tipica / sqrt(n),
            inf         = mitjana - 1.96 * se,
            sup         = mitjana + 1.96 * se)

# 464 alumnes tenen nota de català. Mitjana = 74,5; desviació típica = 15,7;
# error estàndard = 0,73 punts.
# Si no traiem els NA, n() val 480 i l'error estàndard surt una mica més petit
# del que toca.

# b) Amb t.test()
t.test(competencies$nota_cat)$conf.int

# c) Les dues maneres donen el mateix interval: de 73,1 a 76,0 punts.
# Amb un 95 % de confiança, la nota mitjana de català de tots els alumnes de 6è
# de Catalunya és entre 73,1 i 76,0 punts.


# ---- Pas 6. Altres nivells de confiança ---------------------------------------------------

t.test(competencies$nota_cat, conf.level = 0.90)$conf.int   # 73,3 - 75,7
t.test(competencies$nota_cat, conf.level = 0.99)$conf.int   # 72,6 - 76,4

# L'interval del 99 % és el més ample i el del 90 %, el més estret. Per estar més
# segurs d'encertar el valor real, hem d'acceptar un interval més ample
# (menys precís).


# ---- Pas 7. Una proporció ------------------------------------------------------------------

# a) Proporció a la mostra
competencies |>
  count(nivell_mat) |>
  mutate(proporcio = n / sum(n))

# b) Interval de confiança: 248 alumnes amb nivell "Alt" de 480
prop.test(248, 480)$conf.int

# El 51,7 % dels alumnes de la mostra (248 de 480) té un nivell alt de
# matemàtiques. A tot Catalunya, amb un 95 % de confiança, entre el 47,1 % i el
# 56,2 %. Com que el 50 % és dins de l'interval, no podem afirmar que més de la
# meitat dels alumnes de Catalunya tinguin un nivell alt.


# ---- Pas 8. Contrast d'hipòtesis ---------------------------------------------------------

# H0: la nota mitjana de català és 75
# H1: la nota mitjana de català no és 75

t.test(competencies$nota_cat, mu = 75)

# p-valor = 0,51 > 0,05: no podem rebutjar H0. No tenim evidència que la nota
# mitjana de català sigui diferent de 75 punts.
# És coherent amb el pas 5: el 75 és dins de l'interval de confiança del 95 %
# (73,1 - 76,0). Que no rebutgem H0 no vol dir que la mitjana sigui exactament 75:
# només que les dades són compatibles amb aquest valor.

