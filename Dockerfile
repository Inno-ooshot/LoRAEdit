FROM nvidia/cuda:12.4.1-cudnn8-runtime-ubuntu22.04

# Install basic tools and Python 3.12
RUN apt-get update && \
    apt-get install -y python3.12 python3.12-venv git wget ffmpeg libgl1 libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

# Use Python 3.12 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Install PyTorch 2.6.0 with CUDA 12.4
RUN pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu124

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Install SAM2
RUN git clone https://github.com/facebookresearch/sam2.git /opt/sam2 && \
    pip install -e /opt/sam2

# Copy project code
WORKDIR /opt/LoRAEdit
COPY . .

# Default command (adjust as needed)
CMD ["python", "inference.py", "--model_root_dir", "/models/Wan2.1-I2V-14B-480P", "--data_dir", "/data/processed_sequence"]
