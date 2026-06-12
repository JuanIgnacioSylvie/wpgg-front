import { createCanvas, loadImage, GlobalFonts } from '@napi-rs/canvas';
import { execSync } from 'node:child_process';
import { mkdirSync, rmSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = join(__dirname, '..');

const W = 1080;
const H = 1920;
const FPS = 30;
const DURATION_SEC = 5;
const TOTAL_FRAMES = FPS * DURATION_SEC;

const colors = {
  background: '#0B0B0F',
  dotGrid: 'rgba(42, 42, 53, 0.35)',
  textPrimary: '#F4F4F5',
  textSecondary: '#9CA3AF',
  textMuted: '#6B7280',
  accent: '#AD1F0F',
  accentHover: '#C42818',
  gold: '#E8A317',
  online: '#22C55E',
};

GlobalFonts.registerFromPath(join(root, 'assets/fonts/Wallpoet-Regular.ttf'), 'Wallpoet');
GlobalFonts.registerFromPath(join(root, 'assets/fonts/LexendDeca-SemiBold.ttf'), 'LexendDeca');
GlobalFonts.registerFromPath(join(root, 'assets/fonts/LexendDeca-Bold.ttf'), 'LexendDecaBold');
GlobalFonts.registerFromPath(join(root, 'assets/fonts/LexendDeca-Medium.ttf'), 'LexendDecaMedium');

const coin = await loadImage(join(root, 'assets/images/wpgg-coin_512x512.png'));

function easeOutCubic(t) {
  return 1 - (1 - t) ** 3;
}

function easeOutElastic(t) {
  if (t === 0 || t === 1) return t;
  const p = 0.35;
  const s = p / 4;
  return 2 ** (-10 * t) * Math.sin(((t - s) * (2 * Math.PI)) / p) + 1;
}

function clamp(v, min, max) {
  return Math.min(max, Math.max(min, v));
}

function drawDotGrid(ctx) {
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

function drawAmbientGlow(ctx, frame) {
  const t = (frame / TOTAL_FRAMES) * Math.PI * 2;
  const pulse = 0.5 + 0.5 * Math.sin(t);

  const topGlow = ctx.createRadialGradient(W * 0.5, H * 0.28, 0, W * 0.5, H * 0.28, W * 0.55);
  topGlow.addColorStop(0, `rgba(173, 31, 15, ${0.14 + pulse * 0.08})`);
  topGlow.addColorStop(1, 'rgba(173, 31, 15, 0)');
  ctx.fillStyle = topGlow;
  ctx.fillRect(0, 0, W, H);

  const goldGlow = ctx.createRadialGradient(W * 0.82, H * 0.18, 0, W * 0.82, H * 0.18, W * 0.35);
  goldGlow.addColorStop(0, `rgba(232, 163, 23, ${0.06 + pulse * 0.04})`);
  goldGlow.addColorStop(1, 'rgba(232, 163, 23, 0)');
  ctx.fillStyle = goldGlow;
  ctx.fillRect(0, 0, W, H);

  const bottomGlow = ctx.createRadialGradient(W * 0.2, H * 0.92, 0, W * 0.2, H * 0.92, W * 0.45);
  bottomGlow.addColorStop(0, 'rgba(173, 31, 15, 0.08)');
  bottomGlow.addColorStop(1, 'rgba(173, 31, 15, 0)');
  ctx.fillStyle = bottomGlow;
  ctx.fillRect(0, 0, W, H);
}

function drawRing(ctx, cx, cy, radius, progress) {
  if (progress <= 0 || progress >= 1) return;
  const scale = 0.55 + progress * 1.1;
  const opacity = 0.55 * (1 - progress);
  const r = radius * scale;

  ctx.save();
  ctx.globalAlpha = opacity;
  ctx.strokeStyle = 'rgba(173, 31, 15, 0.75)';
  ctx.lineWidth = 3;
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.stroke();
  ctx.restore();
}

function drawCoin(ctx, frame) {
  const entranceFrames = 66;
  const entranceT = clamp(frame / entranceFrames, 0, 1);
  const entranceScale = entranceT < 1 ? 0.15 + easeOutElastic(entranceT) * 0.85 : 1;
  const entranceOpacity = entranceT < 1 ? easeOutCubic(clamp(entranceT / 0.35, 0, 1)) : 1;
  const flipT = entranceT < 1 ? easeOutCubic(entranceT) : 1;
  const flipScaleX = 0.25 + flipT * 0.75;

  const idlePhase = (frame % 96) / 96;
  const floatY = Math.sin(idlePhase * Math.PI * 2) * 18;
  const glowPulse = 0.18 + (0.5 + 0.5 * Math.sin(idlePhase * Math.PI * 2)) * 0.14;

  const coinSize = 420;
  const cx = W / 2;
  const cy = H * 0.38 + floatY;

  const ringCycle = 90;
  const ringFrame = frame % ringCycle;
  const ringProgress = ringFrame < 42 ? ringFrame / 42 : 1;
  drawRing(ctx, cx, cy, coinSize * 0.52, ringProgress);

  ctx.save();
  ctx.globalAlpha = entranceOpacity;
  ctx.translate(cx, cy);
  ctx.scale(entranceScale * flipScaleX, entranceScale);

  ctx.shadowColor = `rgba(173, 31, 15, ${glowPulse})`;
  ctx.shadowBlur = 48 + glowPulse * 120;
  ctx.shadowOffsetX = 0;
  ctx.shadowOffsetY = 0;

  ctx.drawImage(coin, -coinSize / 2, -coinSize / 2, coinSize, coinSize);

  ctx.shadowColor = `rgba(232, 163, 23, ${glowPulse * 0.55})`;
  ctx.shadowBlur = 36;
  ctx.drawImage(coin, -coinSize / 2, -coinSize / 2, coinSize, coinSize);

  ctx.restore();
}

function drawRoundedRect(ctx, x, y, w, h, r) {
  ctx.beginPath();
  ctx.moveTo(x + r, y);
  ctx.arcTo(x + w, y, x + w, y + h, r);
  ctx.arcTo(x + w, y + h, x, y + h, r);
  ctx.arcTo(x, y + h, x, y, r);
  ctx.arcTo(x, y, x + w, y, r);
  ctx.closePath();
}

function drawTextBlock(ctx, frame) {
  const textStart = 24;
  const textT = clamp((frame - textStart) / 36, 0, 1);
  const textOpacity = easeOutCubic(textT);
  const textY = (1 - textT) * 28;

  const baseY = H * 0.58 + textY;

  ctx.save();
  ctx.globalAlpha = textOpacity;
  ctx.textAlign = 'center';

  ctx.font = '72px Wallpoet';
  ctx.fillStyle = colors.textPrimary;
  ctx.letterSpacing = '6px';
  ctx.fillText('WPGG', W / 2, baseY);

  ctx.font = '44px LexendDeca';
  ctx.fillStyle = colors.textPrimary;
  ctx.letterSpacing = '0px';
  ctx.fillText('Jugá League of Legends', W / 2, baseY + 78);

  ctx.font = '52px LexendDecaBold';
  ctx.fillStyle = colors.textPrimary;
  const line2 = 'Ganá ';
  const wpgg = 'WPGG';
  const line2Width = ctx.measureText(line2 + wpgg).width;
  const line2X = W / 2 - line2Width / 2;
  ctx.textAlign = 'left';
  ctx.fillStyle = colors.textPrimary;
  ctx.fillText(line2, line2X, baseY + 148);
  const w1 = ctx.measureText(line2).width;
  ctx.fillStyle = colors.accentHover;
  ctx.fillText(wpgg, line2X + w1, baseY + 148);
  ctx.textAlign = 'center';

  const badgeW = 320;
  const badgeH = 58;
  const badgeX = (W - badgeW) / 2;
  const badgeY = baseY + 188;

  drawRoundedRect(ctx, badgeX, badgeY, badgeW, badgeH, 29);
  ctx.fillStyle = 'rgba(34, 197, 94, 0.14)';
  ctx.fill();
  ctx.strokeStyle = 'rgba(34, 197, 94, 0.45)';
  ctx.lineWidth = 2;
  ctx.stroke();

  ctx.font = '26px LexendDecaBold';
  ctx.fillStyle = colors.online;
  ctx.fillText('100% GRATIS', W / 2, badgeY + 38);

  ctx.font = '22px LexendDecaMedium';
  ctx.fillStyle = colors.textSecondary;
  ctx.fillText('Well Played · Good Game', W / 2, badgeY + 98);

  ctx.restore();
}

function drawTopAccent(ctx) {
  const grad = ctx.createLinearGradient(0, 0, W, 0);
  grad.addColorStop(0, 'rgba(173, 31, 15, 0)');
  grad.addColorStop(0.5, 'rgba(173, 31, 15, 0.85)');
  grad.addColorStop(1, 'rgba(173, 31, 15, 0)');
  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, W, 4);
}

const framesDir = join(__dirname, '.frames');
rmSync(framesDir, { recursive: true, force: true });
mkdirSync(framesDir, { recursive: true });

const canvas = createCanvas(W, H);
const ctx = canvas.getContext('2d');

console.log(`Rendering ${TOTAL_FRAMES} frames at ${W}x${H}...`);

for (let frame = 0; frame < TOTAL_FRAMES; frame++) {
  drawDotGrid(ctx);
  drawAmbientGlow(ctx, frame);
  drawCoin(ctx, frame);
  drawTextBlock(ctx, frame);
  drawTopAccent(ctx);

  const framePath = join(framesDir, `frame_${String(frame).padStart(4, '0')}.png`);
  writeFileSync(framePath, canvas.toBuffer('image/png'));

  if (frame % 30 === 0) {
    console.log(`  ${Math.round((frame / TOTAL_FRAMES) * 100)}%`);
  }
}

const outputPath = join(__dirname, 'ig-story-wpgg.mp4');
const ffmpegCmd = [
  'ffmpeg',
  '-y',
  '-framerate', String(FPS),
  '-i', join(framesDir, 'frame_%04d.png'),
  '-c:v', 'libx264',
  '-pix_fmt', 'yuv420p',
  '-crf', '18',
  '-movflags', '+faststart',
  outputPath,
].join(' ');

console.log('Encoding MP4...');
execSync(ffmpegCmd, { stdio: 'inherit' });

rmSync(framesDir, { recursive: true, force: true });
console.log(`Done: ${outputPath}`);
