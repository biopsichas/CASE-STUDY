# CASE-STUDY

Case study data and execution scripts for the SWAT+ modeling workflow. Each partner/case study gets its own folder (e.g. `PL/`) containing the local data and the scripts needed to run the shared workflow engine.

This repository is designed to be used **side by side** with [`SWAT-Workflow-R`](https://github.com/biopsichas/SWAT-Workflow-R), which holds the core, version-controlled R workflow and tools. Keeping the two repositories separate means:

- the core workflow (`SWAT-Workflow-R`) stays clean, isolated, and centrally maintained, with no local installations required, and
- each case study keeps only its own data and modified scripts, so changes are easy to track and problems are easy to reproduce.

## Repository structure

```
CASE-STUDY/
└── PL/
    └── 1_Setup/
        ├── run.bat            # launches the isolated workflow environment
        ├── settings.R         # case-study specific paths and parameters
        ├── setup_workflow.R   # main workflow script (sourced by run.bat)
        └── Data/
            ├── for_buildr/         # DEM, soil, land use, river/basin layers for SWATbuildR
            ├── for_farmr_input/    # crop map and management tables for SWATfarmR input prep
            └── for_prepr/          # weather and point-source data for SWATprepR
```

New case studies are added simply by creating a new top-level folder (following the same layout as `PL/`).

## Prerequisites

1. **Clone both repositories into the same parent directory**, so they sit side by side:

   ```
   your-projects-folder/
   ├── CASE-STUDY/
   └── SWAT-Workflow-R/
   ```

   ```bash
   git clone https://github.com/biopsichas/CASE-STUDY.git
   git clone https://github.com/biopsichas/SWAT-Workflow-R.git
   ```

   The scripts in this repository locate the engine using a relative path (`../../../SWAT-Workflow-R`), so this folder layout is required.

2. **Install Git LFS.** Large raster and vector files (`.tif`, `.shp`, `.dbf`, `.rds`) are tracked with [Git LFS](https://git-lfs.com/) (see `.gitattributes`). After installing it, run:

   ```bash
   git lfs install
   git lfs pull
   ```

   in this repository to fetch the actual file contents. The tracking rules are already set in `.gitattributes`, but for reference, they were set up with:

   ```bash
   git lfs track "*.tif"
   git lfs track "*.shp"
   git lfs track "*.dbf"
   git lfs track "*.rds"
   ```

   If you add a new data type that should also be tracked by LFS, run the relevant `git lfs track` command before committing, then commit the updated `.gitattributes` file.

## Running a case study

1. Open the relevant case study folder, e.g. `PL/1_Setup`.
2. Check/adjust `settings.R` for paths, simulation period, and other case-study parameters.
3. Double-click `run.bat` (or run it via CMD).

`run.bat` will:

- verify that the portable R/RStudio engine exists in the adjacent `SWAT-Workflow-R` folder and that its version matches what's expected,
- set up the environment variables (`R_HOME`, `PATH`, `RENV_PATHS_LIBRARY`, spatial library paths, etc.) so the case study uses the shared, isolated R/RStudio installation with no local installs needed,
- launch RStudio and open `setup_workflow.R`, which runs the full model setup workflow (SWATbuildR, weather/atmospheric deposition, SWATfarmR management input, calibration file handling, etc.).

Results and intermediate outputs are written back into the case study's own folder (`Temp_` and subfolders), keeping the shared engine untouched.

## Adding a new case study

1. Create a new top-level folder named for the case study (e.g. `DE/`, `SI/`).
2. Copy the structure of an existing case study folder (`run.bat`, `settings.R`, `setup_workflow.R`, `Data/`).
3. Update `settings.R` with the new case study's paths and parameters, and place the corresponding input data under `Data/`.

## Data size guidelines

GitHub only allows files under 50 MB without Git LFS, and LFS storage/bandwidth is shared and limited. To keep the repository usable for everyone:

- Compress rasters where possible and use appropriate data types (e.g. avoid unnecessary 64-bit float rasters).
- Keep vector attribute tables lean; avoid pushing redundant or unused fields.
- Avoid pushing intermediate/temporary outputs — see `.gitignore` for folders/files that are already excluded (`Temp*`, `simulation/`, `backup/`, etc.).
- If in doubt about a large dataset, ask before pushing it.

## Related repositories

- [`SWAT-Workflow-R`](https://github.com/biopsichas/SWAT-Workflow-R) — the core, shared R workflow and tools engine used by all case studies.
