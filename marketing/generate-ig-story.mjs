import {
  W,
  H,
  TOTAL_FRAMES,
  colors,
  setupFonts,
  loadCoin,
  clamp,
  easeOutCubic,
  easeOutElastic,
  drawRoundedRect,
  encodeVideo,
} from './lib/shared.mjs';

setupFonts();
const coin = await loadCoin();

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
  ctx.fillText('Play League of Legends', W / 2, baseY + 78);

  ctx.font = '52px LexendDecaBold';
  ctx.fillStyle = colors.textPrimary;
  const line2 = 'Earn ';
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
  ctx.fillText('100% FREE', W / 2, badgeY + 38);

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

encodeVideo('ig-story-wpgg.mp4', (ctx, frame) => {
  drawDotGrid(ctx);
  drawAmbientGlow(ctx, frame);
  drawCoin(ctx, frame);
  drawTextBlock(ctx, frame);
  drawTopAccent(ctx);
});
