# Use NVIDIA CUDA base image (this works with your GTX 1650)
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

# Set up our working directory in the container
WORKDIR /app

# Install required system packages
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-venv \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Clone ComfyUI from GitHub - this is why you don't need to clone it manually!
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# Set up Python virtual environment
RUN python3 -m venv venv
ENV PATH="/app/venv/bin:$PATH"

# Install PyTorch with CUDA support for your GPU
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install ComfyUI's requirements
RUN pip3 install -r requirements.txt

# Create folders for models and outputs
RUN mkdir -p /app/models
RUN mkdir -p /app/output

# Tell Docker we'll use port 8188
EXPOSE 8188

# Set up some PyTorch memory settings
ENV PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512

# Command to start ComfyUI when container runs
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]