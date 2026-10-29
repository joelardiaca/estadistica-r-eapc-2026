# =============================================================================
# EXERCICI SESSIÓ 3 - Estadística bivariada
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# -----------------------------------------------------------------------------
# Nom i cognoms:
#
# DADES: dades/competencies.csv
#   Les mateixes dades netes de la sessió 2 (480 alumnes de 6è). Cada fila és
#   un alumne.
#     id                            identificador anònim de l'alumne
#     genere                        Dona / Home
#     titularitat                   titularitat del centre (Públic / Privat)
#     habitat                       mida del municipi del centre
#     nota_cat, nota_mat, nota_ang  puntuació (0-100) en català, matemàtiques i anglès
#     nota_mitjana                  mitjana de les tres notes
#     nivell_mat                    nivell de matemàtiques: Baix / Mitjà / Alt
#
# QUÈ CAL FER:
#   Pas 1. Importar les dades (JA FET: només cal executar-lo).
#   PART A. Dues variables categòriques: count() + group_by()
#     Pas 2. Taula de contingència de titularitat i nivell_mat amb count().
#     Pas 3. Percentatge de cada nivell de matemàtiques dins de cada titularitat.
#     Pas 4. Ara sols: el mateix amb habitat i nivell_mat.
#   PART B. Variable numèrica i categòrica: group_by() + summarise()
#     Pas 5. Nota de matemàtiques per titularitat.
#     Pas 6. Les tres assignatures per hàbitat, ordenades.
#     Pas 7. Dues variables de grup: titularitat i gènere.
#   OPCIONAL (si us sobra temps):
#     Opcional 1. Les diferències, són significatives?
#     Opcional 2. Repte: esperança de vida per continent.
#     Opcional 3. Tutorial de gràfics bivariats amb ggplot2 (a la web).
#
# Comenteu i interpreteu cada resultat EN PARAULES, amb comentaris (#).
#
# QUÈ CAL LLIURAR:
#   - Aquest script (.R) complet i comentat (parts A i B; l'opcional, si l'heu fet).
#   Per correu electrònic a joelardiacaarnau@gencat.cat
#
# Consells:
#   - Obriu el projecte sessio_3.Rproj (no aquest fitxer directament) i
#     comproveu amb getwd() que R és a la carpeta sessio-3.
#   - Executeu línia a línia (Ctrl + Enter) i mireu el resultat de cada pas.
#   - Teniu tot el codi que cal a codi/01_bivariada.R i a les slides.
# =============================================================================


# ---- Pas 1. Importar les dades (JA FET: només cal executar-lo) -------------------------
# Importem les dades i tornem a ordenar les categories de habitat i nivell_mat
# (el CSV no guarda l'ordre).

library(tidyverse)

competencies <- read_csv2("dades/competencies.csv") |>
  mutate(habitat    = factor(habitat,
                             levels = c("Fins a 10000", "De 10001 a 100000", "Més de 100000")),
         nivell_mat = factor(nivell_mat, levels = c("Baix", "Mitjà", "Alt")))

glimpse(competencies)   # han de sortir 480 files; habitat i nivell_mat són <fct>


# =============================================================================
# PART A. DUES VARIABLES CATEGÒRIQUES
# =============================================================================
# Pregunta: el nivell de matemàtiques (VD), és diferent als centres públics i
# als privats (VI)?

# ---- Pas 2. Taula de contingència amb count() --------------------------------------------
# Compteu quants alumnes hi ha de cada combinació de titularitat i nivell_mat.
# Pista: count() amb DUES variables, separades per una coma.
# Responeu: quants alumnes de centres públics tenen un nivell alt?

# TODO

# Resposta:



# ---- Pas 3. Percentatges dins de cada titularitat ------------------------------------------
# Quin percentatge d'alumnes té cada nivell de matemàtiques, DINS de la pública
# i DINS de la privada?
# Pista: partiu del pas 2 i afegiu-hi, amb |>,
#          group_by(titularitat)
#          mutate(percentatge = n / sum(n) * 100)
#          ungroup()
# Comproveu que els percentatges sumen 100 dins de cada titularitat.
# Responeu: on hi ha més alumnes amb nivell alt, a la pública o a la privada?

