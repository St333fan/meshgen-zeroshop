# Overview
ZeroShop meshing pipeline, submodules can be used idependently or with docker-compose

- Grounding-SAM-2 creates from a video 20 object images
- MASt3R registeres these images two times: Surface, Segmentation
- SVRaster: NVS-generted mesh with postprocessing

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
        └── scene # only needed when object scaling with mast3r
            └── images
                ├── PXL_20251009_114017647.jpg
                ├── PXL_20251009_114023775.jpg
                ├── PXL_20251009_114031268.jpg
                └── PXL_20251009_114039378.jpg
```
Before you run the pipeline build all docker images, as describted below
```bash
# run the full pipeline, currently support for sam, mast3r and svraster
chmod +x run_all_pipeline.sh
./run_all_pipeline.sh
```
## Grounded-SAM-2
Download the weights (First Setup)
```bash
cd segmentation/Grounded-SAM-2-zeroshop/checkpoints
bash download_ckpts.sh

cd segmentation/Grounded-SAM-2-zeroshop/gdino_checkpoints
bash download_ckpts.sh
```
Check the settings 
```bash
# what commands do you want to run? change prompt?
docker-compose/grounded-sam2.yml
```
Start Docker
```bash
# Start Docker Manual
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
Start Docker
```bash
# Start Docker Manual
docker-compose -f docker-compose/mast3r.yml up # --build # add if rebuild needed
docker-compose -f docker-compose/mast3r.yml down
```

## VGGT
For now only conda install, look into submodule

## 2DGS
For now only conda install, look into submodule

## SVRASTER
Check the settings 
```bash
# what commands do you want to run? what docker cuda 124or117?
docker-compose/svraster.yml

# set segmented/surface vggt/mast3r-sfm
nvs/svraster-zeroshop/process_all_ycbv.sh
```
Start Docker
```bash
# Start Docker Manual
docker-compose -f docker-compose/svraster.yml up # --build # add if rebuild needed
docker-compose -f docker-compose/svraster.yml down
```

