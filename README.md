# Overview
ZeroShop meshing pipeline
- 


# Setup
Clone the git, then init submodules
```bash
git submodule update --init --recursive
```

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
```

```bash
# Start Docker Manual
xhost local:docker
docker-compose -f docker-compose/grounded-sam2.yml up # --build # add if rebuild
docker-compose -f docker-compose/grounded-sam2.yml down
```
## MASt3rR
```bash
# Download the weights (First Setup)
mkdir -p registration/mast3r-zeroshop/checkpoints/
wget https://download.europe.naverlabs.com/ComputerVision/MASt3R/MASt3R_ViTLarge_BaseDecoder_512_catmlpdpt_metric.pth -P registration/mast3r-zeroshop/checkpoints/
wget https://download.europe.naverlabs.com/ComputerVision/MASt3R/MASt3R_ViTLarge_BaseDecoder_512_catmlpdpt_metric_retrieval_trainingfree.pth -P registration/mast3r-zeroshop/checkpoints/
wget https://download.europe.naverlabs.com/ComputerVision/MASt3R/MASt3R_ViTLarge_BaseDecoder_512_catmlpdpt_metric_retrieval_codebook.pkl -P registration/mast3r-zeroshop/checkpoints/
```

```bash
# Start Docker Manual
docker-compose -f docker-compose/mast3r.yml up # --build # add if rebuild
docker-compose -f docker-compose/mast3r.yml down
```

## VGGT

## 2DGS

## SVRASTER



