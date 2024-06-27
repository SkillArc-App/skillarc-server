const express = require("express");
const puppeteer = require("puppeteer");

const app = express();
app.use(express.json());
const port = 3002;

const browserPromise = puppeteer.launch({
  executablePath: "/usr/bin/chromium",
  headless: "new",
  args: ["--no-sandbox", "--disable-setuid-sandbox"],
});

const server = app.listen(port, () => {
  console.log(`Document export listening on port ${port}`);
});

app.post("/export/pdf", async (req, res) => {
  console.log("Document received processing...");

  try {
    const file = await createPdf(
      req.body.document,
      req.body.header,
      req.body.footer
    );

    res
      .type("pdf")
      .set("Content-Disposition", 'attachment; filename="document.pdf"')
      .send(file);
  } catch (e) {
    console.log(e);
    res.status(500).send(e.message);
  }
});

const createPdf = async (html, headerTemplate, footerTemplate) => {
  console.log("Loading environment");
  const browser = await browserPromise;
  const page = await browser.newPage();
  await page.setViewport({ width: 1280, height: 1024 });

  console.log("Painting document");
  await page.setContent(html);

  console.log("Export as pdf");
  const pdfOption = {
    format: "A4",
    displayHeaderFooter: true,
    margin: { top: "10mm", right: "15mm", bottom: "10mm", left: "15mm" },
    printBackground: true,
  }

  if (!!headerTemplate) {
    pdfOption.headerTemplate = headerTemplate
  }

  if (!!footerTemplate) {
    pdfOption.footerTemplate = footerTemplate
  }

  const pdf = await page.pdf(pdfOption);

  await page.close();

  return pdf;
};

// Handle shutdown signals
const shutdown = (signal) => {
  console.log(`Received ${signal}. Shutting down gracefully...`);
  server.close(() => {
    console.log('Closed out remaining connections.');
    process.exit(0);
  });

  // Forcefully close server after 10 seconds
  setTimeout(() => {
    console.error('Forcing shutdown after 10 seconds.');
    process.exit(1);
  }, 10000);
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
