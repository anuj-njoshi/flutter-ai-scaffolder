const express = require("express");
const fs = require("fs-extra");
const path = require("path");
const cors = require("cors");

const app = express();
app.use(cors()); // ✅ FIX
app.use(express.json());

app.post("/generate", async (req, res) => {
  try {
    const { name } = req.body;

    if (!name) {
      return res.status(400).json({ error: "App name required" });
    }

    // sanitize name
    const appName = name
      .toLowerCase()
      .replace(/[^a-z0-9]/g, "_");

    const output = path.join("output", appName);

    // remove old folder if exists
    await fs.remove(output);

    // copy template
    await fs.copy("../templates/base_app", output);

    // update pubspec.yaml
    const pubspecPath = path.join(output, "pubspec.yaml");

    let pubspec = await fs.readFile(pubspecPath, "utf8");

    pubspec = pubspec.replace(/name:\s*.*/g, `name: ${appName}`);

    await fs.writeFile(pubspecPath, pubspec);

    res.json({
      success: true,
      project: appName,
    });

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ✅ start server
app.listen(3000, () => {
  console.log("🚀 Server running on http://localhost:3000");
});