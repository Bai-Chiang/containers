script_dir="$( cd -- "$(dirname ${BASH_SOURCE[0]})" &> /dev/null ; pwd -P )"

if [[ "${script_dir##*/}" == *cuda* ]] ; then
    args="$args --device /dev/nvidia0:/dev/nvidia0:r "
    args="$args --device /dev/nvidiactl:/dev/nvidiactl:r "
    args="$args --device /dev/nvidia-uvm:/dev/nvidia-uvm:r "
    args="$args --device /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools:r "
    args="$args -v /usr/lib64/libnvidia-ml.so.1:/usr/lib64/libnvidia-ml.so.1:ro "
    args="$args -v /usr/bin/nvidia-smi:/usr/bin/nvidia-smi:ro "
fi

podman build \
    --tag "${script_dir##*/}" \
    --build-arg username=tux \
    ${args} \
    "${script_dir}"
