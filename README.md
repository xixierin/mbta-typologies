# MBTA Communities Station Area Typologies

Interactive web visualization for the thesis *Beyond Density: VMT-Informed Implementation of the MBTA Communities Act*.

**Live site:** https://[your-github-username].github.io/mbta-typologies/

## About

Ward hierarchical clustering (k=6) on 169 MBTA Communities station areas using:
- Activity intensity (housing + job density composite)
- Job mix
- Land use entropy
- Peak transit frequency

Clusters are visualized on a Mapbox map with 0.5-mile TOD buffer polygons, a 3D PCA scatter plot (Plotly.js), and a methodology reference.

## Setup

1. Add your Mapbox public token to `docs/index.html` → `const MAPBOX_TOKEN = '...'`
2. Optionally add a Google Street View Static API key to `const GOOGLE_SV_KEY = '...'`

## Data

Static data files in `docs/data/` are exported from the thesis R pipeline via `_data_processing/export_web_data.R`.  
Re-run that script to regenerate `stations.json` and `buffers.geojson` after any analysis updates.

## Deployment

GitHub Pages serves from the `docs/` folder on the `main` branch.  
Settings → Pages → Source: `main` / `docs`.
