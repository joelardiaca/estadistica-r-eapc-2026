# =============================================================================
# Crea el zip de materials de cada sessió (sessio-N/materials-sessio-N.zip)
# -----------------------------------------------------------------------------
# S'executa des de l'arrel del repositori, abans de `quarto render`:
#   Rscript _scripts/crear_materials.R
#
# Cada zip conté la carpeta sessio-N/ amb el projecte (.Rproj), dades/ i codi/,
# sense els fitxers d'ús intern del professor. Les solucions només s'hi
# inclouen quan la sessió apareix a `sessions_amb_solucio` (després de la sessió).
# =============================================================================

library(zip)

sessions_amb_solucio <- c()   # p. ex. c(1) un cop feta la sessió 1

# Fitxers que (de moment) no es publiquen
no_publicar <- c("02_importar_netejar.R")

for (sessio in list.files(".", pattern = "^sessio-[0-9]+$")) {
  n <- sub("sessio-", "", sessio)

  fitxers <- c(
    list.files(sessio, pattern = "[.]Rproj$", full.names = TRUE),
    list.files(file.path(sessio, "dades"), full.names = TRUE),
    list.files(file.path(sessio, "codi"),  full.names = TRUE)
  )

  # Mai: preparació interna de les dades ni fitxers generats per l'alumnat
  fitxers <- fitxers[!grepl("^00_", basename(fitxers))]
  fitxers <- fitxers[!grepl("_net[.]csv$", basename(fitxers))]
  fitxers <- fitxers[!basename(fitxers) %in% no_publicar]

  # Solucions: només un cop feta la sessió
  if (!(as.integer(n) %in% sessions_amb_solucio)) {
    fitxers <- fitxers[!grepl("^solucio_", basename(fitxers))]
  }

  if (length(fitxers) == 0) next

  desti <- file.path(sessio, paste0("materials-", sessio, ".zip"))
  if (file.exists(desti)) file.remove(desti)
  zip::zip(desti, files = fitxers, mode = "mirror")

  cat(desti, ":\n", paste("  ", fitxers, collapse = "\n"), "\n", sep = "")
}
