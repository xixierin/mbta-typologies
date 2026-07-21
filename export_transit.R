library(sf)

BASE_IN  <- "G:/Other computers/My Computer/qc8/Thesis/data"
BASE_OUT <- "G:/Other computers/My Computer/qc8/Thesis/_website/mbta-typologies/docs/data"

# ── Rapid Transit ─────────────────────────────────────────────────────────────
rt <- st_read(file.path(BASE_IN, "Transportation/mbta_rapid_transit/MBTA_ARC.shp"), quiet = TRUE)
cat("RT cols:", paste(names(rt), collapse = ", "), "\n")
cat("RT LINE values:", paste(unique(rt$LINE), collapse = ", "), "\n")

# ── Commuter Rail ─────────────────────────────────────────────────────────────
cr <- st_read(file.path(BASE_IN, "Commuter Rail/MBTA_Commuter_Rail_Lines/MBTA_Commuter_Rail_Lines.shp"), quiet = TRUE)
cat("CR cols:", paste(names(cr), collapse = ", "), "\n")

# ── Bus Routes ────────────────────────────────────────────────────────────────
bus <- st_read(file.path(BASE_IN, "Transportation/mbtabus/mbtabus/MBTABUSROUTES_ARC.shp"), quiet = TRUE)
cat("Bus cols:", paste(names(bus), collapse = ", "), "\n")

# Reproject all to WGS84
rt  <- st_transform(rt,  4326)
cr  <- st_transform(cr,  4326)
bus <- st_transform(bus, 4326)

# ── Keep only useful columns, then write ──────────────────────────────────────
# Rapid transit — keep LINE (line name / colour code)
rt_out <- rt[, c("LINE"), drop = FALSE]
st_write(rt_out, file.path(BASE_OUT, "rapid_transit.geojson"),
         driver = "GeoJSON", delete_dsn = TRUE, quiet = TRUE)
cat("Wrote rapid_transit.geojson\n")

# Commuter Rail — inspect and keep name column
cat("CR unique cols head:\n")
print(head(as.data.frame(cr)[, setdiff(names(cr), "geometry")], 3))

# Use the most descriptive name-like column
cr_cols <- names(cr)
name_col <- cr_cols[!cr_cols %in% "geometry"][1]   # fallback: first non-geom col
if ("LINE_BRNCH" %in% cr_cols) name_col <- "LINE_BRNCH"
if ("LINE"       %in% cr_cols) name_col <- "LINE"

cr_out <- cr[, name_col, drop = FALSE]
names(cr_out)[1] <- "LINE"
st_write(cr_out, file.path(BASE_OUT, "commuter_rail.geojson"),
         driver = "GeoJSON", delete_dsn = TRUE, quiet = TRUE)
cat("Wrote commuter_rail.geojson\n")

# Bus routes — keep route number/name column; dissolve duplicates
cat("Bus unique cols head:\n")
print(head(as.data.frame(bus)[, setdiff(names(bus), "geometry")], 3))

bus_cols <- names(bus)
route_col <- bus_cols[!bus_cols %in% "geometry"][1]
if ("ROUTE"     %in% bus_cols) route_col <- "ROUTE"
if ("ROUTE_ID"  %in% bus_cols) route_col <- "ROUTE_ID"

bus_out <- bus[, route_col, drop = FALSE]
names(bus_out)[1] <- "ROUTE"
bus_out_path <- file.path(BASE_OUT, "bus_lines.geojson")
if (file.exists(bus_out_path)) file.remove(bus_out_path)
st_write(bus_out, bus_out_path, driver = "GeoJSON", quiet = TRUE)
cat("Wrote bus_lines.geojson\n")
