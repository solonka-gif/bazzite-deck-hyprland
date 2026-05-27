# Базируемся на стабильном Bazzite с KDE для Steam Deck
FROM ghcr.io/ublue-os/bazzite-deck:stable

# Включаем главный COPR репозиторий для Hyprland на Fedora
RUN dnf copr enable -y solopasha/hyprland

# Устанавливаем всё необходимое софтверное наполнение
RUN rpm-ostree install \
    hyprland \
    kitty \
    fish \
    starship \
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
    typescript npm meson gjs-devel gtk3-devel gtk-layer-shell gnome-bluetooth upower pulseaudio-libs-devel libdbusmenu-gtk3 libsoup3 git

# Скачиваем, собираем и ставим AGS (Aylur's GTK Shell) из исходников для Caelestia
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

