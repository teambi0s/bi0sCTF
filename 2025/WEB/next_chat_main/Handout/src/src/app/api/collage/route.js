import sharp from 'sharp';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth/next';
import fs from 'fs';
import path from 'path';
import { authOptions } from '../auth/[...nextauth]/route';

let imageContent = null;

export async function GET(req) {
  const session = await getServerSession(authOptions);
  if (!session?.user?.id) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { searchParams } = new URL(req.url);
  const fileUrls = searchParams.get('urls')?.split(',').filter(Boolean) || [];
  const background = searchParams.get('background') === 'true' || false;

  if (!fileUrls.length) {
    return NextResponse.json({ error: 'No valid image URLs provided' }, { status: 400 });
  }

  const match = fileUrls[0].match(/\/api\/get-file\/([^/]+)\/([^/]+)$/);
  if (!match) {
    return NextResponse.json({ error: 'Invalid URL format' }, { status: 400 });
  }
  const entityId = match[1];

  if (!entityId || entityId !== session.user.id) {
    return NextResponse.json({ error: 'User not part of conversation or group' }, { status: 403 });
  }

  const imageSize = 300;
  const tileSize = background ? 270 : imageSize;
  const results = [];
  const dominant = [];

  for (const url of fileUrls) {
    const urlMatch = url.match(/\/api\/get-file\/([^/]+)\/([^/]+)$/);
    if (!urlMatch) {
      return NextResponse.json({ error: `Invalid URL format: ${url}` }, { status: 400 });
    }
    const [, , filename] = urlMatch;

    const localImagePath = path.join(process.cwd(), 'uploads', entityId, filename);

    if (!fs.existsSync(localImagePath)) {
      return NextResponse.json({ error: `Image not found: ${filename}` }, { status: 404 });
    }

    imageContent = fs.readFileSync(localImagePath);
    if (background) {
      const stats = await sharp(imageContent).stats();
      dominant.push(stats.channels.map(c => Math.round(c.mean)));
    }

    const resized = await sharp(imageContent)
      .resize(tileSize, tileSize)
      .toBuffer();
    results.push(resized);
  }

  const numImages = results.length;
  const cols = numImages === 2 || numImages === 4 ? 2 : numImages === 3 ? 3 : Math.ceil(Math.sqrt(numImages));
  const rows = numImages === 2 || numImages === 4 ? 2 : numImages === 3 ? 2 : Math.ceil(numImages / cols);
  const width = imageSize * cols;
  const height = imageSize * rows;

  const avgColor = dominant.length
    ? dominant.reduce((acc, rgb) => acc.map((c, i) => c + rgb[i]), [0, 0, 0])
        .map(v => Math.round(v / dominant.length))
    : [0, 0, 0];

  const bg = background
    ? { r: avgColor[0], g: avgColor[1], b: avgColor[2], alpha: 1 }
    : { r: 0, g: 0, b: 0, alpha: 0.4 };

  const offset = background ? (imageSize - tileSize) / 2 : 0;

  const gridBuffer = await sharp({
    create: { width, height, channels: 4, background: bg },
  })
    .png()
    .composite(
      results.map((img, idx) => ({
        input: img,
        top: Math.round(Math.floor(idx / cols) * imageSize + offset),
        left: Math.round((idx % cols) * imageSize + offset),
      }))
    )
    .png()
    .toBuffer();

  const finalDim = Math.max(width, height);
  const padded = await sharp(gridBuffer)
    .extend({
      top: 0,
      bottom: finalDim - height,
      left: 0,
      right: finalDim - width,
      background: bg,
    })
    .png()
    .toBuffer();

  return new Response(padded, {
    headers: { 'Content-Type': 'image/png' },
  });
}