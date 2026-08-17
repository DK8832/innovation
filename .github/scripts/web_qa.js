const { chromium } = require('playwright');

const sizes = [
  {name:'phone-320', width:320, height:720},
  {name:'phone-360', width:360, height:800},
  {name:'phone-390', width:390, height:844},
  {name:'phone-430', width:430, height:932},
  {name:'tablet-768', width:768, height:1024},
  {name:'desktop-1440', width:1440, height:1000},
];

(async () => {
  const browser = await chromium.launch({headless:true});
  for (const s of sizes) {
    const page = await browser.newPage({viewport:{width:s.width,height:s.height}});
    await page.goto('http://127.0.0.1:8765/index.html', {waitUntil:'networkidle'});
    await page.waitForTimeout(500);
    const result = await page.evaluate(() => {
      const nav = document.querySelector('.floating-nav').getBoundingClientRect();
      return {
        innerWidth: window.innerWidth,
        scrollWidth: document.documentElement.scrollWidth,
        navLeft: nav.left,
        navRight: nav.right,
        navWidth: nav.width,
      };
    });
    if (result.scrollWidth > result.innerWidth + 1) {
      throw new Error(`${s.name}: horizontal overflow ${result.scrollWidth} > ${result.innerWidth}`);
    }
    if (result.navLeft < -1 || result.navRight > result.innerWidth + 1) {
      throw new Error(`${s.name}: nav outside viewport ${JSON.stringify(result)}`);
    }
    await page.screenshot({path:`${process.env.GITHUB_WORKSPACE}/qa-${s.name}.png`, fullPage:true});
    console.log(`${s.name}: OK`, result);
    await page.close();
  }
  await browser.close();
})().catch(e => { console.error(e); process.exit(1); });
