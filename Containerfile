
# Базируемся на стабильном Bazzite с KDE для Steam Deck
FROM ghcr.io/ublue-os/bazzite-deck:stable

# Включаем сторонний репозиторий COPR для установки AGS (нужен для Caelestia)
RUN dnf copr enable -y jgoguen/ags

# Устанавливаем Hyprland, зависимости Caelestia и утилиты для Steam Deck
RUN rpm-ostree install \
    hyprland \
    kitty \
    fish \
    starship \
    ags \
    swww \
    rofi-wayland \
    wvkbd \
    brightnessctl \
    wlogout \
    grim \
    slurp \
    wl-clipboard \
    networkmanager-openvpn \
    google-noto-sans-cjk-fonts \
    google-noto-color-emoji-fonts \
    jetbrains-mono-fonts

# Копируем системные службы автоматического входа в TTY (из репозитория автора)
COPY hyprdose-tty-autologin.service /etc/systemd/system/hyprdose-tty-autologin.service
COPY hyprdose-autologin /usr/bin/hyprdose-autologin

# Активируем службу автоматического входа
RUN systemctl enable hyprdose-tty-autologin.service

# Обновляем метаданные системы
RUN rpm-ostree cleanup -m && ostree container commit
