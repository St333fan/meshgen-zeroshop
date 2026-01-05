# Overview
Tested on RTX 4070 16GB Driver Version: 550.78 CUDA Version: 12.4

ZeroShop meshing pipeline, submodules can be used idependently or with docker-compose

- Grounding-SAM-2 creates 20 object images from a video
- MASt3R registeres these images two times: with-surface-> surface, without-surface-> segmented
- SVRaster: NVS-generated mesh + Postprocessing

# Setup
Clone the git, then init submodules
```bash
git submodule update --init --recursive
```
Build your dataset structure one video per obj_0000XX
```bash
# First usage best case try "ycbv_real_subset", so paths are correct 
datasets
└── ycbv_real_subset
    └── obj_000001
        ├── PXL_20251009_114058863.mp4
        └── scene # only needed when object scaling with mast3r
            └── images
                ├── PXL_20251009_114017647.jpg
                ├── PXL_20251009_114023775.jpg
                ├── PXL_20251009_114031268.jpg
                └── PXL_20251009_114039378.jpg

### add your own object height if you dont used mast3r estimation, if you dont add object_info.json every object is automatically scaled to 0.2 [m]
scene/output/object_info.json
{
    "estimated_height": 0.465
}
###
```
Before you run the pipeline build all docker images, as described below
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
Check the settings 
```bash
# what commands do you want to run?
docker-compose/2dgs.yml

# set segmented/surface or vggt/mast3r-sfm
nvs/2d-gaussian-splatting-zeroshop/process_all_ycbv_docker.sh
```
Start Docker
```bash
# Display access for meshlab texturation
xhost +local:docker

# Start Docker Manual
docker-compose -f docker-compose/2dgs.yml up # --build # add if rebuild needed
docker-compose -f docker-compose/2dgs.yml down
```

## SVRASTER
Check the settings 
```bash
# what commands do you want to run?
docker-compose/svraster.yml

# set segmented/surface or vggt/mast3r-sfm
nvs/svraster-zeroshop/process_all_ycbv_docker.sh
```
Start Docker
```bash
# Display access for meshlab texturation
xhost +local:docker

# Start Docker Manual
docker-compose -f docker-compose/svraster.yml up # --build # add if rebuild needed
docker-compose -f docker-compose/svraster.yml down

# SVRaster has many parameters I you want to change things or add new ones
nvs/svraster-zeroshop/cfg
```

