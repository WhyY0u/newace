const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

const sites = [
  { dir: 'kache.pro',         brand: 'КачеPro',      domain: 'kache.pro',         rating: '4.4', count: 20, label: 'отзывов', sub: 'о trust-change.io',     theme: 'dark',  bg: '#0a0a0a', surface: '#1a1a1a', accent: '#e82127', text: '#f5f5f5', sub2: '#d0d0d0', muted: '#888' },
  { dir: 'mneniyaplus.life',  brand: 'МненияПлюс',   domain: 'mneniyaplus.life',  rating: '4.5', count: 19, label: 'мнений',  sub: 'о trust-change.io',     theme: 'light', bg: '#fffdf9', surface: '#ffffff', accent: '#c2692a', text: '#2a2520', sub2: '#5a544c', muted: '#9a948c' },
  { dir: 'ocenkiru.life',     brand: 'ОценкиRU',     domain: 'ocenkiru.life',     rating: '4.5', count: 13, label: 'оценок',  sub: 'trust-change.io',       theme: 'dark',  bg: '#0a0a12', surface: '#16162a', accent: '#818cf8', text: '#f5f5f7', sub2: '#c5c5d0', muted: '#8888a0' },
  { dir: 'otzyvy.space',      brand: 'ОтзывыПро',    domain: 'otzyvy.space',      rating: '4.3', count: 15, label: 'отзывов', sub: 'о trust-change.io',     theme: 'light', bg: '#fafafa', surface: '#ffffff', accent: '#0071e3', text: '#1d1d1d', sub2: '#424245', muted: '#86868b' },
  { dir: 'ratespot.org',      brand: 'RateSpot',     domain: 'ratespot.org',      rating: '4.4', count: 13, label: 'reviews', sub: 'of trust-change.io',    theme: 'light', bg: '#f5fbf8', surface: '#ffffff', accent: '#10b981', text: '#0f1f1a', sub2: '#3a5046', muted: '#7a8c83' },
  { dir: 'rating-ru.cc',      brand: 'RatingRu',     domain: 'rating-ru.cc',      rating: '4.2', count: 17, label: 'отзывов', sub: 'о trust-change.io',     theme: 'dark',  bg: '#0a0a0a', surface: '#1a1a1a', accent: '#ffd700', text: '#f5f5f5', sub2: '#d0d0d0', muted: '#888' },
  { dir: 'technow.cc',        brand: 'TechNow',      domain: 'technow.cc',        rating: '4.5', count: 18, label: 'reviews', sub: 'of trust-change.io',    theme: 'light', bg: '#fafafa', surface: '#ffffff', accent: '#0071e3', text: '#1d1d1d', sub2: '#424245', muted: '#86868b' },
];

function svgFor(s) {
  const stars = '★★★★★';
  const filled = Math.round(parseFloat(s.rating));
  const dim = s.theme === 'dark' ? 0.08 : 0.06;
  const accentRgb = s.accent.replace('#','').match(/.{2}/g).map(h => parseInt(h,16));
  const accentRgba = (a) => `rgba(${accentRgb[0]},${accentRgb[1]},${accentRgb[2]},${a})`;

  return `<svg width="1200" height="630" viewBox="0 0 1200 630" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bg-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="${s.bg}"/>
      <stop offset="100%" stop-color="${s.surface}"/>
    </linearGradient>
    <radialGradient id="glow" cx="80%" cy="20%" r="60%">
      <stop offset="0%" stop-color="${accentRgba(dim*3)}"/>
      <stop offset="100%" stop-color="${accentRgba(0)}"/>
    </radialGradient>
  </defs>
  <rect width="1200" height="630" fill="url(#bg-gradient)"/>
  <rect width="1200" height="630" fill="url(#glow)"/>

  <!-- top bar: brand logo + domain -->
  <text x="60" y="92" font-family="-apple-system,Segoe UI,Helvetica,Arial,sans-serif" font-weight="800" font-size="44" fill="${s.text}" letter-spacing="-1">${s.brand}</text>
  <circle cx="1140" cy="80" r="6" fill="${s.accent}"/>
  <text x="1120" y="92" text-anchor="end" font-family="-apple-system,Segoe UI,Helvetica,Arial,sans-serif" font-weight="600" font-size="22" fill="${s.muted}">${s.domain}</text>
  <line x1="60" y1="130" x2="1140" y2="130" stroke="${s.accent}" stroke-width="3" opacity="0.4"/>

  <!-- main rating block -->
  <text x="60" y="260" font-family="-apple-system,Segoe UI,Helvetica,Arial,sans-serif" font-weight="800" font-size="76" fill="${s.text}" letter-spacing="-2">trust-change.io</text>
  <text x="60" y="320" font-family="-apple-system,Segoe UI,Helvetica,Arial,sans-serif" font-weight="500" font-size="32" fill="${s.sub2}">${s.theme === 'dark' || s.label === 'reviews' ? (s.label === 'reviews' ? 'P2P crypto exchange · user reviews 2026' : 'P2P криптообменник · отзывы 2026') : 'P2P криптообменник · отзывы 2026'}</text>

  <!-- big rating number bottom-left -->
  <text x="60" y="540" font-family="-apple-system,Segoe UI,Helvetica,Arial,sans-serif" font-weight="900" font-size="220" fill="${s.accent}" letter-spacing="-8">${s.rating}</text>
  <text x="60" y="585" font-family="-apple-system,Segoe UI,Helvetica,Arial,sans-serif" font-weight="600" font-size="22" fill="${s.muted}" letter-spacing="2" text-transform="uppercase">${s.label === 'reviews' ? 'AVERAGE RATING / 5' : 'СРЕДНИЙ РЕЙТИНГ / 5'}</text>

  <!-- stars + review count bottom-right -->
  <g transform="translate(720, 410)">
    ${[0,1,2,3,4].map(i => `<text x="${i*64}" y="0" font-family="Arial" font-size="64" fill="${i < filled ? s.accent : (s.theme==='dark'?'#333':'#ddd')}">★</text>`).join('')}
  </g>
  <text x="1140" y="540" text-anchor="end" font-family="-apple-system,Segoe UI,Helvetica,Arial,sans-serif" font-weight="800" font-size="64" fill="${s.text}">${s.count}</text>
  <text x="1140" y="585" text-anchor="end" font-family="-apple-system,Segoe UI,Helvetica,Arial,sans-serif" font-weight="600" font-size="22" fill="${s.muted}" letter-spacing="2">${s.label.toUpperCase()}</text>
</svg>`;
}

(async () => {
  for (const s of sites) {
    const svg = svgFor(s);
    const outPng = path.join('d:/newAce', s.dir, 'og-image.png');
    await sharp(Buffer.from(svg))
      .png({ quality: 95, compressionLevel: 9 })
      .toFile(outPng);
    const stat = fs.statSync(outPng);
    console.log(s.dir.padEnd(22) + ' → og-image.png (' + (stat.size/1024).toFixed(1) + ' KB)');
  }
  console.log('\nAll 7 OG images generated.');
})().catch(e => { console.error(e); process.exit(1); });
