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

# Создаем скрипт автологина напрямую внутри образа
RUN echo -e '#!/usr/bin/bash\nif [ "$(tty)" = "/dev/tty1" ]; then\n    exec dbus-run-session Hyprland\nfi' > /usr/bin/hyprdose-autologin && \
    chmod +x /usr/bin/hyprdose-autologin

# Создаем системную службу напрямую внутри образа
RUN echo -e '[Unit]\nDescription=Hyprdose TTY Autologin\nAfter=systemd-user-sessions.service plymouth-quit-active.service\nBefore=getty.target\n\n[Service]\nType=simple\nExecStart=-/usr/sbin/agetty --autologin deck --noclear tty1 $TERM\nUtmpIdentifier=tty1\nUtmpSystemName=tty1\nStandardInput=tty\nStandardOutput=tty\nTTYPath=/dev/tty1\nTTYReset=yes\nTTYVHangup=yes\n\n[Install]\nWantedBy=multi-user.target' > /etc/systemd/system/hyprdose-tty-autologin.service

# Активируем службу автоматического входа
RUN systemctl enable hyprdose-tty-autologin.service

# Обновляем метаданные системы
RUN rpm-ostree cleanup -m && ostree container commit
