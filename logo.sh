# logo.sh - Walang 'clear' dito
# I-print ang logo nang may animation
for i in {1..3}; do
    # \e[H = Ibalik ang cursor sa home (pinakataas na kaliwa)
    echo -e "\e[H\e[1;32m   WELCOME TO ALMARAS-TOOLS V1.0 \e[0m"
    sleep 0.2
    echo -e "\e[H\e[1;36m   WELCOME TO ALMARAS-TOOLS V1.0 \e[0m"
    sleep 0.2
done
# Siguraduhin na naka-set sa default color pagkatapos ng animation
echo -e "\e[H\e[1;32m   WELCOME TO ALMARAS-TOOLS V1.0 \e[0m"
