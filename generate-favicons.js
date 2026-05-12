const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

const sites = ['kache.pro','mneniyaplus.life','ocenkiru.life','otzyvy.space','ratespot.org','rating-ru.cc','technow.cc'];

// Sizes: 32 for browser tab, 120 for Yandex, 180 for apple-touch-icon, 192/512 for PWA
const sizes = [32, 120, 180, 192, 512];

(async () => {
  for (const dir of sites) {
    const svgPath = path.join('d:/newAce', dir, 'favicon.svg');
    const svgBuf = fs.readFileSync(svgPath);
    for (const size of sizes) {
      const outPath = path.join('d:/newAce', dir, `favicon-${size}.png`);
      await sharp(svgBuf, { density: 600 })
        .resize(size, size)
        .png({ compressionLevel: 9 })
        .toFile(outPath);
    }
    // Generate a proper 32x32 ICO (Sharp's PNG output is also accepted by browsers when served as ICO,
    // but to be safe we'll keep the existing .ico for now; many browsers fall back to PNG link tags)
    console.log(dir.padEnd(22) + ' → favicon-{32,120,180,192,512}.png generated');
  }
})().catch(e => { console.error(e); process.exit(1); });
