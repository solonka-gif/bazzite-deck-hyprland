# Базируемся на стабильном Bazzite с KDE для Steam Deck
FROM ghcr.io/ublue-os/bazzite-deck:stable

# Устанавливаем Hyprland, утилиты для Steam Deck и ЗАВИСИМОСТИ для сборки AGS
RUN rpm-ostree install \
    hyprland \
    kitty \
    fish \
    starship \
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
    jetbrains-mono-fonts \
    typescript npm meson gjs-devel gtk3-devel gtk-layer-shell gnome-bluetooth upower pulseaudio-libs-devel libdbusmenu-gtk3 libsoup3 git

# Собираем и устанавливаем AGS (Aylur's GTK Shell) из исходников
RUN git clone --recursive https://github.com/Aylur/ags.git /tmp/ags && \
    cd /tmp/ags && \
    meson setup build && \
    meson compile -C build && \
    meson install -C build && \
    rm -rf /tmp/ags

# Копируем системные службы автоматического входа в TTY (из репозитория автора)
COPY hyprdose-tty-autologin.service /etc/systemd/system/hyprdose-tty-autologin.service
COPY hyprdose-autologin /usr/bin/hyprdose-autologin

# Активируем службу автоматического входа
RUN systemctl enable hyprdose-tty-autologin.service

# Обновляем метаданные системы
RUN rpm-ostree cleanup -m && ostree container commit

