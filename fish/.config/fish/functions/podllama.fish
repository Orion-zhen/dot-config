function podllama --description "run local-built llama.cpp with podman"
    podman run --rm -it \
        --device /dev/dri \
        --device /dev/kfd \
        -v $MODELS:/models \
        -p 8080:8080 \
        llama-cpp:latest \
        /bin/fish
end