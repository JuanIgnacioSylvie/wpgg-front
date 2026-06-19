#!/usr/bin/env node
/**
 * Generates icon-48.png and favicon.ico for Google/crawlers.
 *
 * Google's favicon pipeline corrupts ICO files built with PNG-in-ICO containers
 * (to-ico / png-to-ico). Serving a crisp 48×48 PNG at both paths works reliably.
 */
import { writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);
const sharp = require('sharp');

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const assets = join(root, 'assets', 'images');
const web = join(root, 'web');
const src = join(assets, 'wpgg-coin_192x192.png');
const icon48 = join(web, 'icons', 'icon-48.png');
const faviconIco = join(web, 'favicon.ico');

const png48 = await sharp(src)
  .resize(48, 48, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
  .png()
  .toBuffer();

writeFileSync(icon48, png48);
writeFileSync(faviconIco, png48);

console.log(`Wrote ${icon48} (${png48.length} bytes)`);
console.log(`Wrote ${faviconIco} (${png48.length} bytes, PNG)`);
