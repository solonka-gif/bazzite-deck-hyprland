# Базируемся на стабильном Bazzite с KDE для Steam Deck
FROM ghcr.io/ublue-os/bazzite-deck:stable

# Включаем COPR репозитории: для Hyprland и официальный для AGS
RUN dnf copr enable -y solopasha/hyprland && \
    dnf copr enable -y primus/aylurs-gtk-shell

# Устанавливаем проверенные системные пакеты + AGS
RUN rpm-ostree install \
    hyprland \
    aylurs-gtk-shell \
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

