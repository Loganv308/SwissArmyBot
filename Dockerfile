# ---- deps: install node dependencies (may compile optional native addons) ----
FROM node:24-bookworm-slim AS deps
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 make g++ \
    && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
# The app spawns the system `yt-dlp` (installed below), not youtube-dl-exec's
# own bundled copy, so skip its redundant postinstall download.
RUN YOUTUBE_DL_SKIP_DOWNLOAD=true npm ci --omit=dev

# ---- runtime ----
FROM node:24-bookworm-slim
WORKDIR /app

# ffmpeg: required by discord-player/prism-media for audio transcoding
# yt-dlp: the "_linux" asset is a self-contained PyInstaller build (no system
# python needed) — the plain "yt-dlp" asset requires a python3 interpreter.
RUN apt-get update && apt-get install -y --no-install-recommends \
        ffmpeg curl ca-certificates \
    && curl -fL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux -o /usr/local/bin/yt-dlp \
    && chmod a+rx /usr/local/bin/yt-dlp \
    && apt-get purge -y curl \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN chown -R node:node /app
USER node

CMD ["node", "index.js"]
