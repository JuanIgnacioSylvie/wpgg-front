import {
  W,
  H,
  TOTAL_FRAMES,
  colors,
  setupFonts,
  loadCoin,
  clamp,
  easeOutCubic,
  easeOutBack,
  drawRoundedRect,
  encodeVideo,
} from './lib/shared.mjs';

setupFonts();
const coin = await loadCoin();

const sparks = Array.from({ length: 28 }, (_, i) => ({
  x: (i * 137) % W,
  y: (i * 89) % H,
  speed: 1.2 + (i % 5) * 0.35,
  size: 2 + (i % 3),
  phase: i * 0.7,
}));

function drawNeonBackground(ctx, frame) {
  ctx.fillStyle = '#060608';
  ctx.fillRect(0, 0, W, H);

  const drift = (frame * 6) % 120;
  ctx.save();
  ctx.globalAlpha = 0.12;
  ctx.strokeStyle = colors.accent;
  ctx.lineWidth = 2;
  for (let i = -2; i < 14; i++) {
    const x = -200 + i * 140 + drift;
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x + H * 0.55, H);
    ctx.stroke();
  }
  ctx.restore();

  const pulse = 0.5 + 0.5 * Math.sin((frame / TOTAL_FRAMES) * Math.PI * 2);
  const glow = ctx.createRadialGradient(W * 0.5, H * 0.42, 0, W * 0.5, H * 0.42, W * 0.7);
  glow.addColorStop(0, `rgba(173, 31, 15, ${0.22 + pulse * 0.1})`);
  glow.addColorStop(0.45, 'rgba(173, 31, 15, 0.06)');
  glow.addColorStop(1, 'rgba(173, 31, 15, 0)');
  ctx.fillStyle = glow;
  ctx.fillRect(0, 0, W, H);

  for (const spark of sparks) {
    const y = (spark.y + frame * spark.speed * 3 + spark.phase * 40) % (H + 40) - 20;
    const alpha = 0.25 + 0.35 * Math.sin(frame * 0.08 + spark.phase);
    ctx.fillStyle = `rgba(232, 163, 23, ${alpha})`;
    ctx.beginPath();
    ctx.arc(spark.x, y, spark.size, 0, Math.PI * 2);
    ctx.fill();
  }

  ctx.fillStyle = 'rgba(0, 0, 0, 0.35)';
  for (let y = 0; y < H; y += 4) {
    ctx.fillRect(0, y, W, 1);
  }
}

function drawNeonCoin(ctx, frame) {
  const enterT = easeOutBack(clamp(frame / 40, 0, 1));
  const spin = frame * 0.06;
  const spinScaleX = Math.abs(Math.cos(spin));
  const bob = Math.sin(frame * 0.07) * 14;

  const size = 480;
  const cx = W / 2;
  const cy = H * 0.36 + bob + (1 - enterT) * 120;

  ctx.save();
  ctx.globalAlpha = enterT;
  ctx.translate(cx, cy);
  ctx.scale(spinScaleX * enterT, enterT);

  ctx.shadowColor = 'rgba(196, 40, 24, 0.85)';
  ctx.shadowBlur = 60;
  ctx.drawImage(coin, -size / 2, -size / 2, size, size);

  ctx.shadowColor = 'rgba(232, 163, 23, 0.5)';
  ctx.shadowBlur = 30;
  ctx.drawImage(coin, -size / 2, -size / 2, size, size);
  ctx.restore();

  ctx.save();
  ctx.globalAlpha = 0.35 + 0.25 * Math.sin(frame * 0.12);
  ctx.strokeStyle = colors.accentHover;
  ctx.lineWidth = 4;
  ctx.beginPath();
  ctx.arc(cx, cy, size * 0.58, 0, Math.PI * 2);
  ctx.stroke();
  ctx.restore();
}

function drawNeonText(ctx, frame) {
  const lines = [
    { text: 'LEAGUE OF LEGENDS', font: '32px LexendDeca', color: colors.textSecondary, delay: 18, y: H * 0.58 },
    { text: 'EARN', font: '88px LexendDecaExtraBold', color: colors.textPrimary, delay: 28, y: H * 0.66 },
    { text: 'WPGG', font: '96px Wallpoet', color: colors.accentHover, delay: 36, y: H * 0.74, glow: true },
    { text: '100% FREE PLATFORM', font: '30px LexendDecaBold', color: colors.online, delay: 52, y: H * 0.845 },
  ];

  for (const line of lines) {
    const t = easeOutCubic(clamp((frame - line.delay) / 24, 0, 1));
    if (t <= 0) continue;

    const slideX = (1 - t) * -80;
    ctx.save();
    ctx.globalAlpha = t;
    ctx.textAlign = 'center';
    ctx.font = line.font;
    ctx.fillStyle = line.color;

    if (line.glow) {
      ctx.shadowColor = 'rgba(196, 40, 24, 0.9)';
      ctx.shadowBlur = 28;
    }

    ctx.fillText(line.text, W / 2 + slideX, line.y);
    ctx.restore();
  }

  const ctaT = easeOutCubic(clamp((frame - 64) / 26, 0, 1));
  if (ctaT > 0) {
    const bw = 420;
    const bh = 72;
    const bx = (W - bw) / 2;
    const by = H * 0.875 + (1 - ctaT) * 30;

    ctx.save();
    ctx.globalAlpha = ctaT;
    drawRoundedRect(ctx, bx, by, bw, bh, 36);
    ctx.fillStyle = colors.accent;
    ctx.fill();
    ctx.strokeStyle = 'rgba(255,255,255,0.15)';
    ctx.lineWidth = 2;
    ctx.stroke();

    ctx.font = '28px LexendDecaBold';
    ctx.fillStyle = colors.textPrimary;
    ctx.textAlign = 'center';
    ctx.fillText('PLAY & EARN TODAY', W / 2, by + 46);
    ctx.restore();
  }
}

encodeVideo('ig-story-wpgg-v2-neon.mp4', (ctx, frame) => {
  drawNeonBackground(ctx, frame);
  drawNeonCoin(ctx, frame);
  drawNeonText(ctx, frame);
});
