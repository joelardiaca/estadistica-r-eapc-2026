# =============================================================================
# EXERCICI SESSIÓ 1 - Importar, netejar i exportar unes dades
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# -----------------------------------------------------------------------------
# Nom i cognoms:
#
# DADES: dades/competencies_basiques.csv
#   Mostra de 500 alumnes de l'avaluació de competències bàsiques de
#   6è de primària (2023). Cada fila és un alumne.
#     CODI_ALUMNE       identificador anònim de l'alumne
#     PCAT, PMAT, PANG  puntuació (0-100) en català, matemàtiques i anglès
#     GENERE            D = dona, H = home
#     ANY_NAIXEMENT     any de naixement
#     NATURALESA        titularitat del centre (Públic / Privat)
#     HABITAT           mida del municipi del centre
#     AREA_TERRITORIAL  àrea territorial del Departament d'Educació
#
# QUÈ CAL FER (10 passos):
#    1. Carregar el tidyverse i importar les dades amb read_csv2().
#    2. Mirar les dades amb glimpse() i respondre en un comentari.
#    3. select(): quedar-se amb les columnes que necessitem.
#    4. rename(): posar noms clars en minúscules.
#    5. mutate() + case_when(): recodificar el gènere.
#    6. mutate() + factor(): ordenar les categories de l'hàbitat.
#    7. mutate(): crear la nota mitjana i un nivell de matemàtiques.
#    8. filter(): eliminar els alumnes sense nota de matemàtiques.
#    9. Escriure en un comentari una limitació d'aquestes dades.
#   10. Exportar les dades netes amb write_csv2().
#
# QUÈ CAL LLIURAR:
#   - Aquest script (.R) complet i comentat.
#   - El fitxer dades/competencies_basiques_net.csv
#   Per correu electrònic a joelardiacaarnau@gencat.cat
#
# Consell: executa línia a línia (Ctrl + Enter) i comprova el resultat de cada
# pas amb glimpse() abans de passar al següent.
# =============================================================================


# ---- Pas 1. Carregar el tidyverse i importar les dades ----------------------------

# TODO



# ---- Pas 2. Primer cop d'ull ----------------------------------------------------------
# Respon aquí:
#   - Quantes files (alumnes) i quantes columnes (variables) hi ha?
#   - Quines variables són numèriques (<dbl>) i quines són text (<chr>)?
#   - Quines variables són quantitatives i quines categòriques?
#     Hi ha alguna categòrica ordinal?

# TODO



# ---- Pas 3. Seleccionar columnes ---------------------------------------------------------
# Queda't amb: CODI_ALUMNE, GENERE, NATURALESA, HABITAT, PCAT, PMAT i PANG
# Guarda el resultat en un objecte nou: competencies_net <- competencies |> ...

# TODO



# ---- Pas 4. Reanomenar ----------------------------------------------------------------------
# Posa noms clars en minúscules. Per exemple:
#   id, genere, titularitat, habitat, nota_cat, nota_mat, nota_ang

# TODO



# ---- Pas 5. Recodificar el gènere -------------------------------------------------------------
# "D" -> "Dona" i "H" -> "Home"

# TODO



# ---- Pas 6. Ordenar les categories de l'hàbitat -----------------------------------------------
# Les categories són "Fins a 10000", "De 10001 a 100000" i "Més de 100000".
# R les ordena alfabèticament: posa-les en ordre de menys a més habitants.

# TODO



# ---- Pas 7. Crear variables noves ---------------------------------------------------------------
# a) nota_mitjana: la mitjana de les tres notes (cat, mat i ang)
# b) nivell_mat: "Baix" (menys de 50), "Mitjà" (de 50 a menys de 75)
#    i "Alt" (75 o més)

# TODO



# ---- Pas 8. Valors perduts -------------------------------------------------------------------------
# Elimina els alumnes que no tenen nota de matemàtiques.
# Quants alumnes queden? (mira-ho amb glimpse())

# TODO



# ---- Pas 9. Una limitació de les dades -------------------------------------------------------------
# Escriu en un comentari una limitació d'aquestes dades o de com s'han recollit.
# (Pensa en: què representa la mostra, què passa amb els alumnes sense nota,
#  què mesura realment una prova d'un sol dia...)

# Resposta:



# ---- Pas 10. Exportar ----------------------------------------------------------------------------------
# Desa les dades netes a "dades/competencies_basiques_net.csv"

# TODO
