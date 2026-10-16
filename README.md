# Introducció a l'estadística amb R · EAPC 2026

Materials del curs **«Introducció a l'estadística amb R»** de l'[Escola d'Administració Pública de Catalunya](https://eapc.gencat.cat) (octubre – novembre de 2026), impartit per Joel Ardiaca (Centre d'Estudis d'Opinió).

**Web del curs: <https://joelardiaca.github.io/estadistica-r-eapc-2026/>**

## Estructura

```
├── index.qmd, abans-de-comencar.qmd, recursos.qmd   Pàgines del web
├── sessio-N/
│   ├── index.qmd                 Pàgina de la sessió
│   ├── slides/                   Slides (Quarto revealjs)
│   ├── dades/                    Dades de la sessió
│   ├── codi/                     Scripts d'R i exercici
│   └── materials-sessio-N.zip    Materials per descarregar (generat)
├── assets/                       Tema (colors EAPC) i imatges compartides
├── _scripts/crear_materials.R    Genera els zip de materials
├── _freeze/                      Resultats del codi R desats per Quarto
└── docs/                         Web generat (GitHub Pages)
```

## Com actualitzar el web

Cal tenir [R](https://cran.r-project.org) (amb `tidyverse` i `zip`) i [Quarto](https://quarto.org).

```bash
Rscript _scripts/crear_materials.R   # 1. regenera els zip de materials
quarto render                        # 2. genera el web a docs/
git add -A && git commit -m "..."    # 3. desa els canvis
git push                             # 4. publica
```

Per veure el web en local mentre s'edita: `quarto preview`.

## Llicència

- Textos, slides i materials docents: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.ca).
- Codi: llicència MIT.
- Dades: cada conjunt de dades manté les condicions d'ús de la seva font original (Centre d'Estudis d'Opinió; Departament d'Educació, a través del portal de dades obertes de la Generalitat).

Vegeu [LICENSE.md](LICENSE.md).
