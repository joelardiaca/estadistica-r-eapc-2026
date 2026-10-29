# =============================================================================
# Sessió 3 - Estadística bivariada
# Curs "Introducció a l'estadística amb R" - EAPC 2026
# -----------------------------------------------------------------------------
# El codi de les slides, en el mateix ordre:
#   - Secció 1: repàs del que ja sabem fer amb R.
#   - Secció 2: les tres novetats d'avui: count() amb dues variables,
#     arrange() i group_by(). Us serveix de xuleta per a la pràctica.
#   - Secció 3 (opcional): els contrastos de la teoria (chi-quadrat, t-test i
#     ANOVA) amb les nostres dades.
# Executa cada línia amb Ctrl + Enter i mira què passa a la consola.
# =============================================================================


# ---- 0. Preparació -------------------------------------------------------------

# On treballa R? Ha d'acabar en .../sessio-3
# (si no, tanca RStudio i obre el fitxer sessio_3.Rproj)
getwd()

# Carreguem el tidyverse
library(tidyverse)

# Importem les dades (les mateixes dades netes de la sessió 2)...
competencies <- read_csv2("dades/competencies.csv")

# ...i tornem a ordenar les categories (el CSV no guarda l'ordre)
competencies <- competencies |>
  mutate(habitat    = factor(habitat,
                             levels = c("Fins a 10000", "De 10001 a 100000", "Més de 100000")),
         nivell_mat = factor(nivell_mat, levels = c("Baix", "Mitjà", "Alt")))

# Mirem què hi ha
glimpse(competencies)


# ---- 1. Repàs: el que ja sabem fer ------------------------------------------------

# Els verbs: filter(), select(), rename() i mutate()
competencies |>                              # agafa les dades i després...
  filter(titularitat == "Públic") |>         # ...queda't amb els centres públics
  select(genere, nota_cat, nota_mat) |>      # ...tria tres columnes
  rename(sexe = genere) |>                   # ...canvia el nom de genere per sexe
  mutate(nota_mat_10 = nota_mat / 10)        # ...i crea la nota de mates sobre 10

# Resumir: count() i summarise()
competencies |>
  count(nivell_mat)                          # quants alumnes hi ha de cada nivell

competencies |>
  summarise(mitjana = mean(nota_mat),        # nota mitjana de matemàtiques
            mediana = median(nota_mat))      # i nota mediana

# Guardar o només mirar?
# 1. Un canvi que volem CONSERVAR a les dades: sobreescrivim el mateix objecte
competencies <- competencies |>
  rename(nota_global = nota_mitjana)

# 2. Un resultat NOU que volem fer servir després: el guardem amb un altre nom
taula_nivells <- competencies |>
  count(nivell_mat)

taula_nivells                                # per veure'l, escrivim el nom

# 3. Només volem VEURE la resposta: sense <- (no es guarda enlloc)
competencies |>
  summarise(mitjana = mean(nota_mat))

# Verbs i auxiliars junts: mutate() + case_when(), i després count()
competencies |>
  mutate(aprova_mat = case_when(nota_mat >= 50 ~ "Sí",
                                nota_mat <  50 ~ "No")) |>
  count(aprova_mat)


# ---- 2. Novetats: count() amb dues variables, arrange() i group_by() ----------------

# count() amb dues variables: una fila per a cada combinació
# (és la taula de contingència, posada "en vertical")
competencies |>
  count(genere, nivell_mat)

# arrange(): ordenar les files, de menys a més...
competencies |>
  count(genere, nivell_mat) |>
  arrange(n)

# ...o de més a menys, amb desc()
competencies |>
  count(genere, nivell_mat) |>
  arrange(desc(n))

# group_by(): separa les dades en grups (a dalt hi diu "# Groups: genere [2]")
competencies |>
  group_by(genere)

# Percentatges sense group_by(): sobre el TOTAL d'alumnes
competencies |>
  count(genere, nivell_mat) |>
  mutate(pct = n / sum(n) * 100)

# Percentatges amb group_by(): DINS DE CADA GÈNERE
competencies |>
  count(genere, nivell_mat) |>
  group_by(genere) |>
  mutate(pct = n / sum(n) * 100)

# ungroup(): treure els grups quan ja no els necessitem
competencies |>
  count(genere, nivell_mat) |>
  group_by(genere) |>
  mutate(pct_genere = n / sum(n) * 100) |>   # % dins de cada gènere
  ungroup() |>                               # traiem els grups...
  mutate(pct_total = n / sum(n) * 100)       # ...i ara el % és sobre el total

# summarise() sense group_by(): una sola fila
competencies |>
  summarise(n = n(),
            mitjana_mat = mean(nota_mat))

# summarise() amb group_by(): una fila per a cada grup
competencies |>
  group_by(genere) |>
  summarise(n = n(),
            mitjana_mat = mean(nota_mat))

# Diverses variables alhora (compte amb els NA)
competencies |>
  group_by(genere) |>
  summarise(n           = n(),
            mitjana_cat = mean(nota_cat, na.rm = TRUE),
            mitjana_mat = mean(nota_mat),
            mitjana_ang = mean(nota_ang, na.rm = TRUE))

# Dues variables de grup, desagrupat i ordenat de més a menys
competencies |>
  group_by(genere, habitat) |>
  summarise(n = n(),
            mitjana_cat = mean(nota_cat, na.rm = TRUE)) |>
  ungroup() |>
  arrange(desc(mitjana_cat))


# ---- 3. Opcional: les diferències, són significatives? ---------------------------
# Si el p-valor < 0,05, rebutgem H0 (no hi ha relació): la relació és significativa

# Dues categòriques: test chi-quadrat
#   H0: el nivell de matemàtiques no té relació amb el gènere
chisq.test(competencies$genere, competencies$nivell_mat)

# Numèrica i categòrica amb 2 grups: t-test ("nota_mat segons genere")
#   H0: la nota mitjana de matemàtiques és igual per a nois i noies
t.test(nota_mat ~ genere, data = competencies)

# Numèrica i categòrica amb 3 o més grups: ANOVA
#   H0: la nota mitjana de català és igual a tots els hàbitats
model <- aov(nota_cat ~ habitat, data = competencies)
summary(model)

# Aquí p = 0,09 > 0,05: no és significativa. Si ho fos, Tukey ens diria entre
# quins grups hi ha diferències:
TukeyHSD(model)


# Per fer gràfics bivariats: vegeu el tutorial de ggplot2 a la web de la sessió 3
