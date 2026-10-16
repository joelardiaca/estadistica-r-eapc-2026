# =============================================================================
# Sessió 1 - Primers passos amb R
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# -----------------------------------------------------------------------------
# Executa cada línia amb Ctrl + Enter i mira què passa a la consola.
# Tot el que va després d'un # és un comentari: R no l'executa.
# =============================================================================


# ---- 1. R com a calculadora --------------------------------------------------

2 + 3
10 / 4
2^3
(5 + 3) * 2


# ---- 2. Objectes: guardar coses amb <- ----------------------------------------
# "<-" vol dir "guarda el que hi ha a la dreta amb el nom de l'esquerra".

edat <- 42
edat
edat + 1

nom <- "Anna"
nom


# ---- 3. Vectors: diversos valors junts amb c() --------------------------------

edats <- c(34, 51, 28, 45, 39)
edats

edats * 12      # l'operació s'aplica a tots els valors


# ---- 4. Funcions: fan una feina a partir d'uns arguments ---------------------
# nom_funcio(argument1, argument2, ...)

mean(edats)     # mitjana
max(edats)      # màxim
length(edats)   # quants valors hi ha
round(3.14159, digits = 2)

# Per veure l'ajuda d'una funció:
?mean


# ---- 5. Tipus de dades ---------------------------------------------------------

# Numèric (variables quantitatives)
notes <- c(7.5, 6, 9.2)
class(notes)

# Text / character
municipis <- c("Girona", "Lleida", "Tarragona")
class(municipis)

# Lògic: TRUE o FALSE
majors_40 <- edats > 40
majors_40
class(majors_40)

# Factor (variables categòriques). Les categories tenen un ordre definit.
satisfaccio <- factor(c("Poc", "Molt", "Bastant", "Poc"),
                      levels = c("Gens", "Poc", "Bastant", "Molt"))
satisfaccio
levels(satisfaccio)

# NA: valor perdut (Not Available)
ingressos <- c(1500, NA, 2100)
mean(ingressos)                 # NA: no es pot calcular amb valors perduts
mean(ingressos, na.rm = TRUE)   # ignorant els NA


# ---- 6. Paquets ------------------------------------------------------------------
# Un paquet afegeix funcions noves a R.
# S'instal·la UNA vegada a l'ordinador i es carrega CADA vegada que obrim R.

# install.packages("tidyverse")   # només la primera vegada
library(tidyverse)


# ---- 7. Taules de dades (data frames / tibbles) ---------------------------------
# Cada fila és una unitat d'anàlisi i cada columna és una variable.

persones <- tibble(
  nom      = c("Anna", "Pau", "Marta", "Jordi", "Laia"),
  edat     = c(34, 51, 28, 45, 39),
  sexe     = c("D", "H", "D", "H", "D"),
  comarca  = c("Gironès", "Segrià", "Barcelonès", "Tarragonès", "Barcelonès"),
  sou      = c(2100, 2800, NA, 2500, 1900)
)

persones
glimpse(persones)
persones$edat         # amb $ accedim a una columna


# ---- 8. Tidyverse: les funcions principals ----------------------------------------
# El pipe |> es llegeix "i després": agafa el resultat de l'esquerra
# i el passa a la funció de la dreta.

# select(): triar columnes
persones |>
  select(nom, edat)

# filter(): triar files que compleixen una condició
persones |>
  filter(edat > 35)

persones |>
  filter(comarca == "Barcelonès", edat < 35)

# rename(): canviar el nom de columnes  (nom_nou = nom_antic)
persones |>
  rename(salari = sou)

# mutate(): crear o modificar columnes
persones |>
  mutate(sou_anual = sou * 14)

# mutate() + case_when(): recodificar
persones |>
  mutate(sexe = case_when(
    sexe == "D" ~ "Dona",
    sexe == "H" ~ "Home"
  ))

persones |>
  mutate(grup_edat = case_when(
    edat < 35 ~ "Menys de 35",
    edat >= 35 ~ "35 o més"
  ))

# Tot junt, encadenat amb |>
persones_net <- persones |>
  select(nom, edat, sexe, sou) |>
  rename(salari = sou) |>
  mutate(sexe = case_when(sexe == "D" ~ "Dona",
                          sexe == "H" ~ "Home")) |>
  filter(!is.na(salari))

persones_net


# ---- 9. El teu torn ----------------------------------------------------------------
# A partir de la taula "persones":
#   1. Queda't amb les persones de 30 anys o més.
#   2. Crea una columna "sou_anual" (sou * 14).
#   3. Queda't només amb les columnes nom i sou_anual.

persones |>
  filter(   ) |>
  mutate(   ) |>
  select(   )
