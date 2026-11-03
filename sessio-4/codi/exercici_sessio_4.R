# =============================================================================
# EXERCICI SESSIÓ 4 - Correlació i regressió lineal
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# -----------------------------------------------------------------------------
# Nom i cognoms:
#
# DADES: dades/competencies.csv
#   Les mateixes dades netes de les sessions 2 i 3 (480 alumnes de 6è). Cada
#   fila és un alumne.
#     id                            identificador anònim de l'alumne
#     genere                        Dona / Home
#     titularitat                   titularitat del centre (Públic / Privat)
#     habitat                       mida del municipi del centre
#     nota_cat, nota_mat, nota_ang  puntuació (0-100) en català, matemàtiques i anglès
#     nota_mitjana                  mitjana de les tres notes
#     nivell_mat                    nivell de matemàtiques: Baix / Mitjà / Alt
#
# COM FUNCIONA:
#   - El codi NOU (gràfics, lm(), summary(), predict(), cor.test()) ja hi és:
#     executeu-lo i INTERPRETEU-NE el resultat.
#   - El que ja sabeu fer (filter, summarise, group_by...) l'escriviu vosaltres
#     on diu "TODO".
#
# QUÈ CAL FER:
#   Pas 1. Importar les dades (JA FET: només cal executar-lo).
#   PART A. Correlació
#     Pas 2. Gràfic de dispersió de la nota de català i la d'anglès.
#     Pas 3. Correlació entre la nota de català i la d'anglès.
#     Pas 4. Les tres parelles d'assignatures: quina relació és més forta?
#     Pas 5. La correlació, és igual per a nois i noies? I per titularitat?
#   PART B. Regressió lineal
#     Pas 6. Model: la nota d'anglès segons la de català.
#     Pas 7. Prediccions.
#     Pas 8. Una variable explicativa categòrica: la titularitat.
#     Pas 9. La correlació, és significativa?
#   OPCIONAL (si us sobra temps):
#     Opcional 1. Anàlisi de les seccions censals (amb menys pistes).
#     Opcional 2. Tutorial de gràfics de dispersió amb ggplot2 (a la web).
#
# Comenteu i interpreteu cada resultat EN PARAULES, amb comentaris (#).
#
# QUÈ CAL LLIURAR:
#   - Aquest script (.R) complet i comentat (parts A i B; l'opcional, si l'heu fet).
#   Per correu electrònic a joelardiacaarnau@gencat.cat
#
# Consells:
#   - Obriu el projecte sessio_4.Rproj (no aquest fitxer directament) i
#     comproveu amb getwd() que R és a la carpeta sessio-4.
#   - Executeu línia a línia (Ctrl + Enter) i mireu el resultat de cada pas.
#   - Teniu tot el codi que cal a codi/01_correlacio_regressio.R i a les slides.
# =============================================================================


# ---- Pas 1. Importar les dades (JA FET: només cal executar-lo) -------------------------

library(tidyverse)

competencies <- read_csv2("dades/competencies.csv") |>
  mutate(habitat    = factor(habitat,
                             levels = c("Fins a 10000", "De 10001 a 100000", "Més de 100000")),
         nivell_mat = factor(nivell_mat, levels = c("Baix", "Mitjà", "Alt")))

glimpse(competencies)   # han de sortir 480 files


# =============================================================================
# PART A. CORRELACIÓ
# =============================================================================
# Pregunta: els alumnes que treuen bona nota de català, també en treuen
# d'anglès?

# ---- Pas 2. Gràfic de dispersió (JA FET: executeu-lo i interpreteu-lo) -----------------
# La nota de català a l'eix X i la d'anglès a l'eix Y, amb la recta de regressió.
# (R avisarà que ha tret uns quants alumnes sense nota: no és cap error.)

ggplot(competencies, aes(x = nota_cat, y = nota_ang)) +
  geom_point() +
  geom_smooth(method = "lm")

# Responeu: la relació és positiva o negativa? Sembla forta o feble?
#           Hi veieu algun alumne "estrany"?

# Resposta:



# ---- Pas 3. Correlació entre català i anglès (JA FET) -----------------------------------
# Primer traiem els alumnes sense nota (NA) i després calculem la correlació.

competencies |>
  filter(!is.na(nota_cat), !is.na(nota_ang)) |>
  summarise(r = cor(nota_cat, nota_ang))

# Responeu: com és la relació (direcció i força)? Feu servir la taula de les
# slides per dir si és feble, moderada o forta.

# Resposta:



# ---- Pas 4. Les tres parelles d'assignatures ----------------------------------------------
# Ara vosaltres: calculeu la correlació entre català i matemàtiques, i entre
# matemàtiques i anglès. Copieu el pas 3 i canvieu-hi les variables (compte a
# treure els NA de les variables que feu servir).
# Responeu: quina és la relació més forta? I la més feble?

# TODO

# Resposta:



# ---- Pas 5. La correlació per grups ---------------------------------------------------------
# La correlació entre català i anglès, és igual per a nois i noies?
# Pista: copieu el pas 3 i afegiu-hi group_by(genere) abans del summarise().
#        Afegiu també n = n() per saber quants alumnes hi ha a cada grup.
# Després, feu el mateix per titularitat.

# TODO

# Resposta:



# =============================================================================
# PART B. REGRESSIÓ LINEAL
# =============================================================================

# ---- Pas 6. Model: la nota d'anglès segons la de català (JA FET) ---------------------------
# Ajustem el model, el guardem a l'objecte "model" i en mirem el resum.

model <- lm(nota_ang ~ nota_cat, data = competencies)
summary(model)

