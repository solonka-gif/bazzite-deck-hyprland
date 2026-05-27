# Базируемся на стабильном Bazzite с KDE для Steam Deck
FROM ghcr.io/ublue-os/bazzite-deck:stable

# Включаем главный COPR репозиторий для Hyprland на Fedora
RUN dnf copr enable -y solopasha/hyprland

# Устанавливаем только проверенные системные пакеты
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

# Копируем системные службы автоматического входа в TTY (из репозитория автора)
COPY hyprdose-tty-autologin.service /etc/systemd/system/hyprdose-tty-autologin.service
COPY hyprdose-autologin /usr/bin/hyprdose-autologin

# Активируем службу автоматического входа
RUN systemctl enable hyprdose-tty-autologin.service

# Обновляем метаданные системы
RUN rpm-ostree cleanup -m && ostree container commit