# TODO

# Resposta:



# ---- Pas 4. Ara sols: hàbitat i nivell de matemàtiques ----------------------------------------
# Repetiu els passos 2 i 3 amb habitat (en lloc de titularitat) i nivell_mat.
# Responeu: el percentatge d'alumnes amb nivell alt, canvia segons la mida del
# municipi?

# TODO

# Resposta:



# =============================================================================
# PART B. VARIABLE NUMÈRICA I CATEGÒRICA
# =============================================================================

# ---- Pas 5. Nota de matemàtiques per titularitat -------------------------------------------
# Per a cada titularitat: nombre d'alumnes, mitjana, mediana i desviació típica
# de nota_mat.
# Pista: competencies |>
#          group_by(titularitat) |>
#          summarise(n = n(), mitjana = mean(nota_mat), ...)
# Responeu: qui treu millor nota de matemàtiques, de mitjana? Quants punts més?

# TODO

# Resposta:



# ---- Pas 6. Les tres assignatures per hàbitat ---------------------------------------------
# En un sol summarise(), la mitjana de nota_cat, nota_mat i nota_ang per a cada
# categoria de habitat. Ordeneu el resultat de més a menys nota de català.
# Pistes: - nota_cat i nota_ang tenen NA: na.rm = TRUE
#         - per ordenar, al final: arrange(desc(mitjana_cat))
# Responeu: hi ha diferències segons la mida del municipi? Són grans?

# TODO

# Resposta:



# ---- Pas 7. Dues variables de grup: titularitat i gènere ------------------------------------
# Nota mitjana de matemàtiques (i nombre d'alumnes) per a cada combinació de
# titularitat i gènere, ordenat de més a menys nota.
# Pista: group_by(titularitat, genere), després summarise(), ungroup() i arrange()
# Responeu: la diferència entre nois i noies, és igual a la pública i a la privada?

# TODO

# Resposta:



# =============================================================================
# OPCIONAL 1. LES DIFERÈNCIES, SÓN SIGNIFICATIVES?
# =============================================================================
# Fins ara hem descrit la mostra. Però, podem generalitzar les diferències a
# tots els alumnes de 6è de Catalunya? Si el p-valor < 0,05, rebutgem H0.

# a) Dues categòriques (passos 2 i 3): test chi-quadrat
#    H0: el nivell de matemàtiques no té relació amb la titularitat
#    chisq.test(competencies$titularitat, competencies$nivell_mat)

# TODO

# Resposta:

# b) Numèrica i categòrica (pas 5): t-test
#    H0: la nota mitjana de matemàtiques és igual a la pública i a la privada
#    t.test(nota_mat ~ titularitat, data = competencies)

# TODO

# Resposta:



# =============================================================================
# OPCIONAL 2. REPTE: ESPERANÇA DE VIDA PER CONTINENT
# =============================================================================
# Dades: dades/paisos_esperanca_vida.csv (Our World in Data, 2023)
#   PAIS       nom del país o territori
#   CONTINENT  continent (Africa, Americas, Asia, Europe, Oceania)
#   ESP_VIDA   esperança de vida en néixer (anys)
#
# a) Importeu les dades amb read_csv2() i mireu-les amb glimpse().
# b) Per a cada continent: nombre de països, mitjana, mínim i màxim de ESP_VIDA,
#    ordenat de més a menys esperança de vida mitjana.
# c) Quins són els 5 països d'Europa amb més esperança de vida?
#    Pista: filter(), arrange(desc(...)) i head(5)

# TODO



# =============================================================================
# OPCIONAL 3. GRÀFICS
# =============================================================================
# Seguiu el tutorial de gràfics bivariats amb ggplot2 de la web de la sessió 3.
