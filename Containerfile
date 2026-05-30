# Базируемся на стабильном Bazzite с KDE для Steam Deck
FROM ghcr.io/ublue-os/bazzite-deck:stable

# Включаем главный COPR репозиторий для Hyprland
RUN dnf copr enable -y solopasha/hyprland

# Устанавливаем все нужные пакеты (без AGS, его соберем локально)
RUN rpm-ostree install \
    hyprland \
    kitty \
    fish \
    swww \
    rofi-wayland \
    brightnessctl \
    wlogout \
    grim \
    slurp \
    wl-clipboard \
    google-noto-sans-cjk-fonts \
    google-noto-color-emoji-fonts \
    jetbrains-mono-fonts \
    git

# Обновляем метаданные системы
RUN rpm-ostree cleanup -m && ostree container commit
