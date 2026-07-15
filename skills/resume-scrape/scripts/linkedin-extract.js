// Extract one LinkedIn job posting. Run with: browse eval <this-file>
//
// LinkedIn's job pages are server-driven UI with hashed class names (_5cd6b1ec,
// e219f9e8, ...) that change without notice, so this anchors on things that survive a
// redesign: the document title, the "About the job" heading, and data-testid hooks.
// The old classic selectors (#job-details, .jobs-description__content,
// .job-details-jobs-unified-top-card__company-name) no longer exist — don't reach for
// them.
(() => {
  const clean = s => (s || '').replace(/\r/g, '').replace(/\n{3,}/g, '\n\n').trim();
  const bodyLines = document.body.innerText.split('\n').map(s => s.trim()).filter(Boolean);

  // Title shape: "<title> | <company> | LinkedIn". Agency listings omit the company
  // segment, leaving "<title> | LinkedIn".
  const parts = document.title.split(' | ').map(s => s.trim()).filter(Boolean);
  const isLI = parts[parts.length - 1] === 'LinkedIn';
  let company = null, title = null;
  if (isLI && parts.length >= 3) {
    company = parts[parts.length - 2];
    title = parts.slice(0, parts.length - 2).join(' | ');
  } else if (isLI && parts.length === 2) {
    title = parts[0];
  }

  if (!title) {
    title = [...document.querySelectorAll('h1,h2')]
      .map(x => x.innerText.trim())
      .find(t => t && !/notification|about the|people you|set alert/i.test(t)) || null;
  }

  // Company fallback: the employer usually renders directly above the title, but so
  // does nav chrome, and the title itself is sometimes repeated there. A wrong company
  // is worse than a missing one — leave it null unless the candidate looks real.
  const CHROME = /^(retry premium|home|my network|jobs|messaging|notifications|me|for business|skip to|premium|\d+ notifications?)/i;
  if (title && !company) {
    const cand = bodyLines[bodyLines.indexOf(title) - 1];
    const bad = !cand || CHROME.test(cand) || cand.includes(title) || title.includes(cand);
    if (!bad) company = cand;
  }

  // JD body: anchor on the "About the job" heading, then walk up to the first ancestor
  // holding real content.
  let jd = null;
  const heading = [...document.querySelectorAll('h1,h2,h3')]
    .find(x => /about the job/i.test(x.innerText));
  if (heading) {
    let n = heading;
    for (let i = 0; i < 6 && n; i++) {
      n = n.parentElement;
      if (n && n.innerText.trim().length > 400) { jd = n.innerText; break; }
    }
    if (jd) jd = jd.replace(/^\s*About the job\s*/i, '');
  }

  // Meta line ("Dhaka, Bangladesh · 2 weeks ago · Over 100 applicants") sits just under
  // the title. Fall back to the first bulleted meta line in the top card, since the
  // body's title text doesn't always match document.title exactly.
  let location = null;
  if (title) {
    const i = bodyLines.indexOf(title);
    if (i > -1) {
      for (let j = i + 1; j < Math.min(i + 6, bodyLines.length); j++) {
        if (bodyLines[j].includes('·')) { location = bodyLines[j]; break; }
      }
    }
  }
  if (!location) {
    location = bodyLines.slice(0, 30).find(l => l.includes('·') && l.length > 8) || null;
  }

  return {
    url: window.location.href.split('?')[0],
    title,
    company,
    location,
    jd: clean(jd),
    jdLen: clean(jd).length,
  };
})()
