script_dir="$( cd -- "$(dirname ${BASH_SOURCE[0]})" &> /dev/null ; pwd -P )"

if [[ "${script_dir##*/}" == *cuda* && "${script_dir##*/}" != *cuda ]] ; then
    if [[ -f /usr/bin/sestatus ]] ; then
        args="$args --security-opt=label=disable "
    fi
    if [[ -f /var/run/cdi/nvidia.yaml ]] ; then
        args="$args --device nvidia.com/gpu=all "
    else
        args="$args --device /dev/nvidia0:/dev/nvidia0:r "
        args="$args --device /dev/nvidiactl:/dev/nvidiactl:r "
        args="$args --device /dev/nvidia-uvm:/dev/nvidia-uvm:r "
        args="$args --device /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools:r "
        args="$args -v /usr/bin/nvidia-smi:/usr/bin/nvidia-smi:ro "
    fi
fi

podman build \
    --tag "${script_dir##*/}" \
    --build-arg username=$(whoami) \
    ${args} \
    "${script_dir}"