# Responeu, mirant el summary():
#   a) El pendent (Estimate de nota_cat): quant augmenta, de mitjana, la nota
#      d'anglès per cada punt més de català?
#   b) L'intercept (Estimate de (Intercept)): què vol dir? Té sentit aquí?
#   c) El p-valor del pendent (Pr(>|t|) de nota_cat): la relació és significativa?
#   d) El R² (Multiple R-squared): quin percentatge de la variació de la nota
#      d'anglès explica la de català?

# Resposta:



# ---- Pas 7. Prediccions (JA FET) -------------------------------------------------------------
# La nota d'anglès esperada per a un alumne amb un 50 i un 90 de català.

predict(model, newdata = tibble(nota_cat = c(50, 90)))

# Responeu: quines notes d'anglès esperem? Té sentit predir la nota d'anglès
#           amb un 0 de català? Per què?
# Pista: calculeu quina és la nota de català més baixa de les dades amb
#        summarise() i min() (compte amb els NA!).

# TODO

# Resposta:



# ---- Pas 8. Una variable explicativa categòrica: la titularitat ------------------------------
# a) El model de la nota de matemàtiques segons la titularitat (JA FET):

lm(nota_mat ~ titularitat, data = competencies)

# b) Ara vosaltres: calculeu la nota mitjana de matemàtiques per titularitat
#    amb group_by() i summarise() (com a la sessió 3).
# Responeu: què vol dir el coeficient de titularitatPúblic? I l'intercept?
#           Fixeu-vos: el coeficient us dona DIRECTAMENT la diferència de
#           mitjanes, sense haver-la de calcular a mà.

# TODO

# Resposta:



# ---- Pas 9. La correlació, és significativa? (JA FET) ----------------------------------------
# H0: a la població (tots els alumnes de 6è), no hi ha correlació entre la
#     nota de català i la d'anglès.

cor.test(competencies$nota_cat, competencies$nota_ang)

# Responeu:
#   a) El p-valor (p-value): rebutgem H0?
#   b) L'interval de confiança del 95 % (95 percent confidence interval):
#      entre quins valors és la correlació a tots els alumnes de 6è?

# Resposta:



# =============================================================================
# OPCIONAL 1. ANÀLISI DE LES SECCIONS CENSALS
# =============================================================================
# Ara, amb unes altres dades i menys pistes: tot el que hem fet al curs.
#
# Dades: dades/seccions_censals.csv (eleccions al Parlament del 2021)
#   1.469 seccions censals de Badalona, Barcelona, Girona i L'Hospitalet
#     seccio           codi de la secció censal
#     municipi         Badalona, Barcelona, Girona o L'Hospitalet
#     abstencio        % d'abstenció
#     perc_atur        % de població aturada
#     perc_estrangers  % de població estrangera
#     renda_persona    renda neta per persona (euros l'any)
#
# Preparació: importeu les dades i creeu una variable amb la renda en milers
# d'euros (així els coeficients són més fàcils de llegir):
#   mutate(renda_milers = renda_persona / 1000)

# TODO


# ---- a) Descriure ----------------------------------------------------------------------
# Per a cada municipi: nombre de seccions i abstenció, atur i renda mitjanes,
# ordenat de més a menys abstenció.
# Responeu: quin municipi s'absté més? I quin té més renda?

# TODO

# Resposta:


# ---- b) Correlacions ---------------------------------------------------------------------
# Amb totes les seccions: la correlació de l'abstenció amb l'atur, amb el % de
# població estrangera i amb la renda (en un sol summarise()).
# Responeu: amb quina variable està més relacionada l'abstenció? En quin sentit?

# TODO

# Resposta:


# ---- c) Per municipi -----------------------------------------------------------------------
# La correlació entre la renda i l'abstenció, per a cada municipi.
# Responeu: la relació és igual als quatre municipis?

# TODO

# Resposta:


# ---- d) Regressió simple -------------------------------------------------------------------
# Gràfic de dispersió i model de l'abstenció segons la renda en milers.
# Responeu: quant baixa l'abstenció per cada 1.000 euros més de renda? Quant
# explica el model? Quina abstenció esperem en una secció amb una renda de
# 15.000 euros per persona? I de 25.000?

# TODO

# Resposta:


# ---- e) Una X categòrica: Badalona i Girona -------------------------------------------------
# Quedeu-vos amb les seccions de Badalona i Girona i compareu-ne l'abstenció:
#   - amb un model: lm(abstencio ~ municipi, data = ...)
#   - amb un t-test (sessió 3): t.test(abstencio ~ municipi, data = ...)
# Responeu: quina diferència d'abstenció hi ha? És significativa? Els dos
# mètodes, diuen el mateix?

# TODO

# Resposta:


# ---- f) Regressió múltiple ------------------------------------------------------------------
# Amb totes les seccions:
#   - model 1: l'abstenció segons l'atur
#   - model 2: l'abstenció segons l'atur I la renda en milers
# Responeu: el coeficient de l'atur, canvia quan afegim la renda? Per què
# creieu que passa? I el R²?

# TODO

# Resposta:


# ---- g) Conclusions ---------------------------------------------------------------------------
# En 4 o 5 frases: què hem après de l'abstenció a aquests municipis? I quines
# limitacions té l'anàlisi (correlació i causalitat, dades per secció i no
# per persona...)?

# Conclusions:



# =============================================================================
# OPCIONAL 2. GRÀFICS
# =============================================================================
# Seguiu el tutorial de gràfics de dispersió amb ggplot2 de la web de la sessió 4.
