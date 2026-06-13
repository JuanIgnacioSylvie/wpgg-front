import { createCanvas, loadImage, GlobalFonts } from '@napi-rs/canvas';
import { execFileSync, execSync } from 'node:child_process';
import { existsSync } from 'node:fs';
import { mkdirSync, rmSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

export const W = 1080;
export const H = 1920;
export const FPS = 30;
export const DURATION_SEC = 5;
export const TOTAL_FRAMES = FPS * DURATION_SEC;

export const colors = {
  background: '#0B0B0F',
  surface: '#141419',
  surfaceElevated: '#1C1C24',
  border: '#2A2A35',
  dotGrid: 'rgba(42, 42, 53, 0.35)',
  textPrimary: '#F4F4F5',
  textSecondary: '#9CA3AF',
  textMuted: '#6B7280',
  accent: '#AD1F0F',
  accentHover: '#C42818',
  gold: '#E8A317',
  online: '#22C55E',
};

const __dirname = dirname(fileURLToPath(import.meta.url));
export const root = join(__dirname, '..', '..');
export const marketingDir = join(__dirname, '..');

let fontsRegistered = false;
let coinImage = null;

export function setupFonts() {
  if (fontsRegistered) return;
  GlobalFonts.registerFromPath(join(root, 'assets/fonts/Wallpoet-Regular.ttf'), 'Wallpoet');
  GlobalFonts.registerFromPath(join(root, 'assets/fonts/LexendDeca-SemiBold.ttf'), 'LexendDeca');
  GlobalFonts.registerFromPath(join(root, 'assets/fonts/LexendDeca-Bold.ttf'), 'LexendDecaBold');
  GlobalFonts.registerFromPath(join(root, 'assets/fonts/LexendDeca-Medium.ttf'), 'LexendDecaMedium');
  GlobalFonts.registerFromPath(join(root, 'assets/fonts/LexendDeca-ExtraBold.ttf'), 'LexendDecaExtraBold');
  fontsRegistered = true;
}

export async function loadCoin() {
  if (!coinImage) {
    coinImage = await loadImage(join(root, 'assets/images/wpgg-coin_512x512.png'));
  }
  return coinImage;
}

export function easeOutCubic(t) {
  return 1 - (1 - t) ** 3;
}

export function easeOutBack(t) {
  const c1 = 1.70158;
  const c3 = c1 + 1;
  return 1 + c3 * (t - 1) ** 3 + c1 * (t - 1) ** 2;
}

export function easeOutElastic(t) {
  if (t === 0 || t === 1) return t;
  const p = 0.35;
  const s = p / 4;
  return 2 ** (-10 * t) * Math.sin(((t - s) * (2 * Math.PI)) / p) + 1;
}

export function clamp(v, min, max) {
  return Math.min(max, Math.max(min, v));
}

export function drawRoundedRect(ctx, x, y, w, h, r) {
  ctx.beginPath();
  ctx.moveTo(x + r, y);
  ctx.arcTo(x + w, y, x + w, y + h, r);
  ctx.arcTo(x + w, y + h, x, y + h, r);
  ctx.arcTo(x, y + h, x, y, r);
  ctx.arcTo(x, y, x + w, y, r);
  ctx.closePath();
}

export function drawDotGrid(ctx) {
  ctx.fillStyle = colors.background;
  ctx.fillRect(0, 0, W, H);

  ctx.fillStyle = colors.dotGrid;
  for (let x = 0; x < W; x += 24) {
    for (let y = 0; y < H; y += 24) {
      ctx.beginPath();
      ctx.arc(x, y, 1, 0, Math.PI * 2);
      ctx.fill();
    }
  }
}

let cachedFfmpegPath = null;

export function resolveFfmpeg() {
  if (cachedFfmpegPath) return cachedFfmpegPath;

  try {
    const found = execSync(process.platform === 'win32' ? 'where ffmpeg' : 'which ffmpeg', {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore'],
    })
      .trim()
      .split(/\r?\n/)[0];
    if (found && existsSync(found)) {
      cachedFfmpegPath = found;
      return cachedFfmpegPath;
    }
  } catch {
    // Fall through to common install locations.
  }

  const candidates = [
    process.env.FFMPEG_PATH,
    process.platform === 'win32'
      ? join(process.env.LOCALAPPDATA ?? '', 'Microsoft', 'WinGet', 'Links', 'ffmpeg.exe')
      : null,
    process.platform === 'win32' ? 'C:\\ffmpeg\\bin\\ffmpeg.exe' : '/usr/bin/ffmpeg',
    process.platform === 'win32'
      ? join(process.env.ProgramFiles ?? '', 'ffmpeg', 'bin', 'ffmpeg.exe')
      : '/usr/local/bin/ffmpeg',
  ].filter(Boolean);

  for (const candidate of candidates) {
    if (existsSync(candidate)) {
      cachedFfmpegPath = candidate;
      return cachedFfmpegPath;
    }
  }

  throw new Error(
    'ffmpeg no encontrado. Instalalo con "winget install Gyan.FFmpeg" o reinicia la terminal despues de instalarlo.',
  );
}

export function encodeVideo(outputName, renderFrame) {
  const framesDir = join(marketingDir, '.frames');
  rmSync(framesDir, { recursive: true, force: true });
  mkdirSync(framesDir, { recursive: true });

  const canvas = createCanvas(W, H);
  const ctx = canvas.getContext('2d');

  console.log(`Rendering ${TOTAL_FRAMES} frames at ${W}x${H}...`);

  for (let frame = 0; frame < TOTAL_FRAMES; frame++) {
    renderFrame(ctx, frame);
    writeFileSync(
      join(framesDir, `frame_${String(frame).padStart(4, '0')}.png`),
      canvas.toBuffer('image/png'),
    );
    if (frame % 30 === 0) {
      console.log(`  ${Math.round((frame / TOTAL_FRAMES) * 100)}%`);
    }
  }

  const outputPath = join(marketingDir, outputName);
  const ffmpeg = resolveFfmpeg();

  console.log('Encoding MP4...');
  execFileSync(
    ffmpeg,
    [
      '-y',
      '-framerate', String(FPS),
      '-i', join(framesDir, 'frame_%04d.png'),
      '-c:v', 'libx264',
      '-pix_fmt', 'yuv420p',
      '-crf', '18',
      '-movflags', '+faststart',
      outputPath,
    ],
    { stdio: 'inherit' },
  );

  rmSync(framesDir, { recursive: true, force: true });
  console.log(`Done: ${outputPath}`);
}
