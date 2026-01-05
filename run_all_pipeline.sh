#!/bin/bash

# Complete pipeline to process YCBV dataset through all stages
# This script runs all three Docker services sequentially:
# 1. Grounded-SAM-2 (segmentation)
# 2. MASt3R (registration/SfM)
# 3. SVRaster (novel view synthesis and mesh extraction)

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMPOSE_DIR="$SCRIPT_DIR/docker-compose"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}MESHGEN-ZEROSHOP COMPLETE PIPELINE${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "This script will run the complete processing pipeline:"
echo "  1. Grounded-SAM-2: Segmentation"
echo "  2. MASt3R: Structure from Motion and Registration"
echo "  3. Novel View Synthesis and Mesh Extraction"
echo ""
echo "Choose the method for Stage 3 (Novel View Synthesis):"
echo "  1) SVRaster (default)"
echo "  2) 2DGS (2D Gaussian Splatting)"
echo ""
read -p "Enter your choice (1 or 2) [1]: " NVS_CHOICE
NVS_CHOICE=${NVS_CHOICE:-1}

if [[ "$NVS_CHOICE" == "2" ]]; then
    NVS_METHOD="2dgs"
    NVS_DISPLAY_NAME="2DGS (2D GAUSSIAN SPLATTING)"
    echo -e "${GREEN}Selected: 2D Gaussian Splatting${NC}"
else
    NVS_METHOD="svraster"
    NVS_DISPLAY_NAME="SVRASTER"
    echo -e "${GREEN}Selected: SVRaster${NC}"
fi

echo ""
echo "Press Ctrl+C to cancel, or wait 5 seconds to continue..."
sleep 5

# Track overall success
OVERALL_SUCCESS=true

# Stage 1: Grounded-SAM-2 (Segmentation)
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}STAGE 1: GROUNDED-SAM-2 (SEGMENTATION)${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

cd "$SCRIPT_DIR"

echo -e "${YELLOW}Building and starting Grounded-SAM-2 container...${NC}"
if docker-compose -f docker-compose/grounded-sam2.yml up; then
    echo -e "${GREEN}✓ Stage 1 completed successfully${NC}"
else
    echo -e "${RED}✗ Stage 1 failed${NC}"
    OVERALL_SUCCESS=false
    echo ""
    echo "Do you want to continue to the next stage anyway? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Pipeline aborted."
        exit 1
    fi
fi

echo -e "${YELLOW}Cleaning up Grounded-SAM-2 container...${NC}"
docker-compose -f docker-compose/grounded-sam2.yml down

# Stage 2: MASt3R (Registration/SfM)
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}STAGE 2: MAST3R (REGISTRATION/SFM)${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${YELLOW}Building and starting MASt3R container...${NC}"
if docker-compose -f docker-compose/mast3r.yml up; then
    echo -e "${GREEN}✓ Stage 2 completed successfully${NC}"
else
    echo -e "${RED}✗ Stage 2 failed${NC}"
    OVERALL_SUCCESS=false
    echo ""
    echo "Do you want to continue to the next stage anyway? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Pipeline aborted."
        exit 1
    fi
fi

echo -e "${YELLOW}Cleaning up MASt3R container...${NC}"
docker-compose -f docker-compose/mast3r.yml down

# Stage 3: Novel View Synthesis and Mesh Extraction
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}STAGE 3: $NVS_DISPLAY_NAME (NVS & MESH)${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Display access for meshlab texturation (needed for both methods)
echo -e "${YELLOW}Granting X11 display access for pymeshlab...${NC}"
xhost +local:docker

echo -e "${YELLOW}Building and starting $NVS_DISPLAY_NAME container...${NC}"
if docker-compose -f docker-compose/${NVS_METHOD}.yml up; then
    echo -e "${GREEN}✓ Stage 3 completed successfully${NC}"
else
    echo -e "${RED}✗ Stage 3 failed${NC}"
    OVERALL_SUCCESS=false
fi

echo -e "${YELLOW}Cleaning up $NVS_DISPLAY_NAME container...${NC}"
docker-compose -f docker-compose/${NVS_METHOD}.yml down

# Final summary
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}PIPELINE COMPLETE${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [ "$OVERALL_SUCCESS" = true ]; then
    echo -e "${GREEN}✓ All stages completed successfully!${NC}"
    exit 0
else
    echo -e "${RED}⚠ Some stages failed. Check the logs above for details.${NC}"
    exit 1
fi
