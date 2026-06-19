#!/usr/bin/env node
import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);
const toIco = require('to-ico');

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const assets = join(root, 'assets', 'images');
const out = join(root, 'web', 'favicon.ico');

const pngs = ['16x16', '32x32'].map((size) =>
  readFileSync(join(assets, `wpgg-coin_${size}.png`)),
);
const ico = await toIco(pngs);
writeFileSync(out, ico);
console.log(`Wrote ${out} (${ico.length} bytes)`);
