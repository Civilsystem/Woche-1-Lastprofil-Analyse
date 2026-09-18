# ==============================================================================
# WOCHE 1: Analyse von Strom-Lastprofilen (Stadtwerke-Praxis)
# ==============================================================================

library(tidyverse)
library(lubridate) # Für einfaches Arbeiten mit Datum und Uhrzeiten

set.seed(123)

# Erzeugung eines Jahres-Lastprofils (8.760 Stunden für das Jahr 2026)
zeitraum <- seq(
  from = as.POSIXct("2026-01-01 00:00:00"),
  to = as.POSIXct("2026-12-31 23:00:00"),
  by = "1 hour"
)

# Simulation typischer Haushalts-Verbrauchsmuster in kWh
lastprofil_daten <- tibble(
  zeitstempel = zeitraum,
  monat = month(zeitstempel, label = TRUE, abbr = FALSE, locale = "de_DE.utf8"),
  wochtentag = wday(zeitstempel, label = TRUE, abbr = TRUE, locale = "de_DE.utf8"),
  stunde = hour(zeitstempel),
  
  # Basisverbrauch + Tagesschwankung (Spitzen morgens & abends) + Wintersatzzuschlag
  verbrauch_kwh = round(
    0.5 +
      sin((stunde - 3) * pi / 6)^2 * 1.2 +
      ifelse(month(zeitstempel) %in% c(11, 12, 1,2), 0.4, 0) +
      rnorm(length(zeitraum), mean = 0, sd = 0.15),
    2
  )
)

# Erste Einsicht in die Daten
glimpse(lastprofil_daten)


# Lösung für Schritt 2: Durchschnittlichen Stromverbrauch pro Stunde berechnen
durchschnitt_pro_stunde <- lastprofil_daten %>%
  group_by(stunde) %>%
  summarise(mittelwert_kwh = mean(verbrauch_kwh))

# Ergebnisse in der Konsole anzeigen
print(durchschnitt_pro_stunde)


ggplot(data = durchschnitt_pro_stunde, aes(x = stunde, y = mittelwert_kwh)) +
  geom_line(color = "#2a9d8f", linewidth = 1.2) +
  labs(
    title = "Typisches Standardlastprofil (Haushalt)",
    x = "Uhrzeit (Stunde)",
    y = "Durchschnittsverbrauch (kWh)"
  ) +
  theme_minimal()

# Anpassung der Verbrauchsformel für 2 reale Peaks (Morgen & Abend)
lastprofil_daten <- tibble(
  zeitstempel = zeitraum,
  monat = month(zeitstempel, label = TRUE, abbr = FALSE, locale = "de_DE.utf8"),
  wochentag = wday(zeitstempel, label = TRUE, abbr = TRUE, locale = "de_DE.utf8"),
  stunde = hour(zeitstempel),
  
  # Zwei Wellen über 24 Stunden verteilt (sin((stunde - 3) * pi / 6) -> pi/6 sorgt für 12h-Rhythmus)
  verbrauch_kwh = round(
    0.5 + 
      sin((stunde - 2) * pi / 6)^2 * 1.2 + 
      ifelse(month(zeitstempel) %in% c(11, 12, 1, 2), 0.4, 0) + 
      rnorm(length(zeitraum), mean = 0, sd = 0.15), 
    2
  )
)

vergleich_sommer_winter <- lastprofil_daten %>% 
  filter(monat %in% c("Januar", "Juli")) %>% 
  group_by(monat, stunde) %>% 
  summarise(mittelwert_kwh = mean(verbrauch_kwh))

ggplot(vergleich_sommer_winter, aes(x = stunde, y = mittelwert_kwh, color = monat)) +
  geom_line(linewidth = 1.2) +
  labs(
    title = "Saisonaler Vergleich: Winter (Januar) vs. Sommer (Juli)",
    x = "Uhrzeit (Stunde)",
    y = "Durchschnittsverbrauch (kWh)",
    color = "Monat"
  ) +
  theme_minimal()

# 1. Erst den täglichen Gesamtverbrauch berechnen
tagesverbrauch <- lastprofil_daten %>% 
  mutate(datum = as.Date(zeitstempel)) %>% 
  group_by(datum, wochentag) %>% 
  summarise(tages_gesamt_kwh = sum(verbrauch_kwh)) %>% 
  ungroup()

# 2. Durchschnitte nach Wochentag auswerten
wochentag_analyse <- tagesverbrauch %>% 
  group_by(wochentag) %>% 
  summarise(mittelwert_tagesverbrauch = mean(tages_gesamt_kwh))

print(wochentag_analyse)