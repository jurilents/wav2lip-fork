#! /bin/sh

if [ "x$AFTER_REBOOT" = "xyes" ]; then

    # After reboot
    git clone https://github.com/jurilents/wav2lip-fork.git
    cd wav2lip-fork/
    conda create -y -n wav2lip python=3.6
    conda activate wav2lip
    pip install -r requirements.txt
    sudo NEEDRESTART_MODE=a apt-get install libsm6 libxrender1 libfontconfig1

    pip install gdown
    gdown --no-check-certificate --folder https://drive.google.com/drive/folders/1Okeb6I7bt7RRQ9zC_9fSC1_kkjrGNaNN
    mv ./wav2lip-fork/s3fd.pth ./face_detection/detection/sfd/
    mv ./wav2lip-fork/wav2lip.pth .
    mv ./wav2lip-fork/wav2lip_gan.pth .
    rm -r wav2lip-fork/

else

    # Before reboot
    sudo NEEDRESTART_MODE=a apt-get update -y
    sudo NEEDRESTART_MODE=a apt-get upgrade -y
    sudo NEEDRESTART_MODE=a apt autoremove -y

    wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
    chmod -v +x Miniconda*.sh
    ./Miniconda3-py39_4.12.0-Linux-x86_64.sh -b
    rm ./Miniconda3-py39_4.12.0-Linux-x86_64.sh

    wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
    chmod -v +x Anaconda3-2022.05-Linux-x86_64.sh
    ./Anaconda3-2022.05-Linux-x86_64.sh -b
    if ! [[ $PATH =~ "$HOME/anaconda3/bin" ]]; then
    PATH="$HOME/anaconda3/bin:$PATH"
    fi
    rm ./Anaconda3-2022.05-Linux-x86_64.sh

    if ! [[ $PATH =~ "$HOME/miniconda3/bin" ]]; then
    PATH="$HOME/miniconda3/bin:$PATH"
    fi
    if ! [[ $PATH =~ "$HOME/anaconda3/bin" ]]; then
    PATH="$HOME/anaconda3/bin:$PATH"
    fi

    cat >> .bashrc <<'EOF'
    if ! [[ $PATH =~ "$HOME/miniconda3/bin" ]]; then
    PATH="$HOME/miniconda3/bin:$PATH"
    fi
    if ! [[ $PATH =~ "$HOME/anaconda3/bin" ]]; then
    PATH="$HOME/anaconda3/bin:$PATH"
    fi
    EOF

    conda init
    sudo NEEDRESTART_MODE=a apt-get install -y ffmpeg

    sudo reboot

fi
