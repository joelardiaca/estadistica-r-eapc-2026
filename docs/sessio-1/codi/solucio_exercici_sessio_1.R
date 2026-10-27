# =============================================================================
# SOLUCIÓ - EXERCICI SESSIÓ 1 - Importar, netejar i exportar unes dades
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# =============================================================================


# ---- Pas 1. Carregar el tidyverse i importar les dades ----------------------------

library(tidyverse)

competencies <- read_csv2("dades/competencies_basiques.csv")


# ---- Pas 2. Primer cop d'ull ----------------------------------------------------------

glimpse(competencies)

# - 500 files (alumnes) i 9 columnes (variables).
# - Numèriques (<dbl>): CODI_ALUMNE, PCAT, PMAT, PANG, ANY_NAIXEMENT.
#   Text (<chr>): GENERE, NATURALESA, HABITAT, AREA_TERRITORIAL.
# - Quantitatives: PCAT, PMAT, PANG (contínues) i ANY_NAIXEMENT (discreta).
#   Categòriques nominals: GENERE, NATURALESA, AREA_TERRITORIAL.
#   Categòrica ordinal: HABITAT (mida del municipi).
#   CODI_ALUMNE és numèric però NO és una variable quantitativa: és un identificador.


# ---- Passos 3 a 8 ----------------------------------------------------------------------
# Es poden fer per separat o tot encadenat amb |>. Aquí ho fem encadenat.

competencies_net <- competencies |>
  # Pas 3: seleccionar
  select(CODI_ALUMNE, GENERE, NATURALESA, HABITAT, PCAT, PMAT, PANG) |>
  # Pas 4: reanomenar
  rename(
    id          = CODI_ALUMNE,
    genere      = GENERE,
    titularitat = NATURALESA,
    habitat     = HABITAT,
    nota_cat    = PCAT,
    nota_mat    = PMAT,
    nota_ang    = PANG
  ) |>
  mutate(
    # Pas 5: recodificar el gènere
    genere = case_when(
      genere == "D" ~ "Dona",
      genere == "H" ~ "Home"
    ),
    # Pas 6: ordenar l'hàbitat
    habitat = factor(habitat,
                     levels = c("Fins a 10000", "De 10001 a 100000", "Més de 100000")),
    # Pas 7a: nota mitjana (serà NA si falta alguna de les tres notes)
    nota_mitjana = (nota_cat + nota_mat + nota_ang) / 3,
    # Pas 7b: nivell de matemàtiques
    nivell_mat = case_when(
      nota_mat < 50  ~ "Baix",
      nota_mat < 75  ~ "Mitjà",
      nota_mat >= 75 ~ "Alt"
    )
  ) |>
  # Pas 8: eliminar els alumnes sense nota de matemàtiques
  filter(!is.na(nota_mat))

glimpse(competencies_net)   # queden 480 alumnes

# Comprovacions
competencies_net |> count(genere)
competencies_net |> count(habitat)
competencies_net |> count(nivell_mat)


# ---- Pas 9. Una limitació de les dades ---------------------------------------------------
# Possibles respostes:
# - Els alumnes sense nota poden no ser a l'atzar (absents el dia de la prova,
#   alumnes amb necessitats educatives...): eliminar-los pot esbiaixar els resultats.
# - És una mostra de 500 alumnes: les conclusions sobre tot Catalunya tindran
#   un marge d'error (ho veurem a la sessió 2).
# - Una prova d'un sol dia mesura el rendiment en aquell moment concret,
#   no tot el que l'alumne sap.
# - La nota mitjana és NA si falta alguna de les tres notes.


# ---- Pas 10. Exportar -------------------------------------------------------------------------

write_csv2(competencies_net, "dades/competencies_basiques_net.csv")
