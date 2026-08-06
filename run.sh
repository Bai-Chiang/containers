script_dir="$( cd -- "$(dirname ${BASH_SOURCE[0]})" &> /dev/null ; pwd -P )"

args="--workdir /home/tux/data "
args="-v "${script_dir%/*}/data":/home/tux/data:z "

if [[ "${script_dir##*/}" == *cuda* ]] ; then
    args="$args --device /dev/nvidia0:/dev/nvidia0:r "
    args="$args --device /dev/nvidiactl:/dev/nvidiactl:r "
    args="$args --device /dev/nvidia-uvm:/dev/nvidia-uvm:r "
    args="$args --device /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools:r "
    args="$args -v /usr/lib64/libnvidia-ml.so.1:/usr/lib64/libnvidia-ml.so.1:ro "
    args="$args -v /usr/bin/nvidia-smi:/usr/bin/nvidia-smi:ro "
fi

if [[ "${script_dir##*/}" == *llamacpp* && "${script_dir##*/}" != *opencode ]] ; then
    args="$args --publish 127.0.0.1:9931:9931 "
fi

if [[ "${script_dir##*/}" == *opencode ]] ; then
    args="$args -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
    args="$args -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
    args="$args -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
    args="$args --network none "
fi

podman run --rm -it --userns keep-id \
    --name "${script_dir##*/}" \
    --hostname "${script_dir##*/}" \
    `#--security-opt=label=disable` \
    ${args} \
    "localhost/${script_dir##*/}" \
    zsh -l

