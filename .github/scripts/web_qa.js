const { chromium } = require('playwright');
const path = require('path');
const { pathToFileURL } = require('url');

const sizes = [
  {name:'phone-320', width:320, height:720},
  {name:'phone-360', width:360, height:800},
  {name:'phone-390', width:390, height:844},
  {name:'phone-430', width:430, height:932},
  {name:'tablet-768', width:768, height:1024},
  {name:'desktop-1440', width:1440, height:1000},
];

(async () => {
  const workspace = process.env.GITHUB_WORKSPACE;
  if (!workspace) throw new Error('GITHUB_WORKSPACE is missing');
  const siteUrl = pathToFileURL(path.join(workspace, '웹', 'frontend', 'index.html')).href;
  const browser = await chromium.launch({headless:true});
  for (const s of sizes) {
    const page = await browser.newPage({viewport:{width:s.width,height:s.height}});
    await page.goto(siteUrl, {waitUntil:'domcontentloaded'});
    await page.waitForTimeout(800);
    const result = await page.evaluate(() => {
      const navElement = document.querySelector('.floating-nav');
      if (!navElement) throw new Error('floating navigation not found');
      const nav = navElement.getBoundingClientRect();
      return {
        innerWidth: window.innerWidth,
        scrollWidth: document.documentElement.scrollWidth,
        bodyScrollWidth: document.body.scrollWidth,
        navLeft: nav.left,
        navRight: nav.right,
        navWidth: nav.width,
      };
    });
    const widest = Math.max(result.scrollWidth, result.bodyScrollWidth);
    if (widest > result.innerWidth + 1) {
      throw new Error(`${s.name}: horizontal overflow ${widest} > ${result.innerWidth}`);
    }
    if (result.navLeft < -1 || result.navRight > result.innerWidth + 1) {
      throw new Error(`${s.name}: nav outside viewport ${JSON.stringify(result)}`);
    }
    await page.screenshot({path:`${workspace}/qa-${s.name}.png`, fullPage:true});
    console.log(`${s.name}: OK`, result);
    await page.close();
  }
  await browser.close();
})().catch(e => { console.error(e); process.exit(1); });
