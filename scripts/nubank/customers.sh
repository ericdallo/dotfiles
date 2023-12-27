#!/usr/bin/env sh

option=$(echo "Me - id - prod\nPixFacil - tax-id - staging\nTrem Que Pisca - tax-id - staging" | rofi -dmenu -p "Select customer" -no-custom)
case $option in

    "Me - id - prod")
    echo "$CUSTOMERS_ME_ID" | xclip -selection clipboard
    ;;

    "PixFacil - tax-id - staging")
    echo "$CUSTOMERS_STAGING_1_TAX_ID" | xclip -selection clipboard
    ;;

    "Trem Que Pisca - tax-id - staging")
    echo "$CUSTOMERS_STAGING_2_TAX_ID" | xclip -selection clipboard
    ;;

    *)
    exit 0
    ;;

esac
