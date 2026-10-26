# =============================================================================
# EXERCICI SESSIÓ 2 - Estadística descriptiva i inferència
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# -----------------------------------------------------------------------------
# Nom i cognoms:
#
# DADES: dades/competencies.csv
#   Les dades de competències bàsiques de 6è ja netes: són exactament les que
#   s'obtenen en acabar la pràctica 1 (480 alumnes). Cada fila és un alumne.
#     id                            identificador anònim de l'alumne
#     genere                        Dona / Home
#     titularitat                   titularitat del centre (Públic / Privat)
#     habitat                       mida del municipi del centre
#     nota_cat, nota_mat, nota_ang  puntuació (0-100) en català, matemàtiques i anglès
#     nota_mitjana                  mitjana de les tres notes
#     nivell_mat                    nivell de matemàtiques: Baix / Mitjà / Alt
#
# QUÈ CAL FER:
#   PART A. Estadística descriptiva (abans de la pausa)
#     Pas 1. Importar les dades i ordenar les categories de habitat.
#     Pas 2. Freqüències de habitat, amb percentatges i percentatges acumulats.
#     Pas 3. Descriptiva de nota_cat amb summarise().
#     Pas 4. Comparar les tres assignatures.
#   PART B. Inferència (després de la pausa)
#     Pas 5. Interval de confiança del 95 % de la nota mitjana de català,
#            a mà amb summarise() i amb t.test().
#     Pas 6. Intervals de confiança del 90 % i del 99 %.
#     Pas 7. Proporció d'alumnes amb nivell "Alt" de matemàtiques i el seu IC.
#     Pas 8. Contrast: la nota mitjana de català és diferent de 75?
#
# Comenteu i interpreteu cada resultat EN PARAULES, amb comentaris (#).
#
# QUÈ CAL LLIURAR:
#   - Aquest script (.R) complet i comentat (parts A i B).
#   Per correu electrònic a joelardiacaarnau@gencat.cat
#
# Consells:
#   - Obriu el projecte sessio_2.Rproj (no aquest fitxer directament) i
#     comproveu amb getwd() que R és a la carpeta sessio-2.
#   - Executeu línia a línia (Ctrl + Enter) i mireu el resultat de cada pas.
#   - Teniu tot el codi que cal a codi/01_descriptiva_inferencia.R i a les slides.
# =============================================================================


# =============================================================================
# PART A. ESTADÍSTICA DESCRIPTIVA
# =============================================================================

# ---- Pas 1. Importar les dades ------------------------------------------------------
# a) Carregueu el tidyverse i importeu dades/competencies.csv amb read_csv2().
# b) El CSV no guarda l'ordre de les categories: amb mutate() i factor(),
#    torneu a ordenar habitat ("Fins a 10000", "De 10001 a 100000",
#    "Més de 100000"), com al pas 6 de la pràctica 1.
# c) Comproveu el resultat amb glimpse(): habitat ha de ser <fct>.

# TODO



# ---- Pas 2. Freqüències de habitat ---------------------------------------------------
# Freqüències absolutes, percentatges i percentatges acumulats.
# Pista: count() i després mutate() amb n / sum(n) * 100 i cumsum()
# Responeu: quin percentatge d'alumnes estudia en municipis de 100.000
# habitants o menys?

# TODO

# Resposta:



# ---- Pas 3. Descriptiva de nota_cat ---------------------------------------------------
# Amb summarise(): mitjana, mediana, Q1, Q3, desviació típica i IQR.
# Pista: hi ha alumnes sense nota de català: no us oblideu de na.rm = TRUE
# Responeu: la mitjana és més alta o més baixa que la mediana? Què vol dir?

# TODO

# Resposta:



# ---- Pas 4. Comparar les tres assignatures ---------------------------------------------
# En un sol summarise(), la mitjana i la mediana de nota_cat, nota_mat i nota_ang.
# Responeu: en quina assignatura s'obtenen les notes més altes? En quina hi ha
# més diferència entre la mitjana i la mediana?

# TODO

# Resposta:



# =============================================================================
# PART B. INFERÈNCIA
# =============================================================================
# Considerem que aquests 480 alumnes són una mostra aleatòria de tots els
# alumnes de 6è de Catalunya. Volem saber coses de TOTS els alumnes a partir
# d'aquesta mostra. Treballarem amb la nota de català (nota_cat).

# ---- Pas 5. Interval de confiança del 95 % ---------------------------------------------
# a) A mà, amb summarise(): calculeu la mitjana, la desviació típica, n,
#    l'error estàndard i els límits de l'interval.
#
#    Atenció: nota_cat té NA, i n() compta TOTES les files (també les que
#    tenen NA). Per això, primer traieu els alumnes sense nota de català:
#
#      competencies |>
#        filter(!is.na(nota_cat)) |>
#        summarise(mitjana     = mean(nota_cat),
#                  desv_tipica = ...,
#                  n           = ...,
#                  se          = desv_tipica / sqrt(n),
#                  inf         = mitjana - 1.96 * se,
#                  sup         = ...)
#
# b) El mateix amb t.test(...)$conf.int
# c) Doneu pràcticament el mateix? Interpreteu l'interval en paraules:
#    "Amb un 95 % de confiança, la nota mitjana de català de tots els
#     alumnes de 6è de Catalunya és entre ... i ... punts."

# TODO

# Resposta:



# ---- Pas 6. Altres nivells de confiança ---------------------------------------------------
# Intervals de confiança del 90 % i del 99 % per a la nota mitjana de català.
# Pista: t.test(..., conf.level = 0.90)$conf.int
# Responeu: quin és més ample? Per què?

# TODO

# Resposta:



# ---- Pas 7. Una proporció ------------------------------------------------------------------
# Quin percentatge d'alumnes té un nivell "Alt" de matemàtiques?
# a) Taula de freqüències de nivell_mat amb la proporció de cada nivell.
#    Pista: count() i després mutate(proporcio = n / sum(n))
# b) Interval de confiança del 95 % amb prop.test(casos, total)$conf.int,
#    posant-hi els números de la taula de l'apartat a): quants alumnes
#    tenen nivell "Alt" i quants alumnes hi ha en total.
# c) Responeu: podem dir que a Catalunya més de la meitat dels alumnes
#    tenen un nivell alt de matemàtiques? (Mireu si el 50 % és dins de l'interval.)

# TODO

# Resposta:



# ---- Pas 8. Contrast d'hipòtesis ---------------------------------------------------------
# La nota mitjana de català a Catalunya, és diferent de 75?
# a) Escriviu H0 i H1.
# b) Feu el contrast amb t.test(..., mu = 75).
# c) Mireu el p-valor: rebutgem H0 (alfa = 0,05)?
# d) És coherent amb l'interval de confiança del pas 5? Per què?

# H0:
# H1:

# TODO

# Resposta:



# ---- Repte (opcional) ------------------------------------------------------------------------
# La nota mitjana de català, és diferent en centres públics i privats?
# Pista: afegiu group_by(titularitat) abans d'un summarise()
# (Ho treballarem a la sessió 3.)
#
# Ja ho teniu tot? Mireu els temes d'ampliació de la web de la sessió 2.

# TODO
