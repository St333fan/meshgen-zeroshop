# Overview
ZeroShop meshing pipeline
- 


# Setup
```bash
# Build dataset structure
dataset
└── ycbv_real_subset
    └── obj_000001
        ├── PXL_20251009_114058863.mp4
        └── scene
            └── images
                ├── PXL_20251009_114017647.jpg
                ├── PXL_20251009_114023775.jpg
                ├── PXL_20251009_114031268.jpg
                └── PXL_20251009_114039378.jpg
```

```bash
# change in the commands to your dataset
docker-compose/grounded-sam2.yml
```
## Grounding-SAM-2
```bash
# Download the weights (First Setup)
cd segmentation/Grounded-SAM-2-zeroshop/checkpoints
bash download_ckpts.sh

cd segmentation/Grounded-SAM-2-zeroshop/gdino_checkpoints
bash download_ckpts.sh

# Start Docker Manual
xhost local:docker
docker-compose -f docker-compose/grounded-sam2.yml up # --build # add if rebuild
docker-compose -f docker-compose/grounded-sam2.yml down
```
## MASt3R

## VGGT

## 2DGS

## SVRASTER



