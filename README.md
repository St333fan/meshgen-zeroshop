# Overview
ZeroShop meshing pipeline, submodules can be used idependently or with docker-compose

- Grounding-SAM-2 creates from a video 20 object images
- MASt3R registeres these images two times: Surface, Segmentation
- SVRaster: 

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
## Grounded-SAM-2
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
## MASt3R
Download the weights (First Setup)
```bash
mkdir -p registration/mast3r-zeroshop/checkpoints/
wget https://download.europe.naverlabs.com/ComputerVision/MASt3R/MASt3R_ViTLarge_BaseDecoder_512_catmlpdpt_metric.pth -P registration/mast3r-zeroshop/checkpoints/
wget https://download.europe.naverlabs.com/ComputerVision/MASt3R/MASt3R_ViTLarge_BaseDecoder_512_catmlpdpt_metric_retrieval_trainingfree.pth -P registration/mast3r-zeroshop/checkpoints/
wget https://download.europe.naverlabs.com/ComputerVision/MASt3R/MASt3R_ViTLarge_BaseDecoder_512_catmlpdpt_metric_retrieval_codebook.pkl -P registration/mast3r-zeroshop/checkpoints/
```

Check the settings 
```bash
# what commands do you want to run? probably remove height estimation
## look also into the bash scripts if they do what you want 
### segmented and surface? or just one of those
docker-compose/mast3r.yml
```

```bash
# Start Docker Manual
docker-compose -f docker-compose/mast3r.yml up # --build # add if rebuild needed
docker-compose -f docker-compose/mast3r.yml down
```

## VGGT

## 2DGS

## SVRASTER



