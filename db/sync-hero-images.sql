-- Makes each new hero slide use the same photo as its title/stream (at hero size).
-- Run again after changing a title's image.
UPDATE hero_slides h
SET image_url = regexp_replace(t.image_url, 'w=\d+', 'w=1920')
FROM titles t
WHERE (h.title, t.id) IN (VALUES
  ('AVATAR: THE LAST AIRBENDER', 'c1'),
  ('ELDEN RING: OFFICIAL GAMEPLAY', 'g1'),
  ('PLANET EARTH II', 'p1'));

UPDATE hero_slides h
SET image_url = regexp_replace(g.thumbnail_url, 'w=\d+', 'w=1920')
FROM gameplay_streams g
WHERE h.title = 'ZED_GAMING LIVE: VALORANT RANKED' AND g.id = 'gl1';
