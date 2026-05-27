# Базируемся на стабильном Bazzite с KDE для Steam Deck
FROM ghcr.io/ublue-os/bazzite-deck:stable

# Включаем главный COPR репозиторий для Hyprland и готового AGS
RUN dnf copr enable -y solopasha/hyprland && \
    dnf copr enable -y kylegospo/bazzite

# Устанавливаем Hyprland, готовый AGS и все утилиты окружения
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
    aylurs-gtk-shell \
    git

# Копируем системные службы автоматического входа в TTY (из репозитория автора)
COPY hyprdose-tty-autologin.service /etc/systemd/system/hyprdose-tty-autologin.service
COPY hyprdose-autologin /usr/bin/hyprdose-autologin

# Активируем службу автоматического входа
RUN systemctl enable hyprdose-tty-autologin.service

# Обновляем метаданные системы
RUN rpm-ostree cleanup -m && ostree container commit
