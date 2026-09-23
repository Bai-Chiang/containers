script_dir="$( cd -- "$(dirname ${BASH_SOURCE[0]})" &> /dev/null ; pwd -P )"

args="-v "${script_dir%/*}/data":/workdir/data:z "
if [[ "${script_dir##*/}" == archlinux* ]] ; then
    shell=zsh
else
    shell=bash
fi

if [[ "${script_dir##*/}" == *cuda* ]] ; then
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

if [[ "${script_dir##*/}" == *llamacpp* ]] ; then
    args="$args --publish 127.0.0.1:9931:9931 "
fi
if [[ "${script_dir##*/}" == *comfyui* ]] ; then
    args="$args --publish 127.0.0.1:8188:8188 "
    args="$args -v "${script_dir%/*}/data/comfyui":/workdir/comfyui/models:Z "
fi

podman run --rm -it --userns keep-id \
    --name "${script_dir##*/}" \
    --hostname "${script_dir##*/}" \
    ${args} \
    "localhost/${script_dir##*/}" \
    "${shell}" -l "${cmds[@]}"

