# Woche 1: Analyse von Strom-Lastprofilen (H0) ⚡

Ein praxisorientiertes Mini-Projekt aus der Energiewirtschaft zur Analyse von Haushalts-Standardlastprofilen.

## Fragestellung
Wie verlaufen die täglichen Verbrauchsspitzen (*Morning Peak* und *Evening Peak*) bei Haushaltskunden und welche Unterschiede zeigen sich im saisonalen Vergleich zwischen **Winter (Januar)** und **Sommer (Juli)**?

## Analyse & Ergebnisse
* **Tagesverlauf:** Typischer Zwei-Höcker-Verlauf mit Verbrauchsspitzen am Morgen und am frühen Abend.
* **Saisonaler Niveaueffekt:** Im Winter liegt der Grundverbrauch durchgehend um ca. $0{,}4\text{ kWh}$ höher als im Sommer.
* **Profiltreue:** Die grundlegende Form der Tageslastkurve bleibt saisonunabhängig stabil.

## Tech Stack
* **R** & **Tidyverse** (`dplyr`, `ggplot2`, `lubridate`)
* **R Markdown** zur PDF-Reporterstellung

## Projektdokumentation
Das vollständige Auswertungsskript befindet sich in [`main.R`](main.R). Der aufbereitete PDF-Bericht liegt als [`dokumentation.pdf`](dokumentation.pdf) vor.
