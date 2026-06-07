#!/bin/bash

env

/app/llama-server --hf-repo "$START_HF_REPO" --hf-file "$START_HF_FILE" -c "$START_CTX_SIZE"