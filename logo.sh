#!/bin/bash

# Kulay Green (Hacker Style)
GREEN="\e[1;32m"
RESET="\e[0m"

# Ilagay ang cursor sa top-left ng screen
tput cup 0 0

# I-print ang ASCII art mo
echo -e "${GREEN}"
cat << "EOF"
    :::     :::        ::::    ::::      :::     :::::::::      :::      ::::::::  
  :+: :+:   :+:        +:+:+: :+:+:+   :+: :+:   :+:    :+:   :+: :+:   :+:    :+: 
 +:+   +:+  +:+        +:+ +:+:+ +:+  +:+   +:+  +:+    +:+  +:+   +:+  +:+        
+#++:++#++: +#+        +#+  +:+  +#+ +#++:++#++: +#++:++#:  +#++:++#++: +#++:++#++ 
+#+     +#+ +#+        +#+       +#+ +#+     +#+ +#+    +#+ +#+     +#+        +#+ 
#+#     #+# #+#        #+#       #+# #+#     #+# #+#    #+# #+#     #+# #+#    #+# 
###     ### ########## ###       ### ###     ### ###    ### ###     ###  ########  

               --- ALMARAS TOOLS V1.0 ---
🔥please follow streamixph on facebook and youtube thanks🔥
EOF
echo -e "${RESET}"
