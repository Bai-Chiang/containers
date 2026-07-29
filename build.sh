script_dir="$( cd -- "$(dirname ${BASH_SOURCE[0]})" &> /dev/null ; pwd -P )"
podman build \
    --device /dev/nvidia0:/dev/nvidia0:r \
    --device /dev/nvidiactl:/dev/nvidiactl:r \
    --device /dev/nvidia-uvm:/dev/nvidia-uvm:r \
    --device /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools:r \
    -v /usr/lib64/libnvidia-ml.so.1:/usr/lib64/libnvidia-ml.so.1:ro \
    -v /usr/bin/nvidia-smi:/usr/bin/nvidia-smi:ro \
    --tag "${script_dir##*/}" \
    --build-arg username=tux \
    "${script_dir}"
