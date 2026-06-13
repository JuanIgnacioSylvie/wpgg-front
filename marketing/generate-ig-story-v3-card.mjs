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
  drawDotGrid,
  drawRoundedRect,
  encodeVideo,
} from './lib/shared.mjs';

setupFonts();
const coin = await loadCoin();

const steps = [
  { n: '01', title: 'Play LoL', body: 'Ranked or normal matches.' },
  { n: '02', title: 'Complete missions', body: 'Daily missions based on your play.' },
  { n: '03', title: 'Earn WPGG', body: 'Redeem RP or withdraw tokens.' },
];

function drawCardBackground(ctx, frame) {
  drawDotGrid(ctx);

  const glow = ctx.createRadialGradient(W * 0.5, H * 0.75, 0, W * 0.5, H * 0.75, W * 0.65);
  glow.addColorStop(0, 'rgba(173, 31, 15, 0.1)');
  glow.addColorStop(1, 'rgba(173, 31, 15, 0)');
  ctx.fillStyle = glow;
  ctx.fillRect(0, 0, W, H);
}

function drawCard(ctx, frame) {
  const cardT = easeOutBack(clamp(frame / 34, 0, 1));
  const cardW = 920;
  const cardH = 1180;
  const cardX = (W - cardW) / 2;
  const cardY = H * 0.22 + (1 - cardT) * 180;

  ctx.save();
  ctx.globalAlpha = cardT;

  drawRoundedRect(ctx, cardX, cardY, cardW, cardH, 32);
  ctx.fillStyle = colors.surface;
  ctx.fill();
  ctx.strokeStyle = colors.border;
  ctx.lineWidth = 2;
  ctx.stroke();

  ctx.fillStyle = colors.accent;
  ctx.fillRect(cardX, cardY, cardW, 6);

  ctx.font = '58px Wallpoet';
  ctx.fillStyle = colors.textPrimary;
  ctx.textAlign = 'left';
  ctx.fillText('WPGG', cardX + 48, cardY + 92);

  ctx.font = '24px LexendDecaMedium';
  ctx.fillStyle = colors.textSecondary;
  ctx.fillText('Well Played · Good Game', cardX + 48, cardY + 132);

  const coinSize = 200;
  const coinX = cardX + cardW - coinSize - 40;
  const coinY = cardY + 36 + Math.sin(frame * 0.06) * 6;
  ctx.shadowColor = 'rgba(173, 31, 15, 0.35)';
  ctx.shadowBlur = 24;
  ctx.drawImage(coin, coinX, coinY, coinSize, coinSize);
  ctx.shadowBlur = 0;

  ctx.font = '42px LexendDecaExtraBold';
  ctx.fillStyle = colors.textPrimary;
  ctx.textAlign = 'left';
  const headlineY = cardY + 220;
  ctx.fillText('If you play', cardX + 48, headlineY);
  ctx.fillStyle = colors.accentHover;
  ctx.fillText('League of Legends', cardX + 48, headlineY + 54);
  ctx.fillStyle = colors.textPrimary;
  ctx.fillText('you can earn WPGG', cardX + 48, headlineY + 108);

  let stepY = cardY + 380;
  for (let i = 0; i < steps.length; i++) {
    const stepT = easeOutCubic(clamp((frame - 30 - i * 14) / 22, 0, 1));
    if (stepT <= 0) continue;

    const step = steps[i];
    const offsetX = (1 - stepT) * 40;

    ctx.save();
    ctx.globalAlpha = stepT;
    ctx.translate(offsetX, 0);

    drawRoundedRect(ctx, cardX + 40, stepY, cardW - 80, 130, 18);
    ctx.fillStyle = colors.surfaceElevated;
    ctx.fill();
    ctx.strokeStyle = colors.border;
    ctx.lineWidth = 1.5;
    ctx.stroke();

    ctx.font = '22px LexendDecaBold';
    ctx.fillStyle = colors.accent;
    ctx.fillText(step.n, cardX + 68, stepY + 42);

    ctx.font = '30px LexendDecaBold';
    ctx.fillStyle = colors.textPrimary;
    ctx.fillText(step.title, cardX + 68, stepY + 78);

    ctx.font = '22px LexendDecaMedium';
    ctx.fillStyle = colors.textSecondary;
    ctx.fillText(step.body, cardX + 68, stepY + 108);

    ctx.restore();
    stepY += 150;
  }

  const badgeT = easeOutCubic(clamp((frame - 88) / 24, 0, 1));
  if (badgeT > 0) {
    const badgeW = cardW - 80;
    const badgeH = 88;
    const badgeX = cardX + 40;
    const badgeY = cardY + cardH - badgeH - 48;

    ctx.save();
    ctx.globalAlpha = badgeT;
    drawRoundedRect(ctx, badgeX, badgeY, badgeW, badgeH, 22);
    ctx.fillStyle = 'rgba(34, 197, 94, 0.12)';
    ctx.fill();
    ctx.strokeStyle = 'rgba(34, 197, 94, 0.4)';
    ctx.lineWidth = 2;
    ctx.stroke();

    ctx.font = '30px LexendDecaExtraBold';
    ctx.fillStyle = colors.online;
    ctx.textAlign = 'center';
    ctx.fillText('Completely free · No entry fee', W / 2, badgeY + 54);
    ctx.restore();
  }

  ctx.restore();
}

encodeVideo('ig-story-wpgg-v3-card.mp4', (ctx, frame) => {
  drawCardBackground(ctx, frame);
  drawCard(ctx, frame);
});
